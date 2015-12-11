/*
	20151214@Dominic : Insert Cock Fighting setting of UUS members for stress test purposes on placing bets (SIT) Redmine #48364
	Run at: DBCUST@CustDB
*/

-------------------------------- STEP 1: Insert Master Data -------------------------------------------
INSERT INTO [dbo].[ProductStatusProfile]
           ([Sporttype]
           ,[Bettype]
           ,[bitmapOrder])
     VALUES
           (206
           ,1003
           ,2)
GO

-------------------------------- STEP 2: Import CF Data -------------------------------------------
CREATE TABLE #CustomerTemp
(
	CustID INT PRIMARY KEY CLUSTERED
)

CREATE TABLE #AgentTemp
(
	AgentID INT PRIMARY KEY CLUSTERED
)

INSERT #CustomerTemp(CustID)
SELECT CustID
FROM dbo.custInfo ci WITH(NOLOCK)
WHERE ci.roleid = 1 AND ci.currency = 20 

INSERT #AgentTemp(AgentID)
SELECT CustID
FROM dbo.custInfo ci WITH(NOLOCK)
WHERE ci.roleid = 2 AND ci.currency = 20 

CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT,  SettingType INT)
INSERT INTO #DestinationSportBetType
VALUES
(44, 3, 206	,1004,  1), --PT
(44, 3, 206	,1004,  2), --Bet Limit
(44, 3, 206	,1004,  3) --Discount

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
WHERE cs.IsLive = 0 AND cs.custid IN (SELECT CustID FROM #CustomerTemp)

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
WHERE cs.IsLive = 0 AND cs.AgentID IN (SELECT AgentID FROM #AgentTemp)

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
WHERE cs.custid IN (SELECT CustID FROM #CustomerTemp)
		
--Discount
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
		  ,0.01
		  ,0.01
		  ,0.01
		  ,0.01
FROM dbo.CustBetSetting3rd_Member cs WITH(NOLOCK) 
INNER JOIN #DestinationSportBetType f WITH(NOLOCK)
	ON cs.SportType = f.fSportType
		AND cs.BetType = f.fBetType
		AND f.SettingType = 3
WHERE cs.custid IN (SELECT CustID FROM #CustomerTemp)


DROP TABLE #CustomerTemp
DROP TABLE #AgentTemp
DROP TABLE #DestinationSportBetType
