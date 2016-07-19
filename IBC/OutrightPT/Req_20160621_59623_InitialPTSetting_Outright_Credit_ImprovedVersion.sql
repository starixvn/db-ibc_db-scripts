

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
	WHERE srecommend = @srecommend  AND Enabled = 1 AND custid <= @maxcustid
	
	CREATE TABLE #cusT_comm (custid INT PRIMARY KEY, playerdiscount decimal(9,8), discount decimal(9,8), adiscount decimal(9,8), sdiscount decimal(9,8), groupa decimal(9,8), groupb decimal(9,8), groupc decimal(9,8), groupd decimal(9,8), groupe decimal(9,8), groupf decimal(9,8))
	
	CREATE TABLE #cusT_bet (custid INT ,sporttype SMALLINT, minbet MONEY, maxbet MONEY , PRIMARY KEY (custid,sporttype))
	
	INSERT INTO #cusT_comm (custid, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf)
	SELECT cs.custid, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf
	FROM custsetting cs WITH (NOLOCK) 
			INNER JOIN #DownlineListTemp t ON t.CustID = cs.custid
	WHERE cs.sporttype = 1 AND Bettype = 9999
					 
	INSERT INTO #cusT_bet (custid,sporttype, minbet, maxbet)
	SELECT cs.custid,cs.sporttype, MAX(minbet), MAX(maxbet)
	FROM custsetting cs WITH (NOLOCK) 
			INNER JOIN #DownlineListTemp t ON t.CustID = cs.custid
	WHERE cs.sporttype IN (2,3,5,8,10,11,99)			
	GROUP BY cs.custid,cs.sporttype
	
	INSERT INTO custsetting (custid, sporttype,Bettype,apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking
					, playerdiscount, discount, adiscount, sdiscount, groupa, groupb, groupc, groupd, groupe, groupf, minbet, maxbet
					, autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking	)
	
	SELECT t.custid, bet.sporttype,10,apositiontaking, mpositiontaking, spositiontaking, alivepositiontaking, mlivepositiontaking, slivepositiontaking
				, comm.playerdiscount, comm.discount, comm.adiscount, comm.sdiscount, comm.groupa, comm.groupb, comm.groupc, comm.groupd, comm.groupe, comm.groupf, bet.minbet, bet.maxbet
				, autopositiontaking, autolivepositiontaking, isautopositiontaking, isautolivepositiontaking, autompositiontaking, autolivempositiontaking, isautompositiontaking, isautolivempositiontaking
		FROM #DownlineListTemp t
			INNER JOIN custsetting cs (NOLOCK) ON t.CustID = cs.custid AND cs.sporttype = 1 AND cs.bettype = 10
			INNER JOIN #cusT_comm comm ON comm.custid = T.CustID 
			INNER JOIN #cusT_bet bet ON bet.custid = T.CustID 
		
	
	INSERT INTO custoverride (custid, bettype, sporttype, minpositiontaking, maxpositiontaking, minlivepositiontaking, maxlivepositiontaking)
	SELECT temp_pt.custid, bt.Bettype, bt.sporttype, minpositiontaking, maxpositiontaking, minlivepositiontaking, maxlivepositiontaking
	FROM #DownlineListTemp temp_pt
		INNER JOIN custoverride cs (NOLOCK) ON temp_pt.CustID = cs.custid
		CROSS JOIN #SportTypeBetType bt 
	WHERE cs.sporttype = 1 AND cs.bettype = 10
						 
	DROP TABLE #DownlineListTemp
	DROP TABLE #SportTypeBetType
	DROP TABLE #cusT_bet
	DROP TABLE #cusT_comm
	
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

