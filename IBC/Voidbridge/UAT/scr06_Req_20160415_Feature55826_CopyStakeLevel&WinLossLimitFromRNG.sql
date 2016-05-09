/*
	Created: Elodie
	Task: Copy PT & Comm & WinLossLimit for All Bet from Live Casino
	DB: DBCUST/CustDB
	Date: 20160226
*/ 

ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('CustStakeLevel_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustStakeLevel_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Member') = 0 RETURN		
	
	DECLARE @SportType SMALLINT, @BetType SMALLINT, @exchangeID INT, @DefaultLossLimit MONEY
	SELECT @SportType = 212, @BetType = 4001

	SELECT @exchangeID = currency FROM dbo.custinfo WITH(NOLOCK) WHERE custid = @srecommend
	SELECT @DefaultLossLimit = DefaultLossLimit FROM dbo.LossLimit_GlobalSetting WHERE ExchangeId = @exchangeID

	CREATE TABLE #MemberTemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		SyncCasino BIT
	)

	CREATE TABLE #SMATemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		roleid TINYINT,
		SyncCasino BIT
	)
	
	INSERT INTO #MemberTemp (CustID, SyncCasino)
	SELECT custid, SyncCasino
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid = 1  AND Enabled = 1 AND custid <= @maxcustid
	
	
	INSERT INTO #SMATemp (CustID, roleid, SyncCasino)
	SELECT custid, roleid, SyncCasino
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid IN (2,3,4) AND Enabled = 1 AND custid <= @maxcustid 

	--------------------------------------WinLossLimit-------------------------------------------------
	--SuperLevel
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT cs.custid, @SportType, @BetType	
		,CASE WHEN ci.SyncCasino = 0 THEN 0 ELSE cs.MaxWinLimit END AS MaxWinLimit
		,CASE WHEN ci.SyncCasino = 0 THEN @DefaultLossLimit ELSE cs.MaxLossLimit END AS MaxLossLimit
		,CASE WHEN ci.SyncCasino = 0 THEN 1 ELSE cs.IsAutoReset END AS IsAutoReset
	FROM dbo.CustWinLimit cs WITH (NOLOCK) 
		INNER JOIN #SMATemp ci WITH(NOLOCK)	ON ci.custid = cs.custid
	WHERE ci.custid = @srecommend AND cs.SportType = 208 AND cs.BetType = 2101
									
	--Master Level
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT cs.custid, @SportType, @BetType	
		,CASE	WHEN ci.SyncCasino  = 1 THEN cs.MaxWinLimit
				WHEN si.SyncCasino = 1 THEN ss.MaxWinLimit 
				ELSE 0 END AS MaxWinLimit
		,CASE	WHEN ci.SyncCasino  = 1 THEN cs.MaxLossLimit
				WHEN si.SyncCasino = 1 THEN ss.MaxLossLimit 
				ELSE @DefaultLossLimit END AS MaxLossLimit 
		,CASE	WHEN ci.SyncCasino  = 1 THEN cs.IsAutoReset
				WHEN si.SyncCasino = 1 THEN ss.IsAutoReset 
				ELSE 1 END AS IsAutoReset
	FROM dbo.CustWinLimit cs WITH(NOLOCK)	
		INNER JOIN CustInfo ci WITH (NOLOCK) ON ci.custid = cs.CustId		
		INNER JOIN #SMATemp si WITH (NOLOCK) ON ci.srecommend = si.custid
		INNER JOIN CustWinLimit ss WITH (NOLOCK) ON ss.CustId = ci.srecommend AND ss.BetType = cs.BetType AND ss.SportType = cs.SportType
	WHERE ci.srecommend = @srecommend AND ci.roleid = 3 AND cs.SportType = 208 AND cs.BetType = 2101

	--Agent Level
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT cs.custid, @SportType, @BetType	
		,CASE	WHEN ci.SyncCasino  = 1 THEN cs.MaxWinLimit
				WHEN mi.SyncCasino = 1 THEN ms.MaxWinLimit 
				WHEN si.SyncCasino = 1 THEN ss.MaxWinLimit 
				ELSE 0 END AS MaxWinLimit
		,CASE	WHEN ci.SyncCasino  = 1 THEN cs.MaxLossLimit
				WHEN mi.SyncCasino = 1 THEN ms.MaxLossLimit 
				WHEN si.SyncCasino = 1 THEN ss.MaxLossLimit 
				ELSE @DefaultLossLimit END AS MaxLossLimit 
		,CASE	WHEN ci.SyncCasino  = 1 THEN cs.IsAutoReset
				WHEN mi.SyncCasino = 1 THEN ms.IsAutoReset 
				WHEN si.SyncCasino = 1 THEN ss.IsAutoReset 
				ELSE 1 END AS IsAutoReset
	FROM dbo.CustWinLimit cs WITH(NOLOCK)	
		INNER JOIN dbo.custInfo ci WITH(NOLOCK)ON ci.custid = cs.CustId
		INNER JOIN #SMATemp mi WITH (NOLOCK) ON ci.mrecommend = mi.custid	
		INNER JOIN dbo.CustWinLimit ms WITH (NOLOCK) ON ms.CustId = mi.CustID AND ms.BetType = cs.BetType AND ms.SportType = cs.SportType
		INNER JOIN #SMATemp si WITH (NOLOCK) ON ci.srecommend = si.custid
		INNER JOIN dbo.CustWinLimit ss WITH (NOLOCK) ON ss.CustId = si.CustID AND ss.BetType = cs.BetType AND ss.SportType = cs.SportType
	WHERE ci.srecommend = @srecommend AND ci.roleid = 2 AND cs.SportType = 208 AND cs.BetType = 2101
	
	--Member Level
	INSERT INTO dbo.CustWinLossLimit_Member(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT cs.custid, @SportType, @BetType	
		,CASE	WHEN ci.SyncCasino  = 1 THEN cs.MaxWinLimit
				WHEN ai.SyncCasino = 1 THEN ags.MaxWinLimit 
				WHEN mi.SyncCasino = 1 THEN ms.MaxWinLimit 
				WHEN si.SyncCasino = 1 THEN ss.MaxWinLimit 
				ELSE 0 END AS MaxWinLimit
		,CASE	WHEN ci.SyncCasino  = 1 THEN cs.MaxLossLimit
				WHEN ai.SyncCasino = 1 THEN ags.MaxLossLimit 
				WHEN mi.SyncCasino = 1 THEN ms.MaxLossLimit 
				WHEN si.SyncCasino = 1 THEN ss.MaxLossLimit 
				ELSE @DefaultLossLimit END  AS MaxLossLimit 
		,CASE	WHEN ci.SyncCasino  = 1 THEN cs.IsAutoReset
				WHEN ai.SyncCasino = 1 THEN ags.IsAutoReset 
				WHEN mi.SyncCasino = 1 THEN ms.IsAutoReset 
				WHEN si.SyncCasino = 1 THEN ss.IsAutoReset 
				ELSE 1 END AS IsAutoReset
	FROM dbo.CustWinLimit cs WITH(NOLOCK)	
		INNER JOIN dbo.custInfo ci WITH(NOLOCK)ON ci.custid = cs.CustId
		INNER JOIN #SMATemp ai WITH (NOLOCK) ON ci.recommend = ai.custid	
		INNER JOIN dbo.CustWinLimit ags WITH (NOLOCK) ON ags.CustId = ai.CustID AND ags.BetType = cs.BetType AND ags.SportType = cs.SportType
		INNER JOIN #SMATemp mi WITH (NOLOCK) ON ci.mrecommend = mi.custid	
		INNER JOIN dbo.CustWinLimit ms WITH (NOLOCK) ON ms.CustId = mi.CustID AND ms.BetType = cs.BetType AND ms.SportType = cs.SportType
		INNER JOIN #SMATemp si WITH (NOLOCK) ON ci.srecommend = si.custid
		INNER JOIN dbo.CustWinLimit ss WITH (NOLOCK) ON ss.CustId = si.CustID AND ss.BetType = cs.BetType AND ss.SportType = cs.SportType
	WHERE ci.srecommend = @srecommend AND ci.roleid = 1 AND cs.SportType = 208 AND cs.BetType = 2101
	
	--------------------------------------StakeLevelGroup Setting-------------------------------------------------	
	--Get Lowest Group Level
	DECLARE @StakeLevelMem VARCHAR(100)
	DECLARE @StakeLevelSMA VARCHAR(100)
	
	;WITH cte AS
	(
		SELECT StakeLevelID,
			 ROW_NUMBER() OVER (ORDER BY GameGroupID) AS rn
		FROM dbo.StakeLevel WITH(NOLOCK) 
		WHERE ExchangeId = @exchangeID AND GameTypeID = @BetType 
	)
	SELECT @StakeLevelMem =  StakeLevelID 
	FROM cte
	WHERE rn = 1
	
	;WITH cte AS
	(
		SELECT StakeLevelID,
			 ROW_NUMBER() OVER (ORDER BY GameGroupID) AS rn
		FROM dbo.StakeLevel WITH(NOLOCK) 
		WHERE ExchangeId = @exchangeID AND GameTypeID = @BetType 
	)
	SELECT @StakeLevelSMA =   COALESCE(@StakeLevelSMA + ',', '') + CAST(StakeLevelID  AS VARCHAR(100))
	FROM cte
	WHERE rn IN (1,2)


	INSERT INTO dbo.CustStakeLevel_Agent(CustID, SportType, BetType, StakeLevelList)	
	SELECT CustID, @SportType, @BetType, @StakeLevelSMA
	FROM #SMATemp 

	INSERT INTO dbo.CustStakeLevel_Member(CustID, SportType, BetType, StakeLevelList)	
	SELECT CustID, @SportType, @BetType, @StakeLevelMem
	FROM #MemberTemp
	
	DROP TABLE #SMATemp
	DROP TABLE #MemberTemp
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
FROM CustInfo ci WITH(NOLOCK)
 INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
 INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
 LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
 AND ci.username NOT LIKE '3rdSuper%'
 AND cs.isinternal = 0
 AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
 AND s.islicensee = 0
 AND ci.custid <= @max_custid
 AND ci.currency IN (20)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustSetting3rd_09 @srecommend = @srecommend
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
FROM CustInfo ci WITH(NOLOCK)
 INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
 INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
 LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
 AND ci.username NOT LIKE '3rdSuper%'
 AND cs.isinternal = 0
 AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
 AND s.islicensee = 0
 AND ci.custid <= @max_custid
 AND ci.currency IN (20)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustSetting3rd_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
						
	waitfor delay '00:00:0.280'
END