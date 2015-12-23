/*
	Created: Dominic
	Date: 2015-11-25
	Task: Initialize setting of CF for UUS Customers
	DB: DBCust.CustDB
*/  
-- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
ALTER PROCEDURE Acc_DynamicCustSetting3rd_09
	@target VARCHAR(30)
AS
BEGIN   
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustBetSetting3rd_Member') = 1
	   AND dbo.f_CheckRepTable('CustBetSetting3rd_Agent') = 1
	   AND dbo.f_CheckRepTable('CustPTSetting3rd_Member') = 1
	   AND dbo.f_CheckRepTable('CustPTSetting3rd_Agent') = 1
	   AND dbo.f_CheckRepTable('CustDiscount3rd_Agent') = 1
	   AND dbo.f_CheckRepTable('CustDiscount3rd_Member') = 1
	   )
	  RETURN

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
		AND ci.CustID NOT IN
		(
			5856063,
			14242456,
			14242815,
			14242821,
			14242825,
			14242830,
			14242834,
			14242839,
			14242878,
			14242879,
			14242912,
			14242913,
			14242914,
			14242917,
			14307171,
			14307173,
			14307199,
			14307202,
			14307217,
			19096660,
			19096669,
			19096700,
			19096713,
			19235101,
			19235235,
			19235320,
			19235873,
			19353908,
			19353920,
			19353930,
			19456620,
			19466628,
			19466706,
			19466773,
			19504989,
			19519293,
			19520142,
			19520294
		)

	INSERT #SMATemp(AgentID,RoleID)
	SELECT CustID,RoleID
	FROM dbo.custInfo ci WITH(NOLOCK)
	WHERE ci.roleid IN (2,3,4) AND ci.currency = 20 
		AND ci.srecommend NOT IN  (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))

	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(44, 3, 206	,1003,  1), --PT
	(44, 3, 206	,1003,  2), --Bet Limit
	(44, 3, 206	,1003,  3) --Discount

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
				  ,[IsLive]
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
				  ,[IsLive]
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
				  ,[IsLive]
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
				  ,0.0025
		FROM dbo.CustBetSetting3rd_Agent cs WITH(NOLOCK) 
		INNER JOIN #DestinationSportBetType f WITH(NOLOCK)
			ON cs.SportType = f.fSportType
				AND cs.BetType = f.fBetType
				AND f.SettingType = 3
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
				  ,0.0025
				  ,0.0025
				  ,0.0025
				  ,0.0025
		FROM dbo.CustBetSetting3rd_Member cs WITH(NOLOCK) 
		INNER JOIN #DestinationSportBetType f WITH(NOLOCK)
			ON cs.SportType = f.fSportType
				AND cs.BetType = f.fBetType
				AND f.SettingType = 3
		WHERE cs.custid IN (SELECT CustID FROM #MemberTemp)

	DROP TABLE #MemberTemp
	DROP TABLE #SMATemp
	DROP TABLE #DestinationSportBetType

END

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
EXEC dbo.Acc_DynamicCustSetting3rd_09 @target = 'REPLICATED'


-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
EXEC dbo.Acc_DynamicCustSetting3rd_09 @target = 'DBCUST'

