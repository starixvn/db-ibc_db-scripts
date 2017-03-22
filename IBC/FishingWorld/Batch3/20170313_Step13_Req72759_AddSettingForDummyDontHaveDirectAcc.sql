
/*
	Created: Winnie 
	Task: Insert for 4 ACC (113125,10818,490221,3607) and dummies don't have direct acc
	DB: DBCUST/CustDB
	Date: 20170322
*/ 
DECLARE @Sporttype INT, @Bettype INT, @SporttypeRef INT, @BettypeRef INT,@MaxPT TINYINT,@ProductID INT

SELECT @Sporttype = 219, @Bettype = 1011, @SporttypeRef = 161,@BettypeRef=85,@ProductID=24
SELECT @MaxPT= MaxPT from ProductSettingDetail WITH(NOLOCK) where SportType=@Sporttype and BetType=@Bettype and SettingType=1
DECLARE @BitOrder INT
	SELECT @BitOrder= bitmapOrder from ProductStatusProfile WITH(NOLOCK) where SportType=@Sporttype
CREATE TABLE #DummyTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
		,exchangeid INT
	)


CREATE TABLE #CustTemp
	(
		CustID INT PRIMARY KEY CLUSTERED	
		,RoleID INT
	)

CREATE TABLE #DummyTempbatch3
	(
		CustID INT PRIMARY KEY CLUSTERED		
	)

	CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY,roleid INT)
	CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY,mrecommend INT,roleid INT)
	CREATE TABLE #DirectMember (CustID INT PRIMARY KEY,recommend INT,mrecommend INT,roleid INT)	
	-- insert #custtemp
		INSERT INTO #CustTemp (CustID,RoleID)
		SELECT	113125,2
		UNION 	
		SELECT	10818,2
		UNION 	
		SELECT	490221,3
		UNION 	
		SELECT	3607,2
		UNION
		select DISTINCT custid,roleid from Acc_CustDirect with(nolock) WHERE custid not in
			( 
			SELECT ci.srecommend
				FROM Customer ci with(nolock)
				INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
				WHERE 	
					 ci.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
					and ci.srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
					and ci.roleid=3 
					AND c.Enabled=1
		
				UNION
				SELECT ci.mrecommend
				FROM Customer ci WITH(NOLOCK)
				INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
				WHERE
					 ci.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
					and ci.mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
					and ci.roleid=2 
					AND c.Enabled=1

				UNION
				SELECT c.recommend
				FROM Customer c WITH(NOLOCK)	
				INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid=c.custid
				WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
					AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
					AND c.roleid=1 
					AND ci.Enabled=1)
					AND custid>100
					AND roleid<>4

	--- get direct master
	INSERT INTO #DirectMaster (CustID,roleid)
	SELECT ci.custid, ci.roleid
	FROM Customer ci with(nolock)
	INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
	WHERE  site in  ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
		and ci.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and ci.srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and ci.roleid=3 
		AND c.Enabled=1
		
	--- get direct agent
	INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
	SELECT ci.custid, ci.mrecommend,ci.roleid
	FROM Customer ci WITH(NOLOCK)
	INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
	WHERE site in  ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
		and ci.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and ci.mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		and ci.roleid=2 
		AND c.Enabled=1

	INSERT INTO #DirectMember(CustID,recommend,mrecommend,roleid)
	SELECT c.custid, c.recommend,c.mrecommend,c.roleid
	FROM Customer c WITH(NOLOCK)
	INNER JOIN Customer ca (nolock) on c.recommend=ca.custid 
	INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid=c.custid
	WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
		AND c.roleid=1 
		AND  ca.site in  ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
		AND ci.Enabled=1
	----------- For SMA  -----------
	INSERT INTO #DummyTempbatch3 (CustID)

	SELECT ci.srecommend -- super of Direct Master 
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.custid = D.CustID	
	UNION 
	SELECT DISTINCT CI.srecommend -- super of direct agent
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectAgent D ON CI.custid = d.CustID
	UNION	
	SELECT DISTINCT CI.srecommend -- super of direct member
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMember D ON CI.custid = D.CustID 
	WHERE  ci.Enabled = 1

	INSERT INTO #DummyTemp (CustID,exchangeid)
	SELECT DISTINCT CustId,currency
	FROM Customer WITH(NOLOCK)
	WHERE (Custid  NOT IN (SELECT custid from #DummyTempbatch3)
	AND custid NOT IN (4,15,2,5,13)
	AND  roleid=4 AND custid<=100)
	OR custid IN
	(select custid from Acc_CustDirect with(nolock) WHERE custid not in
		( 
		SELECT ci.srecommend
			FROM Customer ci with(nolock)
			INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
			WHERE 	
				 ci.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
				and ci.srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
				and ci.roleid=3 
				AND c.Enabled=1
		
			UNION

			SELECT ci.mrecommend
			FROM Customer ci WITH(NOLOCK)
			INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
			WHERE
				 ci.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
				and ci.mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
				and ci.roleid=2 
				AND c.Enabled=1

			UNION
			SELECT c.recommend
			FROM Customer c WITH(NOLOCK)	
			INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid=c.custid
			WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
				AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
				AND c.roleid=1 
				AND ci.Enabled=1)
				AND custid>100
				AND roleid=4
		)
	-------------------------------------
	--------------------------------------WinLossLimit-------------------------------------------------
	
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, @Sporttype, @Bettype
		, 0 AS MaxWinLimit	
		, (SELECT ISNULL(DefaultLossLimit,0) FROM LossLimit_GlobalSetting WITH (NOLOCK) WHERE ProductId = @ProductID AND ExchangeId = si.exchangeid)AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #DummyTemp si WITH (NOLOCK) 
	WHERE NOT EXISTS(SELECT 1 FROM CustWinLossLimit_Agent ca WITH(NOLOCK) WHERE SportType=@Sporttype AND si.CustId=ca.CustId)

	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, @Sporttype, @Bettype
		, 0 AS MaxWinLimit	
		, (SELECT ISNULL(DefaultLossLimit,0) FROM LossLimit_GlobalSetting WITH (NOLOCK) WHERE ProductId = @ProductID AND ExchangeId = si.currency)AS MaxLossLimit 
		, 1 IsAutoReset
	FROM Customer si WITH (NOLOCK) 	
	INNER JOIN #CustTemp c ON si.custid=c.CustID
	WHERE NOT EXISTS(SELECT 1 FROM CustWinLossLimit_Agent ca WITH(NOLOCK) WHERE SportType=@Sporttype AND si.CustId=ca.CustId)

	--PT
	INSERT INTO dbo.CustPTSetting3rd_Agent
		(	[CustID]
		   ,[SportType]
		   ,[BetType]
		   ,[IsLive]
		   ,[SuperPT]
		   ,[MasterPT]
		   ,[AgentPT]
		   ,[IsAutoMasterPT]
		   ,[AutoMasterPT]
		   ,[IsAutoSuperPT]
		   ,[AutoSuperPT]
		   ,[MinPT]
		   ,[MaxPT])
	SELECT 
		CustID, @Sporttype, @Bettype, 0		
		,@MaxPT
		,@MaxPT
		,@MaxPT
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #DummyTemp si
	WHERE NOT EXISTS(SELECT 1 FROM CustPTSetting3rd_Agent ca WITH(NOLOCK) WHERE SportType=@Sporttype AND si.CustId=ca.CustId)

	INSERT INTO dbo.CustPTSetting3rd_Agent
		(	[CustID]
		   ,[SportType]
		   ,[BetType]
		   ,[IsLive]
		   ,[SuperPT]
		   ,[MasterPT]
		   ,[AgentPT]
		   ,[IsAutoMasterPT]
		   ,[AutoMasterPT]
		   ,[IsAutoSuperPT]
		   ,[AutoSuperPT]
		   ,[MinPT]
		   ,[MaxPT])
	SELECT 
		ci.CustID,  @Sporttype, @Bettype, 0
		,0
		,@MaxPT
		,0
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #CustTemp ci WITH(NOLOCK) WHERE ci.RoleID=3
	AND NOT EXISTS(SELECT 1 FROM CustPTSetting3rd_Agent ca WITH(NOLOCK) WHERE SportType=@Sporttype AND ci.CustId=ca.CustId)
	
	--Agent LEVEL
	--direct agent
	INSERT INTO dbo.CustPTSetting3rd_Agent
		(	[CustID]
		   ,[SportType]
		   ,[BetType]
		   ,[IsLive]
		   ,[SuperPT]
		   ,[MasterPT]
		   ,[AgentPT]
		   ,[IsAutoMasterPT]
		   ,[AutoMasterPT]
		   ,[IsAutoSuperPT]
		   ,[AutoSuperPT]
		   ,[MinPT]
		   ,[MaxPT])
	SELECT 
		ci.custid, @Sporttype, @Bettype, 0
		,0
		,0
		, @MaxPT
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #CustTemp ci WITH(NOLOCK) WHERE  ci.RoleID=3
	AND NOT EXISTS(SELECT 1 FROM CustPTSetting3rd_Agent ca WITH(NOLOCK) WHERE SportType=@Sporttype AND ci.CustId=ca.CustId)
	----UnHide --Enable
	UPDATE cs
	SET		
		bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled, @BitOrder,0),
		 bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden,@BitOrder,0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	WHERE cs.CustID IN(SELECT custid FROM #CustTemp)
	OR cs.CustID IN (SELECT CustID FROM #DummyTemp)

	DROP TABLE #CustTemp
	DROP TABLE #DirectAgent
	DROP TABLE #DirectMaster
	DROP TABLE #DirectMember
	DROP TABLE #DummyTemp
	DROP TABLE #DummyTempbatch3


