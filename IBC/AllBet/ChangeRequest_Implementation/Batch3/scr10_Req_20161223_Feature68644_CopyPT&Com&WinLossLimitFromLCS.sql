/*
	Created: Helen
	Task: Copy PT & Comm & WinLossLimit for All Bet from Live Casino
	DB: DBCUST/CustDB
	Date: 20160226
*/ 

ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
	@srecommend INT	
	,@ExchangeID INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTGroupSetting3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustDiscount3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustDiscount3rd_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Member') = 0 RETURN	
	
	IF dbo.f_CheckRepTable('CustStakeLevel_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustStakeLevel_Member') = 0 RETURN
	
	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(161, 85, 211	, 2401, 0, 1), --PT copy from NG
	(162, 1101, 211	, 2401, 0, 3), --Comm from LC
	(162, 1101, 211	, 2401, 0, 6)  --WinLossLimit From Global Setting

	CREATE TABLE #MemberTemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		SyncLiveCasino BIT,
		MaxWinLiveCasino SMALLMONEY,
		isAutoResetLiveCasino BIT
	)

	CREATE TABLE #SMATemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		roleid TINYINT,
		SyncLiveCasino BIT,
		MaxWinLiveCasino SMALLMONEY,
		isAutoResetLiveCasino BIT
	)
	CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY,roleid INT)
	CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY,mrecommend INT,roleid INT)
	
	IF @srecommend NOT IN (2,3,5,12,13)
	BEGIN
		IF @srecommend IN (1266057,913628,877004,900371,4204225,6032879,896708) --super no, master yes, agent yes
		BEGIN
			INSERT INTO #SMATemp (CustID, roleid, SyncLiveCasino)
			SELECT custid, roleid, SyncLiveCasino
			FROM Custinfo WITH (NOLOCK)
			WHERE custid = @srecommend
			UNION ALL
			-- Roleid = 3
			SELECT CI.custid, CI.roleid, CI.SyncLiveCasino
			FROM Custinfo CI WITH (NOLOCK)
				INNER JOIN Customer C (NOLOCK) ON CI.custid = c.custid
			WHERE Enabled = 1 AND ci.custid <= @maxcustid 
				AND ci.srecommend = @srecommend AND c.Site  IN ('733333','222223')
				AND CI.roleid = 3
				
			INSERT INTO #SMATemp (CustID, roleid, SyncLiveCasino)
			SELECT CI.custid, CI.roleid, CI.SyncLiveCasino
			FROM Custinfo CI WITH (NOLOCK)
				INNER JOIN Customer C (NOLOCK) ON CI.custid = C.custid
				INNER JOIN #SMATemp master_tmp (NOLOCK) ON master_tmp.custid = CI.mrecommend AND master_tmp.roleid = 3
			WHERE Enabled = 1 AND ci.custid <= @maxcustid 
				AND ci.srecommend = @srecommend AND c.Site  IN ('733333','222223')
				AND CI.roleid = 2
			
			INSERT INTO #MemberTemp (CustID, SyncLiveCasino)
			SELECT ci.custid, ci.SyncLiveCasino
			FROM Custinfo ci WITH (NOLOCK)
				INNER JOIN #SMATemp agent_tmp ON ci.recommend = agent_tmp.CustID AND agent_tmp.roleid = 2
			WHERE CI.srecommend = @srecommend AND CI.roleid = 1  AND Enabled = 1 AND CI.custid <= @maxcustid	
				
		END
		ELSE IF @srecommend IN (796555,5005322) --Super yes, master yes, agent no
		BEGIN
			
			INSERT INTO #SMATemp (CustID, roleid, SyncLiveCasino)
			SELECT custid, roleid, SyncLiveCasino
			FROM Custinfo WITH (NOLOCK)
			WHERE custid = @srecommend
			UNION ALL
			-- Roleid = 3
			SELECT CI.custid, CI.roleid, CI.SyncLiveCasino
			FROM Custinfo CI WITH (NOLOCK)
				INNER JOIN Customer C (NOLOCK) ON CI.custid = c.custid
			WHERE Enabled = 1 AND ci.custid <= @maxcustid 
				AND ci.srecommend = @srecommend AND c.Site  IN ('733333','222223')
				AND CI.roleid = 3
		END
		ELSE
		BEGIN
			INSERT INTO #MemberTemp (CustID, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino)
			SELECT custid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino
			FROM Custinfo WITH (NOLOCK)
			WHERE srecommend = @srecommend AND roleid = 1  AND Enabled = 1 AND custid <= @maxcustid
			
			INSERT INTO #SMATemp (CustID, roleid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino)
			SELECT custid, roleid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino
			FROM Custinfo WITH (NOLOCK)
			WHERE srecommend = @srecommend AND roleid IN (2,3,4) AND Enabled = 1 AND custid <= @maxcustid 
		END	
	END
	ELSE IF @srecommend IN (2,3,5,12,13)
	BEGIN 
		
		--- get direct master
		INSERT INTO #DirectMaster (CustID,roleid)
		SELECT custid, roleid
		FROM Customer with(nolock)
		WHERE SITE in ('733333','222223')

			and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
			and srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
			and roleid=3 AND srecommend = @srecommend AND custid <= @maxcustid 
			
		--- get direct agent
		INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
		SELECT custid, mrecommend,roleid
		FROM Customer WITH(NOLOCK)
		WHERE SITE in ('733333','222223')

			and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
			and mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
			and roleid=2 AND srecommend = @srecommend AND custid <= @maxcustid

		----------- For SMA  -----------
		INSERT INTO #SMATemp (CustID,roleid,SyncLiveCasino)
		SELECT CustID,roleid,SyncLiveCasino
		FROM custInfo CI WITH (NOLOCK)
		WHERE CI.custid = @srecommend -- SUPER
		UNION ALL

		SELECT CI.CustID,CI.roleid,CI.SyncLiveCasino -- Direct Master 
		FROM custInfo CI WITH (NOLOCK)
			INNER JOIN #DirectMaster D ON CI.custid = D.CustID 
		UNION ALL
		SELECT DISTINCT CI.CustID,CI.roleid,CI.SyncLiveCasino -- Master of direct agent
		FROM custInfo CI WITH (NOLOCK)
			INNER JOIN #DirectAgent D ON CI.custid = D.mrecommend 
			
		UNION ALL

		SELECT CI.CustID,CI.roleid,CI.SyncLiveCasino -- Agent of direct master
		FROM custInfo CI WITH (NOLOCK)
			INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
		WHERE CI.roleid = 2
		UNION ALL
		SELECT CI.CustID,CI.roleid,CI.SyncLiveCasino -- Direct Agent
		FROM custInfo CI WITH (NOLOCK)
			INNER JOIN #DirectAgent D ON CI.custid = D.CustID 
		---------- For members ---------
		INSERT INTO #MemberTemp (CustID, SyncLiveCasino)
		SELECT CI.custid, SyncLiveCasino
		FROM Custinfo CI WITH (NOLOCK)
			INNER JOIN #DirectMaster M ON CI.mrecommend = M.CustID
		WHERE CI.roleid = 1	

		UNION ALL
		SELECT CI.custid, SyncLiveCasino
		FROM Custinfo CI WITH (NOLOCK)
			INNER JOIN #DirectAgent M ON CI.recommend = M.CustID
		WHERE CI.roleid = 1

		
		---- REMOVE SMA OR member if existing Allbet Setting
		DELETE M
		FROM #SMATemp M 
			INNER JOIN CustWinLossLimit_Agent ps WITH (NOLOCK) ON M.CustID = PS.CustID AND PS.SportType = 211
			
		DELETE M
		FROM #MemberTemp M 
			INNER JOIN CustWinLossLimit_Member ps WITH (NOLOCK) ON M.CustID = PS.CustID AND PS.SportType = 211
	END		
	
	DECLARE @MaxPT TINYINT, @MaxComm DECIMAL(9,8)
	SELECT @MaxPT = MaxPT FROM dbo.ProductSettingDetail WITH (NOLOCK) WHERE ProductID = 21 AND SettingType = 1
	SELECT @MaxComm = MaxDiscount FROM dbo.ProductSettingDetail WITH (NOLOCK) WHERE ProductID = 21 AND SettingType = 3
	
	DECLARE @DefaultLossLimit MONEY
	
	SELECT @DefaultLossLimit = ISNULL(DefaultLossLimit,0)
	FROM LossLimit_GlobalSetting WITH (NOLOCK)
	WHERE ProductId = 21 AND ExchangeId = @ExchangeID
	--Bettype 2402: Lowest VIP Bet limit
	DECLARE @StakeLevelList_2402 VARCHAR(100)
	SELECT TOP 1 @StakeLevelList_2402 =  StakeLevelID 
	FROM dbo.StakeLevel WITH(NOLOCK) 
	WHERE ExchangeId = @exchangeID AND GameTypeID = 2402 
	
	-- Bettype 2401
	DECLARE @StakeLevelList_2401_lowest VARCHAR(100),@StakeLevelList_2401_allLevel4Super VARCHAR (100)
	
	SELECT TOP 1 @StakeLevelList_2401_lowest =  StakeLevelID 
	FROM dbo.StakeLevel WITH(NOLOCK) 
	WHERE ExchangeId = @exchangeID AND GameTypeID = 2401
	ORDER BY MaxStake, MinStake
	
	SET @StakeLevelList_2401_allLevel4Super = STUFF((SELECT  ',' + CONVERT(VARCHAR(10),StakeLevelID) 
										FROM dbo.StakeLevel WITH(NOLOCK) 
										WHERE ExchangeId = @exchangeID AND GameTypeID = 2401
									 ORDER BY MaxStake, MinStake
									 FOR XML PATH ('')),1,1,'')
									 
									 
	------------------------------------ Bet Setting ----------------------------------------------------
	INSERT INTO dbo.CustStakeLevel_Agent(CustID, SportType, BetType, StakeLevelList)	
	SELECT CustID, 211, 2402, @StakeLevelList_2402 AS StakeLevelList
	FROM #SMATemp 
	UNION ALL
	SELECT CustID, 211, 2401, @StakeLevelList_2401_allLevel4Super StakeLevelList
	FROM #SMATemp 

	INSERT INTO dbo.CustStakeLevel_Member(CustID, SportType, BetType, StakeLevelList)	
	SELECT CustID, 211, 2402, @StakeLevelList_2402 AS StakeLevelList
	FROM #MemberTemp
	UNION ALL
	SELECT CustID, 211, 2401, @StakeLevelList_2401_lowest AS StakeLevelList
	FROM #MemberTemp

	--------------------------------------WinLossLimit-------------------------------------------------
	--SMA Level
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT sma.custid, dest.tSportType, dest.tBetType	
		, 0
		, @DefaultLossLimit AS MaxLossLimit 
		,1 IsAutoReset
	FROM #SMATemp sma WITH (NOLOCK) 
		CROSS JOIN #DestinationSportBetType dest WITH(NOLOCK) 
	WHERE dest.SettingType = 6 

	--Member Level
	INSERT INTO CustWinLossLimit_Member(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT member.custid, dest.tSportType, dest.tBetType	
		,0
		,@DefaultLossLimit AS MaxLossLimit 
		,1
	FROM #MemberTemp member WITH (NOLOCK) 
		CROSS JOIN #DestinationSportBetType dest WITH(NOLOCK) 
	WHERE dest.SettingType = 6 
	
	--------------------------------------PT Setting-------------------------------------------------	
	CREATE TABLE #PT_Comm_Site(Site NVARCHAR(50),PT TINYINT, Comm DECIMAL(9,8), IsApplyChangePT BIT, IsApplyChangeComm BIT)
	INSERT INTO #PT_Comm_Site (Site,PT,Comm,IsApplyChangePT,IsApplyChangeComm)	
	VALUES('611111',93,0.009,1,1)
		,('722222',93,0.009,1,1)
		,('766666',93,0.009,1,1)
		,('789y',80,0.009,1,1)
		,('7aa666',93,0.009,1,1)
		,('Bestodds',0,0.009,0,1) -- keep as Number Game PT
		,('xyzbet',80,0.009,1,1)
		,('33333',0,0,0,0)
		,('222225',0,0,0,0)
		,('222227',0,0,0,0)
		,('ispo',0,0,0,0)
	
	--Super LEVEL
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
		cs.custid, dest.tsporttype, dest.tbettype, dest.IsLive
		
		, CASE WHEN s.IsApplyChangePT = 1 THEN s.PT ELSE cs.slivepositiontaking  * 100 END AS [SuperPT]
		, CASE WHEN s.IsApplyChangePT = 1 THEN s.PT ELSE cs.mlivepositiontaking  * 100 END AS [MasterPT]
		, CASE WHEN s.IsApplyChangePT = 1 THEN s.PT ELSE cs.alivepositiontaking  * 100 END AS [AgentPT]
		
		, cs.isautolivempositiontaking
		, cs.autolivempositiontaking *100
		, cs.isautolivepositiontaking 
		, cs.autolivepositiontaking  *100
		, co.minlivepositiontaking  *100
		, CASE WHEN s.IsApplyChangePT = 1 THEN s.PT ELSE cs.slivepositiontaking  * 100 END AS [MaxPT]
		
	FROM dbo.CustSetting3rd cs WITH(NOLOCK) 
		INNER JOIN dbo.custOverride3rd co WITH(NOLOCK) ON cs.custid = co.custid and cs.sporttype = co.sporttype and cs.bettype = co.bettype 
		INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid 
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.fBetType AND cs.sporttype = dest.fSportType
		INNER JOIN Customer c (NOLOCK) ON c.custid = ci.CustID
		INNER JOIN #PT_Comm_Site S ON s.Site = c.site
	WHERE ci.roleid = 4
	
	--MASTER/AGENT LEVEL
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
		cs.custid, dest.tsporttype, dest.tbettype, dest.IsLive
		
		,cs.slivepositiontaking  *100
		,cs.mlivepositiontaking  *100
		,cs.alivepositiontaking  *100
		
		,cs.isautolivempositiontaking
		,cs.autolivempositiontaking *100
		,cs.isautolivepositiontaking 
		,cs.autolivepositiontaking  *100
		,co.minlivepositiontaking  *100
		,90
	FROM dbo.CustSetting3rd cs WITH(NOLOCK) 
		INNER JOIN dbo.custOverride3rd co WITH(NOLOCK) ON cs.custid = co.custid and cs.sporttype = co.sporttype and cs.bettype = co.bettype
		INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid 
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.fBetType AND cs.sporttype = dest.fSportType
	WHERE ci.roleid IN (2,3)	
	
	--MEMBER LEVEL
	INSERT INTO dbo.CustPTSetting3rd_Member
		(	[custid]
		  ,	[sporttype]
		  ,	[bettype]
		  ,	[islive]
		  ,	[superPT]
		  ,	[masterPT]
		  ,	[agentPT]
		  ,	[IsAutoMasterPT]
		  ,	[AutoMasterPT]
		  ,	[IsAutoSuperPT]
		  ,	[AutoSuperPT])
	SELECT 
		cs.custid, dest.tsporttype, dest.tbettype, dest.IsLive
		,cs.slivepositiontaking  *100
		,cs.mlivepositiontaking  *100
		,cs.alivepositiontaking  *100
		,cs.isautolivempositiontaking
		,cs.autolivempositiontaking *100
		,cs.isautolivepositiontaking 
		,cs.autolivepositiontaking  *100
	FROM dbo.CustSetting3rd cs WITH(NOLOCK)
		INNER JOIN #MemberTemp ci WITH(NOLOCK) ON cs.CustID = ci.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.fBetType AND cs.sporttype = dest.fSportType
	
	DECLARE @apos SMALLMONEY,
			@mpos SMALLMONEY
	
	UPDATE cs
	SET cs.MinPT = @MaxPT
	FROM dbo.CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
	WHERE MinPT > @MaxPT		
	
	UPDATE cs
	SET @apos = CASE WHEN cs.AgentPT > @MaxPT THEN @MaxPT ELSE cs.AgentPT END,
		cs.AgentPT = @apos,
		@mpos = CASE WHEN @apos + cs.MasterPT > @MaxPT THEN @MaxPT- @apos ELSE cs.MasterPT END,
		cs.MasterPT = @mpos,
		cs.SuperPT = CASE WHEN @apos + @mpos + cs.SuperPT > @MaxPT THEN @MaxPT - @mpos -@apos ELSE cs.SuperPT END
	FROM  CustPTSetting3rd_Member cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN #MemberTemp ci WITH(NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
	WHERE cs.SuperPT + cs.MasterPT + cs.AgentPT > @MaxPT
		
	UPDATE cs
	SET @apos = CASE WHEN cs.AgentPT > @MaxPT THEN @MaxPT ELSE cs.AgentPT END,
		cs.AgentPT = @apos,
		cs.MasterPT = CASE WHEN @apos + cs.MasterPT > @MaxPT THEN @MaxPT- @apos ELSE cs.MasterPT END		
	FROM  CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
	WHERE cs.MasterPT + cs.AgentPT > @MaxPT	AND roleid = 2
	
	UPDATE cs
	SET @mpos = CASE WHEN cs.MasterPT > @MaxPT THEN @MaxPT ELSE cs.MasterPT END,
		cs.MasterPT = @mpos,
		cs.SuperPT = CASE WHEN cs.SuperPT + @mpos > @MaxPT THEN @MaxPT - @mpos ELSE cs.SuperPT END 		
	FROM  CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
	WHERE cs.MasterPT + cs.SuperPT > @MaxPT	AND roleid = 3
		
	UPDATE cs
	SET cs.SuperPT = CASE WHEN cs.SuperPT > @MaxPT THEN @MaxPT ELSE cs.SuperPT END 		
	FROM  CustPTSetting3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
	WHERE ci.custid = @srecommend		
		AND cs.SuperPT > @MaxPT	

	DECLARE @SportBettypeXML VARCHAR(MAX)
	SET @SportBettypeXML = '<ROOT><PT SportType="211" BetType="2401" IsLive="0" /></ROOT>'
				
	EXEC Acc_DynamicCustSetting3rd_07 @SuperID = @srecommend,@SportBettypeXML = @SportBettypeXML, @Roleid = 4

	--------------------------------------Commission Setting-------------------------------------------------		
	--Agent Level
	INSERT INTO dbo.CustDiscount3rd_Agent(CustID, SportType, BetType, Discount)
	SELECT cs.custid, dest.tsporttype, dest.tbettype, 
			CASE	WHEN ci.roleid = 4 THEN (CASE WHEN ci.SyncLiveCasino = 1 THEN cs.sdiscount ELSE 0.009 END)
					WHEN ci.roleid = 3 THEN (CASE WHEN ci.SyncLiveCasino = 1 THEN cs.adiscount ELSE 0 END)
					WHEN ci.roleid = 2 THEN (CASE WHEN ci.SyncLiveCasino = 1 THEN cs.discount ELSE 0 END)
			END		
	FROM dbo.CustSettingGame cs WITH(NOLOCK)
		INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 3 AND cs.bettype = dest.fBetType AND cs.sporttype = dest.fSportType
		--INNER JOIN Customer C WITH (NOLOCK) ON C.custid = CS.CustID
		--INNER JOIN #PT_Comm_Site S ON s.Site = c.site
		 
	--Member Level
	INSERT INTO dbo.CustDiscount3rd_Member(CustID, SportType, BetType, PlayerDiscount, AgentDiscount, MasterDiscount, SuperDiscount)
	SELECT cs.custid, dest.tsporttype, dest.tbettype
			, CASE WHEN CI.SyncLiveCasino = 1 THEN cs.PlayerDiscount ELSE 0 END AS PlayerDiscount
			, CASE WHEN CI.SyncLiveCasino = 1 THEN cs.discount ELSE 0 END AS AgentDiscount
			, CASE WHEN CI.SyncLiveCasino = 1 THEN cs.adiscount ELSE 0 END AS MasterDiscount
			, CASE WHEN CI.SyncLiveCasino = 1 THEN 0.009 ELSE 0 END AS SuperDiscount
	FROM dbo.CustSettingGame cs WITH(NOLOCK)
		INNER JOIN #MemberTemp ci WITH(NOLOCK) ON cs.CustID = ci.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 3 AND cs.bettype = dest.fBetType AND cs.sporttype = dest.fSportType

	--adjust commission Super = [0; 0.007]	
	--correct for super level
	IF EXISTS(	SELECT 1
				FROM dbo.CustDiscount3rd_Agent cs WITH(NOLOCK)
					INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 3 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
				WHERE cs.CustID = @srecommend AND cs.Discount > @MaxComm)
	BEGIN
		UPDATE cs
		SET cs.Discount = @MaxComm
		FROM  CustDiscount3rd_Agent cs WITH(UPDLOCK,ROWLOCK) 
			INNER JOIN #SMATemp ci ON cs.CustID = ci.CustID
			INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 3 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType
		WHERE cs.Discount > @MaxComm
		
		UPDATE cs
		SET cs.SuperDiscount = CASE WHEN cs.SuperDiscount > @MaxComm THEN @MaxComm ELSE cs.SuperDiscount END,
			cs.MasterDiscount = CASE WHEN cs.MasterDiscount > cs.SuperDiscount THEN cs.SuperDiscount ELSE cs.MasterDiscount END,
			cs.AgentDiscount = CASE WHEN cs.AgentDiscount > cs.MasterDiscount THEN cs.MasterDiscount ELSE cs.AgentDiscount END,
			cs.PlayerDiscount = CASE WHEN cs.PlayerDiscount > cs.AgentDiscount THEN cs.AgentDiscount ELSE cs.PlayerDiscount END
		FROM dbo.CustDiscount3rd_Member cs WITH(UPDLOCK, ROWLOCK)
			INNER JOIN #MemberTemp ci ON cs.CustID = ci.CustID
			INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 3 AND cs.bettype = dest.tBetType AND cs.sporttype = dest.tSportType		
		WHERE cs.SuperDiscount > @MaxComm 
			OR cs.MasterDiscount > cs.SuperDiscount 
			OR cs.AgentDiscount > cs.MasterDiscount 
			OR cs.PlayerDiscount > cs.AgentDiscount
		  
	END		
	
	DROP TABLE #SMATemp
	DROP TABLE #MemberTemp
	DROP TABLE #DestinationSportBetType		
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,exchangeid INT,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @exchangeid INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
FROM dbo.Customer ci WITH(NOLOCK)
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND ci.custid <= @max_custid
		-- Production
		AND (ci.site IN ('BEST-ODDS' ,'789y' ,'XYZBET' ,'611111' ,'722222' ,'222225' ,'222227' ,'033333' ,'ispo' ,'766666' ,'7aa666') OR ci.currency = 20)
		AND ci.custid <> 72
		) 
		OR ci.custid IN (
			-- dummy account
			2,3,5,12,13
			-- cross site
			/* 
			1. super no, master yes, agent yes(1266057,900371,4204225,674248,877004,6032879)
			2. Super yes, master yes, agent no: 796555, 5005322		
			*/
			,1266057,913628,877004,900371,4204225,6032879,896708,796555,5005322 
		)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		,@exchangeid = exchangeid 
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustSetting3rd_09 @srecommend = @srecommend , @Exchangeid = @exchangeid
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,exchangeid INT,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @exchangeid INT

SELECT @max_custid = xxx

INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
FROM dbo.Customer ci WITH(NOLOCK)
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND ci.custid <= @max_custid 
		-- Production
		AND (ci.site IN ('BEST-ODDS' ,'789y' ,'XYZBET' ,'611111' ,'722222' ,'222225' ,'222227' ,'033333' ,'ispo' ,'766666' ,'7aa666') OR ci.currency = 20)
		AND ci.custid <> 72
		)
		OR ci.custid IN (
			-- dummy account
			2,3,5,12,13
			-- cross site
			/* 
			1. super no, master yes, agent yes(1266057,900371,4204225,674248,877004,6032879)
			2. Super yes, master yes, agent no: 796555, 5005322		
			*/
			,1266057,913628,877004,900371,4204225,6032879,896708,796555,5005322 
		)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		,@exchangeid = exchangeid 
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustSetting3rd_09 @srecommend = @srecommend, @Exchangeid = @exchangeid
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
						
	waitfor delay '00:00:0.280'
END