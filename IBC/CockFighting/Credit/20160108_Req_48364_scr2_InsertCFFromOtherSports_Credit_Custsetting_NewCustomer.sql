/*
	Created: Dominic
	Date: 2015-11-25
	Task: Copy Bet Setting / Position Taking / Discount from Other Sports to CockFighting for newly created Credit customers (Not under 789y)
	DB: DBCust.CustDB
*/  
	DECLARE @max_custid INT
	
	SELECT @max_custid = xxx
	
	CREATE TABLE #supers (custid int)
	
	INSERT INTO #supers(custid)
	SELECT ci.custid
	FROM dbo.Customer ci WITH(NOLOCK)
	WHERE ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND ci.custid > @max_custid 
		AND ci.site <> '789y'
		AND ci.Currency = 20
	

	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(99, 1, 206	,1003, 0, 1), --PT
	(99, 1, 206	,1003, 0, 2), --Bet Limit
	(99, 1, 206	,1003, 0, 3) --Discount

				
	/*****************************POSITION TAKING**************************/
	CREATE TABLE #MemberTemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		maxpermatch99 MONEY
	)

	CREATE TABLE #SMATemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		maxpermatch99 MONEY,
		RoleID TINYINT
	)
	
	INSERT INTO #MemberTemp (CustID,maxpermatch99)
	SELECT custid,maxpermatch99
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend IN (SELECT CustID FROM #supers)
		AND CustID > @max_custid AND roleid = 1 
	
	
	INSERT INTO #SMATemp (CustID,maxpermatch99,RoleID)
	SELECT custid,maxpermatch99,RoleID
	FROM dbo.Custinfo c WITH (NOLOCK)
	WHERE c.srecommend IN (SELECT CustID FROM #supers)
		AND CustID > @max_custid AND roleid IN (2,3,4) 


	--SUPER LEVEL
	INSERT INTO dbo.CustPTSetting3rd_Agent
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
	SELECT 
		cs.custid,dest.tsporttype,dest.tbettype,dest.IsLive
		,80
		,80
		,80
		,0
		,0
		,0
		,0
		,0
		,80
	FROM dbo.CustSetting cs WITH(NOLOCK) 
		INNER JOIN #SMATemp ci WITH(NOLOCK) 
			ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 1
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
	WHERE ci.RoleID = 4
	
	--Master/Agent LEVEL
	INSERT INTO dbo.CustPTSetting3rd_Agent
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
	SELECT 
		cs.custid,dest.tsporttype,dest.tbettype,dest.IsLive
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,80
	FROM dbo.CustSetting cs WITH(NOLOCK) 
		INNER JOIN #SMATemp ci WITH(NOLOCK) 
			ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 1
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
	WHERE ci.RoleID IN (2,3)
	
	
	--MEMBER LEVEL
	INSERT INTO dbo.CustPTSetting3rd_Member
			([custid]
		  ,[sporttype]
		  ,[bettype]
		  ,[islive]
		  ,[superPT]
		  ,[masterPT]
		  ,[agentPT]
		  ,[IsAutoMasterPT]
		  ,[AutoMasterPT]
		  ,[IsAutoSuperPT]
		  ,[AutoSuperPT])
	SELECT 
		cs.custid,dest.tsporttype,dest.tbettype,dest.IsLive
		,0
		,0
		,0
		,0
		,0
		,0 
		,0
	FROM dbo.custSetting cs WITH(NOLOCK)
		INNER JOIN #MemberTemp ci WITH(NOLOCK) ON cs.CustID = ci.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 1
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
	

	
	/*****************************BET LIMIT SETTING**************************/	
	--Agent Level
	INSERT INTO dbo.CustBetSetting3rd_Agent
	SELECT cs.custid,dest.tsporttype,dest.tbettype,cs.minbet,cs.maxbet,ci.maxpermatch99
	FROM dbo.CustSetting cs WITH(NOLOCK)
		INNER JOIN #SMATemp ci WITH(NOLOCK) 
			ON  ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 2
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType

	 
	--Member Level
	INSERT INTO dbo.CustBetSetting3rd_Member
	SELECT cs.custid,dest.tsporttype,dest.tbettype,cs.minbet,cs.maxbet,ci.maxpermatch99
	FROM dbo.CustSetting cs WITH(NOLOCK)
		INNER JOIN #MemberTemp ci WITH(NOLOCK) 
			ON  ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 2
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
	
	/*****************************DISCOUNT SETTING**************************/	
	--Agent Level
	INSERT INTO dbo.CustDiscount3rd_Agent(CustID, SportType, BetType, Discount)
	SELECT cs.custid,dest.tsporttype,dest.tbettype,cs.groupa
	FROM dbo.CustSetting cs WITH(NOLOCK)
		INNER JOIN #SMATemp ci WITH(NOLOCK) 
			ON  ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 3
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType

	 
	--Member Level
	INSERT INTO dbo.CustDiscount3rd_Member(CustID, SportType, BetType, PlayerDiscount, AgentDiscount, MasterDiscount, SuperDiscount)
	SELECT cs.custid,dest.tsporttype,dest.tbettype,cs.PlayerDiscount,cs.discount,cs.adiscount,cs.sdiscount
	FROM dbo.CustSetting cs WITH(NOLOCK)
		INNER JOIN #MemberTemp ci WITH(NOLOCK) 
			ON  ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 3
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
				
	DROP TABLE #MemberTemp
	DROP TABLE #SMATemp
	DROP TABLE #DestinationSportBetType

