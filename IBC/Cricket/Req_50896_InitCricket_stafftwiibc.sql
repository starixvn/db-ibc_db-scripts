/*
	Created By: Dominic
	Created Date: 20160114
	Task: Init setting of iCricket for member under agent "stafftwiibc" (UUS) - Redmine #50896
	Database:DBCust/CustDB 
*/
-------------------------------- STEP 1: Insert Master Data -------------------------------------------
	INSERT INTO [dbo].[ProductStatusProfile]
			   ([Sporttype]
			   ,[Bettype]
			   ,[bitmapOrder])
		 VALUES
			   (50
			   ,501
			   ,3)
	GO

-------------------------------- STEP 2: Import  Data -------------------------------------------
	CREATE TABLE #MemberTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
	)

	INSERT #MemberTemp(CustID)
	SELECT CustID
	FROM dbo.custInfo ci WITH(NOLOCK)
	WHERE ci.recommend=15657959 and ci.roleid = 1
		AND ci.srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		
		
	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, tIsLive BIT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(44, 3, 50	,501,0,  1), --PT
	(44, 3, 50	,501,1,  1), --PT
	(44, 3, 50	,599,0,  1), --PT
	(44, 3, 50	,599,1,  1), --PT
	(44, 3, 50	,501,0,  2), --Bet Limit
	(44, 3, 50	,501,0,  5) --Discount
	
	--PT
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
	
	
	--Bet Limit
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
		
	--Charge Comm
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
			  ,0.0086
			  ,0.0088
			  ,0.0188
	FROM dbo.CustBetSetting3rd_Member cs WITH(NOLOCK) 
	INNER JOIN #DestinationSportBetType f WITH(NOLOCK)
		ON cs.SportType = f.fSportType
			AND cs.BetType = f.fBetType
			AND f.SettingType = 5
	WHERE cs.custid IN (SELECT CustID FROM #MemberTemp)