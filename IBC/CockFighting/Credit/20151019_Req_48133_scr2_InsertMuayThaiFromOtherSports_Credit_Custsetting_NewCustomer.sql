/*
	Created: Dominic
	Date: 2015-10-15
	Task: Copy Bet Setting / Position Taking from Other Sports to MuayThai for newly created Credit customers 
	DB: DBCust.CustDB
*/  

	DECLARE @max_custid INT

	SELECT @max_custid = xxx

	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(99, 3, 44	,3, 0, 1), --PT
	(99, 1, 44	,1,0, 1), --PT
	(99, 3, 44	,3, 0, 2) --Bet Limit

				
	/*****************************POSITION TAKING**************************/
	CREATE TABLE #MemberTemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		maxpermatch99 MONEY
	)

	CREATE TABLE #SMATemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		maxpermatch99 MONEY
	)
	
	INSERT INTO #MemberTemp (CustID,maxpermatch99)
	SELECT custid,maxpermatch99
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND CustID > @max_custid AND roleid = 1 
	
	
	INSERT INTO #SMATemp (CustID,maxpermatch99)
	SELECT custid,maxpermatch99
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND CustID > @max_custid AND roleid IN (2,3,4) 


	--AGENT LEVEL
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
		,cs.spositiontaking  *100
		,cs.mpositiontaking  *100
		,cs.apositiontaking  *100
		,cs.isautompositiontaking
		,cs.autompositiontaking *100
		,cs.isautopositiontaking 
		,cs.autopositiontaking  *100
		,co.minpositiontaking  *100
		,90
	FROM dbo.CustSetting cs WITH(NOLOCK) 
		INNER JOIN dbo.custOverride co WITH(NOLOCK) 
			ON cs.custid = co.custid and cs.sporttype = co.sporttype and cs.bettype = co.bettype
		INNER JOIN #SMATemp ci WITH(NOLOCK) 
			ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 1
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
	
	
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
		,cs.spositiontaking  *100
		,cs.mpositiontaking  *100
		,cs.apositiontaking  *100
		,cs.isautompositiontaking
		,cs.autompositiontaking *100
		,cs.isautopositiontaking 
		,cs.autopositiontaking  *100
	FROM dbo.custSetting cs WITH(NOLOCK)
		INNER JOIN #MemberTemp ci WITH(NOLOCK) ON cs.CustID = ci.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 1
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
	
	
	INSERT INTO [dbo].[CustSettingMode3rd]
			   ([CustID]
			   ,[IsGrouped])
	SELECT custid,0
	FROM #MemberTemp ci WITH(NOLOCK)
	--WHERE ci.srecommend = @srecommend AND  ci.custid <= @maxcustid AND  ci.roleid = 1	
	
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
	
	DROP TABLE #MemberTemp
	DROP TABLE #SMATemp
	DROP TABLE #DestinationSportBetType

