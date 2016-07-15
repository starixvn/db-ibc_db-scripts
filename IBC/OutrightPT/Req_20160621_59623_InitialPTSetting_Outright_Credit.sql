

/*
	Created: Helen
	Task: Initial PT setting on Outright of these 7 sports: Copied from Sport - HDP PT - [Redimine:59438]
	DB: DBCUST/CustDB
	Date: 20160621
	-- Credit SIT: max custid =  19996769
	-- Deposit SIT: 
*/ 

ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
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

	CREATE TABLE #DownlineListTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
	)
	
	CREATE TABLE #SportTypeBetType (SportType SMALLINT, Bettype SMALLINT)
	INSERT INTO #SportTypeBetType
	VALUES(2,10)
		,(3,10)
		,(5,10)
		,(8,10)
		,(10,10)
		,(11,10)
		,(99,10)
	
	INSERT INTO #DownlineListTemp (CustID)
	SELECT custid
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND Enabled = 1 AND custid <= @maxcustid
	
	INSERT INTO custsetting (custid, sporttype,Bettype,apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf, minbet, maxbet, autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking	)
	SELECT
			temp_pt.custid, temp_pt.sporttype,temp_pt.Bettype,apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking
			, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf, minbet, maxbet
			, autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking
	
	FROM 
		(SELECT t.custid, bt.sporttype,bt.Bettype,apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking
				,autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking
		FROM #DownlineListTemp t
			INNER JOIN custsetting cs (NOLOCK) ON t.CustID = cs.custid
			CROSS JOIN #SportTypeBetType bt 
		WHERE cs.sporttype = 1 AND cs.bettype = 10
		) AS temp_pt
		
		-- Commission
		CROSS APPLY (SELECT playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf
					 FROM custsetting cs WITH (NOLOCK) 
					 WHERE cs.Custid = temp_pt.custid AND cs.sporttype = 1 AND Bettype = 9999
					 ) AS temp_commsetting

		CROSS APPLY (SELECT TOP 1 minbet, maxbet
					 FROM custsetting cs WITH (NOLOCK) 
					 WHERE cs.Custid = temp_pt.custid AND cs.sporttype = temp_pt.SportType 
					 ) AS temp_betsetting
	
	INSERT INTO custoverride (custid, bettype, sporttype, minpositiontaking, maxpositiontaking, minlivepositiontaking, maxlivepositiontaking)
	SELECT temp_pt.custid, bt.Bettype, bt.sporttype, minpositiontaking, maxpositiontaking, minlivepositiontaking, maxlivepositiontaking
	FROM #DownlineListTemp temp_pt
		INNER JOIN custoverride cs (NOLOCK) ON temp_pt.CustID = cs.custid
		CROSS JOIN #SportTypeBetType bt 
	WHERE cs.sporttype = 1 AND cs.bettype = 10
						 
	DROP TABLE #DownlineListTemp
	DROP TABLE #SportTypeBetType
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
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
			
	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
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
			
	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.280'
END

