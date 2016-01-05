
	CREATE TABLE #MemberTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
	)

	CREATE TABLE #SMATemp
	(
		AgentID INT PRIMARY KEY CLUSTERED,
		RoleID  TINYINT
	)

	INSERT #MemberTemp(CustID)
	SELECT CustID
	FROM dbo.custInfo ci WITH(NOLOCK)
	WHERE ci.roleid = 1 AND ci.currency = 20 
		AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	
	INSERT #SMATemp(AgentID,RoleID)
	SELECT CustID,RoleID
	FROM dbo.custInfo ci WITH(NOLOCK)
	WHERE ci.roleid IN (2,3,4) AND ci.currency = 20 
		AND ci.srecommend NOT IN  (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))

	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, tIsLive BIT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(44, 3, 50	,501,0,  1), --PT
	(44, 3, 50	,501,1,  1), --PT
	(44, 3, 50	,599,0,  1), --PT
	(44, 3, 50	,599,1,  1), --PT
	(44, 3, 50	,501,0,  2), --Bet Limit
	(44, 3, 50	,501,0,  5) --Discount

	/******PT******/
		--SMA        
		INSERT INTO [dbo].[CustPTSetting3rd_Agent]
				   ([CustID]
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
		SELECT	[CustID]
				  ,f.tSportType
				  ,f.tBetType
				  ,f.[tIsLive]
				   ,[SuperPT]
				   ,[MasterPT]
				   ,[AgentPT]
				   ,[IsAutoMasterPT]
				   ,[AutoMasterPT]
				   ,[IsAutoSuperPT]
				   ,[AutoSuperPT]
				   ,[MinPT]
				   ,[MaxPT]
		FROM dbo.CustPTSetting3rd_Agent cs WITH(NOLOCK) 
		INNER JOIN #DestinationSportBetType f WITH(NOLOCK)
			ON cs.SportType = f.fSportType
				AND cs.BetType = f.fBetType
				AND f.SettingType = 1
		WHERE cs.IsLive = 0 AND cs.custid IN (SELECT AgentID FROM #SMATemp)
		
		--Member
		INSERT INTO [dbo].[CustPTSetting3rd_Member]
				   ([CustID]
				   ,[SportType]
				   ,[BetType]
				   ,[IsLive]
				   ,[SuperPT]
				   ,[MasterPT]
				   ,[AgentPT]
				   ,[IsAutoMasterPT]
				   ,[AutoMasterPT]
				   ,[IsAutoSuperPT]
				   ,[AutoSuperPT])
		SELECT	[CustID]
				  ,f.tSportType
				  ,f.tBetType
				  ,f.[tIsLive]
				  ,[SuperPT]
				  ,[MasterPT]
				  ,[AgentPT]
				  ,[IsAutoMasterPT]
				  ,[AutoMasterPT]
				  ,[IsAutoSuperPT]
				  ,[AutoSuperPT]
		FROM dbo.CustPTSetting3rd_Member cs WITH(NOLOCK) 
		INNER JOIN #DestinationSportBetType f WITH(NOLOCK)
			ON cs.SportType = f.fSportType
				AND cs.BetType = f.fBetType
				AND f.SettingType = 1
		WHERE cs.IsLive = 0 AND cs.custid IN (SELECT CustID FROM #MemberTemp)

		INSERT INTO [dbo].[CustPTGroupSetting3rd_Member]
				   ([AgentID]
				   ,[SportType]
				   ,[BetType]
				   ,[IsLive]
				   ,[SuperPT]
				   ,[MasterPT]
				   ,[AgentPT]
				   ,[IsAutoMasterPT]
				   ,[AutoMasterPT]
				   ,[IsAutoSuperPT]
				   ,[AutoSuperPT])
		SELECT	[AgentID]
				  ,f.tSportType
				  ,f.tBetType
				  ,f.[tIsLive]
				  ,[SuperPT]
				  ,[MasterPT]
				  ,[AgentPT]
				  ,[IsAutoMasterPT]
				  ,[AutoMasterPT]
				  ,[IsAutoSuperPT]
				  ,[AutoSuperPT]
		FROM dbo.CustPTGroupSetting3rd_Member cs WITH(NOLOCK) 
		INNER JOIN #DestinationSportBetType f WITH(NOLOCK)
			ON cs.SportType = f.fSportType
				AND cs.BetType = f.fBetType
				AND f.SettingType = 1
		WHERE cs.IsLive = 0 AND cs.AgentID IN (SELECT AgentID FROM #SMATemp Where RoleID = 2)

	/****Bet Limit*****/
		--SMA
		INSERT INTO [dbo].[CustBetSetting3rd_Agent]
			   ([CustID]
			   ,[SportType]
			   ,[BetType]
			   ,[MinBet]
			   ,[MaxBet]
			   ,[MaxPerMatch])
		 SELECT	[CustID]
				  ,f.tSportType
				  ,f.tBetType
				  ,[MinBet]
				  ,[MaxBet]
				  ,[MaxPerMatch]
		FROM dbo.CustBetSetting3rd_Agent cs WITH(NOLOCK) 
		INNER JOIN #DestinationSportBetType f WITH(NOLOCK)
			ON cs.SportType = f.fSportType
				AND cs.BetType = f.fBetType
				AND f.SettingType = 2
		WHERE cs.custid IN (SELECT AgentID FROM #SMATemp)
		

		--Member
		INSERT INTO [dbo].[CustBetSetting3rd_Member]
				   ([CustID]
				   ,[SportType]
				   ,[BetType]
				   ,[MinBet]
				   ,[MaxBet]
				   ,[MaxPerMatch])
		SELECT	[CustID]
				  ,f.tSportType
				  ,f.tBetType
				  ,[MinBet]
				  ,[MaxBet]
				  ,[MaxPerMatch]
		FROM dbo.CustBetSetting3rd_Member cs WITH(NOLOCK) 
		INNER JOIN #DestinationSportBetType f WITH(NOLOCK)
			ON cs.SportType = f.fSportType
				AND cs.BetType = f.fBetType
				AND f.SettingType = 2
		WHERE cs.custid IN (SELECT CustID FROM #MemberTemp)
			
	/******Discount********/
		--SMA
		INSERT INTO [dbo].[CustDiscount3rd_Agent]
			   ([CustID]
			   ,[SportType]
			   ,[BetType]
			   ,[Discount])
		SELECT	[CustID]
				  ,f.tSportType
				  ,f.tBetType
				  ,0
		FROM dbo.CustBetSetting3rd_Agent cs WITH(NOLOCK) 
		INNER JOIN #DestinationSportBetType f WITH(NOLOCK)
			ON cs.SportType = f.fSportType
				AND cs.BetType = f.fBetType
				AND f.SettingType = 5
		WHERE cs.custid IN (SELECT AgentID FROM #SMATemp)


		--Member
		INSERT INTO [dbo].[CustDiscount3rd_Member]
				   ([CustID]
				   ,[SportType]
				   ,[BetType]
				   ,[PlayerDiscount]
				   ,[AgentDiscount]
				   ,[MasterDiscount]
				   ,[SuperDiscount])		
		SELECT	[CustID]
				  ,f.tSportType
				  ,f.tBetType
				  ,0.02
				  ,0
				  ,0
				  ,0
		FROM dbo.CustBetSetting3rd_Member cs WITH(NOLOCK) 
		INNER JOIN #DestinationSportBetType f WITH(NOLOCK)
			ON cs.SportType = f.fSportType
				AND cs.BetType = f.fBetType
				AND f.SettingType = 5
		WHERE cs.custid IN (SELECT CustID FROM #MemberTemp)

	DROP TABLE #MemberTemp
	DROP TABLE #SMATemp
	DROP TABLE #DestinationSportBetType
