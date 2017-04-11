/*
	Created: 20170316@Helen
	Task: [BAIO] - Customer Setting - https://nexdev.net/issues/71609
	DB: DBCUST/CustDB
	
	/*
		1. PT: When inserting initial data, shall copy from Basketball - Handicap. 
		2. Virtual Rate Setting: When inserting initial data, shall copy from Basketball (Sporttype = 2)- HDP bettype (1) (for Moneyline) and Basketball - 1st HDP (for 1st Moneyline)
			Requirements:Sporttype = 2
			For bettype 20: copy from bettype 1 (HDP)
			For bettype 21: copy from bettype 7 (First HDP)
	*/
	
*/ 
ALTER PROCEDURE [dbo].[Acc_CustSetting_19]
	@srecommend INT	
	,@maxcustid INT
	,@IsLicensee BIT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('custsetting') = 0 RETURN
	IF dbo.f_CheckRepTable('custoverride') = 0 RETURN

	IF dbo.f_CheckRepTable('CustVirtualSetting') = 0 RETURN
	IF dbo.f_CheckRepTable('ProfileVirtualSetting') = 0 RETURN
	

	CREATE TABLE #DownlineListTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
		,RoleID INT
	)
	
	CREATE TABLE #ProfileVirtualSetting (sporttype SMALLINT,bettype SMALLINT,isLive BIT, ProfileID INT )
	
	CREATE TABLE #ProfileVirtualSetting_all (sporttype SMALLINT,bettype SMALLINT,isLive BIT, seqNo INT,ProfileID INT, CONSTRAINT ProfileVirtualSetting_all_PK PRIMARY KEY CLUSTERED( sporttype, bettype, seqNo ))

	INSERT INTO #ProfileVirtualSetting (sporttype,bettype,isLive,ProfileID)
	SELECT sporttype,bettype,isLive,ProfileID
	FROM ProfileVirtualSetting WITH (NOLOCK) 
	WHERE sporttype = 2 AND bettype IN (20,21) 

	INSERT INTO #ProfileVirtualSetting_all (sporttype,bettype,isLive,seqNo,ProfileID)
	SELECT sporttype,bettype,isLive,seqNo,ProfileID
	FROM ProfileVirtualSetting WITH (NOLOCK)
	
	DECLARE @Sporttype SMALLINT = 2, @Bettype SMALLINT = 9999, @SporttypeRef SMALLINT = 2, @BettypeRef SMALLINT = 1
	
	INSERT INTO #DownlineListTemp (CustID,RoleID)
	SELECT custid,roleid
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND Enabled = 1 AND custid <= @maxcustid
	
	------------------------------------ PT/Bet/Com Setting -------------------------------------------------------------
	IF @IsLicensee = 0 -- CREDIT
	BEGIN
	
		INSERT INTO custsetting (custid, sporttype,Bettype,apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf, minbet, maxbet, autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking	)
		SELECT
				cs.custid, @Sporttype,@Bettype,apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking
				, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf, minbet, maxbet
				, autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking
		FROM custsetting cs (NOLOCK) 
				INNER JOIN #DownlineListTemp t ON cs.custid = t.CustID
			WHERE cs.sporttype = @SporttypeRef AND cs.bettype = @BettypeRef
			
		INSERT INTO custoverride (custid, bettype, sporttype, minpositiontaking, maxpositiontaking, minlivepositiontaking, maxlivepositiontaking)
		SELECT cs.custid, @Bettype, @Sporttype, minpositiontaking, maxpositiontaking, minlivepositiontaking, maxlivepositiontaking
		FROM custoverride cs
			INNER JOIN #DownlineListTemp t (NOLOCK) ON t.CustID = cs.custid AND RoleID IN (2,3,4)
		WHERE cs.sporttype = @SporttypeRef AND cs.bettype = @BettypeRef
	END
	
	------------------------------------ CREDIT & DEPOSIT: Vitual Rate Setting -------------------------------------------------------------
	UPDATE cvs
		SET bitmapVirtual = (SELECT TOP 1 bitmap FROM dbo.f_GenerateVirtualSetting_multiple(cvs.bitmapVirtual, CONVERT(VARCHAR(MAX),Result.virtualXML))) 
	FROM CustVirtualSetting	AS cvs WITH (UPDLOCK, ROWLOCK)
		INNER JOIN	#DownlineListTemp AS ci WITH (NOLOCK)	ON	ci.custid = cvs.custid 
			CROSS APPLY( SELECT(
								SELECT	ipvs.profileID			AS '@p',
										dbo.f_GetVirtualSetting(T.bitmapVirtual, T.profileID) AS '@v'
								FROM #ProfileVirtualSetting	AS ipvs WITH (NOLOCK)
									-- GET profileID of bettype Ref
									CROSS APPLY (SELECT pvs_ref.profileID,cvs_ref.bitmapVirtual 
												 FROM CustVirtualSetting cvs_ref WITH (NOLOCK)
													INNER JOIN #ProfileVirtualSetting_all pvs_ref WITH(NOLOCK) ON cvs_ref.seqNo = pvs_ref.seqNo AND pvs_ref.islive = ipvs.islive
												 WHERE cvs_ref.custid = CVS.custid 
														 AND pvs_ref.sporttype = 2 
														 AND pvs_ref.bettype = (CASE WHEN ipvs.bettype = 20 THEN 1 ELSE 7 END)
												) AS T
								
								WHERE ipvs.sporttype = 2 AND ipvs.bettype IN (20,21)
								
								FOR XML PATH ('r'),	TYPE
							)
						FOR XML PATH ('root'),	TYPE
					) AS Result (virtualXML)
			
	WHERE CVS.seqNo = 3
	
	DROP TABLE #DownlineListTemp
	DROP TABLE #ProfileVirtualSetting
	
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0), IsLicensee BIT)

