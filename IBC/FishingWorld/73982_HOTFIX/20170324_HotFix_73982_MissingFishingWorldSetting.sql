/*
	Created: 20170324@Helen
	Task: Hotfix - Fishing World | 733333 & INDO | Some accounts don't have FW setting - https://nexdev.net/issues/73982
	DB: DBCUST/CUSTDB
*/
DECLARE @Sporttype INT, @Bettype INT, @MaxPT TINYINT,@ProductID INT

SELECT @Sporttype = 219, @Bettype = 1011, @ProductID=24
SELECT @MaxPT= MaxPT from ProductSettingDetail WITH(NOLOCK) where SportType=@Sporttype and BetType=@Bettype and SettingType=1

CREATE TABLE #CustTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
		, RoleID INT
		, Currency INT	
	)

INSERT INTO #CustTemp (CustID,RoleID,Currency)
-- For Master & Downline
SELECT c.custid,c.roleid ,c.currency
FROM custinfo c WITH(NOLOCK)
WHERE c.mrecommend IN (
						-- list of master missing setting from 9/03 - 10/03 due to change setting type for FW
						25280809
						,25274944
						,25275037
						,25284724
						,25284383

						--,25278066 -- RG1V6: has downline and have min pt = 0.7

						,25280071
						)
-- For Agents & Downline
UNION ALL

SELECT c.custid,c.roleid ,c.currency
FROM custinfo c WITH(NOLOCK)
WHERE c.recommend IN (
						25277959
						,25277981
						--,25277021 --MOJU96: Have min pt, n4=0.9, have member downline, only have log update min PT for super, no log change PT for master agent
						--,25289836 -- MOJULA: Have min pt, n4=0.9, have member downline, only have log update min PT for super, no log change PT for master agent
					)

--------------------------------------WinLossLimit-------------------------------------------------
INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
SELECT si.custid, @Sporttype, @Bettype
	, 0 AS MaxWinLimit	
	, WL.DefaultLossLimit
	, 1 IsAutoReset
FROM #CustTemp si WITH (NOLOCK) 	
	CROSS APPLY (SELECT ISNULL(DefaultLossLimit,0) AS DefaultLossLimit 
				 FROM LossLimit_GlobalSetting WITH (NOLOCK) 
				 WHERE ProductId = @ProductID AND ExchangeId = si.currency) AS WL
WHERE si.RoleID IN (2,3)
	AND NOT EXISTS(SELECT 1 FROM CustWinLossLimit_Agent ca WITH(NOLOCK) WHERE SportType=@Sporttype AND si.CustId=ca.CustId)

INSERT INTO CustWinLossLimit_Member(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
SELECT si.custid, @Sporttype, @Bettype
	, 0 AS MaxWinLimit	
	, WL.DefaultLossLimit
	, 1 IsAutoReset
FROM #CustTemp si WITH (NOLOCK) 	
	CROSS APPLY (SELECT ISNULL(DefaultLossLimit,0) AS DefaultLossLimit 
				 FROM LossLimit_GlobalSetting WITH (NOLOCK) 
				 WHERE ProductId = @ProductID AND ExchangeId = si.currency) AS WL
WHERE si.RoleID = 1
	AND  NOT EXISTS(SELECT 1 FROM CustWinLossLimit_Member ca WITH(NOLOCK) WHERE SportType=@Sporttype AND si.CustId=ca.CustId)
-------------------------------------- PT -------------------------------------------------
--Master AGENT LEVEL
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
	,0
	,0
	,0
	,0
	,0
	,0
	,@MaxPT
FROM #CustTemp ci 
WHERE  ci.roleid IN(2,3)
	AND NOT EXISTS(SELECT 1 FROM CustPTSetting3rd_Agent ca WITH(NOLOCK) WHERE SportType=@Sporttype AND ci.CustId=ca.CustId)

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
	ci.custid, @Sporttype, @Bettype, 0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
FROM #CustTemp ci WITH(NOLOCK) 
WHERE CI.RoleID = 1
	AND NOT EXISTS(SELECT 1 FROM CustPTSetting3rd_Member ca WITH(NOLOCK) WHERE SportType=@Sporttype AND ci.CustId=ca.CustId)

DROP TABLE #CustTemp