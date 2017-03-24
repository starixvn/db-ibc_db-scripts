/*
	Created: 20170324@Helen
	Task: Hotfix - Fishing World | 733333 & INDO | Some accounts don't have FW setting - https://nexdev.net/issues/73982
	DB: DBCUST/CUSTDB
*/
USE CustDB

GO

DECLARE @Sporttype INT, @Bettype INT, @MaxPT TINYINT,@ProductID INT

SELECT @Sporttype = 219, @Bettype = 1011, @ProductID=24

SELECT @MaxPT= MaxPT from ProductSettingDetail WITH(NOLOCK) where SportType=@Sporttype and BetType=@Bettype and SettingType=1

CREATE TABLE #CustTemp_MinPT
	(
		CustID INT PRIMARY KEY CLUSTERED
		, RoleID INT
		, Currency INT	
		, recommend INT
	)

INSERT INTO #CustTemp_MinPT (CustID,RoleID,Currency, recommend)
-- For Master & Downline
SELECT c.custid,c.roleid ,c.currency,c.recommend
FROM custinfo c WITH(NOLOCK)
WHERE c.mrecommend IN 
(
	25278066 -- RG1V6: has downline and have min pt = 0.7
)
-- For Agent & Downline
UNION ALL

SELECT c.custid,c.roleid ,c.currency, c.recommend
FROM custinfo c WITH(NOLOCK)
WHERE c.recommend IN 
(
	25277021 --MOJU96: Have min pt, n4=0.9, have member downline, only have log update min PT for super, no log change PT for master agent
	,25289836 -- MOJULA: Have min pt, n4=0.9, have member downline, only have log update min PT for super, no log change PT for master agent
)
--------------------------------------WinLossLimit-------------------------------------------------
INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
SELECT c_mpt.custid, @Sporttype, @Bettype
	, 0 AS MaxWinLimit	
	, WL.DefaultLossLimit
	, 1 IsAutoReset
FROM #CustTemp_MinPT c_mpt WITH (NOLOCK) 	
	CROSS APPLY (SELECT ISNULL(DefaultLossLimit,0) AS DefaultLossLimit 
				 FROM LossLimit_GlobalSetting WITH (NOLOCK) 
				 WHERE ProductId = @ProductID AND ExchangeId = c_mpt.currency) AS WL
WHERE c_mpt.RoleID IN (2,3)
	AND NOT EXISTS(SELECT 1 FROM CustWinLossLimit_Agent ca WITH(NOLOCK) WHERE SportType=@Sporttype AND c_mpt.CustId=ca.CustId)
	

INSERT INTO CustWinLossLimit_Member(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
SELECT c_mpt.custid, @Sporttype, @Bettype
	, 0 AS MaxWinLimit	
	, WL.DefaultLossLimit
	, 1 IsAutoReset
FROM #CustTemp_MinPT c_mpt WITH (NOLOCK) 	
	CROSS APPLY (SELECT ISNULL(DefaultLossLimit,0) AS DefaultLossLimit 
				 FROM LossLimit_GlobalSetting WITH (NOLOCK) 
				 WHERE ProductId = @ProductID AND ExchangeId = c_mpt.currency) AS WL
WHERE c_mpt.RoleID  = 1
	AND NOT EXISTS(SELECT 1 FROM CustWinLossLimit_Member ca WITH(NOLOCK) WHERE SportType=@Sporttype AND c_mpt.CustId=ca.CustId)
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
	c_mpt.custid, @Sporttype, @Bettype, 0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,@MaxPT
FROM #CustTemp_MinPT c_mpt 
WHERE c_mpt.roleid IN (2,3)
	AND NOT EXISTS(SELECT 1 FROM CustPTSetting3rd_Agent ca WITH(NOLOCK) WHERE SportType=@Sporttype AND c_mpt.CustId=ca.CustId)

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
	c_mpt.custid, @Sporttype, @Bettype, 0
	
	,CASE WHEN recommend IN (25277021,25289836) THEN 90 -- MOJU96 (custid = 25277021); MOJULA (custid = 25289836)
		  WHEN recommend IN (25412377,25347772) THEN 70 -- RG1V662 (custid = 25412377); RG1V666 (custid = 25347772)
		  ELSE 0 END AS SuperPT
	,0 AS MasterPT
	,0 AS AgentPT
	
	,0
	,0
	,0
	,0
FROM #CustTemp_MinPT c_mpt WITH(NOLOCK) 
WHERE c_mpt.RoleID = 1
	AND NOT EXISTS(SELECT 1 FROM CustPTSetting3rd_Member ca WITH(NOLOCK) WHERE SportType=@Sporttype AND c_mpt.CustId=ca.CustId)

DROP TABLE #CustTemp_MinPT