DECLARE @max_custid INT, @srecommend INT, @IsLicensee BIT

SELECT @max_custid = xxx

INSERT INTO #supers(custid,IsLicensee)
SELECT ci.custid, CASE WHEN csd.custid IS NULL THEN 0 ELSE 1 END AS IsLicensee
FROM customer ci WITH (NOLOCK) 
	LEFT JOIN Dep_CustSuper CSD WITH(NOLOCK) ON CSD.custid = ci.custid
WHERE ci.roleid = 4  
	AND ci.custid <= @max_custid

-- For Deployer Info
DECLARE @super_cnt INT, @index INT = 0

SET @super_cnt = (SELECT COUNT(*) FROM #supers )

DECLARE @msg nvarchar(200) = 'Currently at order %d, SuperID: %d.'

DECLARE @msg_total nvarchar(200) = 'Total of supers: %d.'

RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		,@IsLicensee = IsLicensee
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	SET @index = @index + 1
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
			
	EXEC dbo.[Acc_CustSetting_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@IsLicensee = @IsLicensee
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0),IsLicensee BIT)

DECLARE @max_custid INT, @srecommend INT,@IsLicensee BIT

SELECT @max_custid = xxx

INSERT INTO #supers(custid,IsLicensee)
SELECT ci.custid, CASE WHEN csd.custid IS NULL THEN 0 ELSE 1 END AS IsLicensee
FROM customer ci WITH (NOLOCK) 
	LEFT JOIN Dep_CustSuper CSD WITH(NOLOCK) ON CSD.custid = ci.custid
WHERE ci.roleid = 4  
	AND ci.custid <= @max_custid
 

-- For Deployer Info
DECLARE @super_cnt INT, @index INT = 0

SET @super_cnt = (SELECT COUNT(*) FROM #supers )

DECLARE @msg nvarchar(200) = 'Currently at order %d, SuperID: %d.'

DECLARE @msg_total nvarchar(200) = 'Total of supers: %d.'

RAISERROR (@msg_total, 0, 1, @super_cnt) WITH NOWAIT

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid
		,@IsLicensee = IsLicensee	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	SET @index = @index + 1
	RAISERROR (@msg, 0, 1,@index, @srecommend) WITH NOWAIT
			
	EXEC dbo.[Acc_CustSetting_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@IsLicensee = @IsLicensee
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.280'
END

