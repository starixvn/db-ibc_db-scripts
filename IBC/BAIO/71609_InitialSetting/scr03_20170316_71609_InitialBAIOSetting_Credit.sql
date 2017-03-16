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
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('custsetting') = 0 RETURN
	IF dbo.f_CheckRepTable('custoverride') = 0 RETURN

	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('custsetting') = 0 RETURN
	IF dbo.f_CheckRepTable('custoverride') = 0 RETURN

	CREATE TABLE #DownlineListTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
		,RoleID INT
	)
	
	CREATE TABLE #ProfileVirtualSetting (sporttype SMALLINT,bettype SMALLINT,isLive BIT, ProfileID INT )

	INSERT INTO #ProfileVirtualSetting (sporttype,bettype,isLive,ProfileID)
	SELECT sporttype,bettype,isLive,ProfileID
	FROM ProfileVirtualSetting WITH (NOLOCK) 
	WHERE sporttype = 2 AND bettype IN (20,21) 

	DECLARE @Sporttype SMALLINT = 2, @Bettype SMALLINT = 9999, @SporttypeRef SMALLINT = 2, @BettypeRef SMALLINT = 1
	
	INSERT INTO #DownlineListTemp (CustID,RoleID)
	SELECT custid,roleid
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND Enabled = 1 AND custid <= @maxcustid
	
	------------------------------------ PT/Bet/Com Setting -------------------------------------------------------------
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
	
	------------------------------------ Vitual Rate Setting -------------------------------------------------------------
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
													INNER JOIN ProfileVirtualSetting pvs_ref WITH(NOLOCK) ON cvs_ref.seqNo = pvs_ref.seqNo AND pvs_ref.islive = ipvs.islive
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
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM customer ci WITH (NOLOCK) 
	INNER JOIN site s WITH (NOLOCK) ON ci.site = s.site
	INNER JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
	AND ci.username NOT LIKE '3rdSuper%'
	AND cs.isinternal = 0
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND s.islicensee = 0
	AND ci.custid <= @max_custid

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.[Acc_CustSetting_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM customer ci WITH (NOLOCK) 
	INNER JOIN site s WITH (NOLOCK) ON ci.site = s.site
	INNER JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
	AND ci.username NOT LIKE '3rdSuper%'
	AND cs.isinternal = 0
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND s.islicensee = 0
	AND ci.custid <= @max_custid
 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.[Acc_CustSetting_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.280'
END

