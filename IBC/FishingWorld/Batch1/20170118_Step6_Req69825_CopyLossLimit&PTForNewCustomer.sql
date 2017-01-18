

/*
	Created: Winnie
	Task: Copy PT & LossLimit for newly created customer
	DB: DBCUST/CustDB
	Date: 20170118
*/ 
		
DECLARE @maxcustid INT, @exchangeid INT
	
SELECT @maxcustid = xxx
	
CREATE TABLE #supers (custid int,exchangeid INT)
	
INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
FROM dbo.Customer ci WITH(NOLOCK)
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		-- Production
		AND ((ci.site IN ('733333','222223', '222225', '222227', '222229')	
		-- CROSS-SITE
		AND ci.custid NOT IN (674248,395075,1164457,1016771,993226,2453866,1156957,1156957,17721601,1156957,1036451,993226,1016771,324561,506057,2453866,1127269,1036451,1036451,2042873
		,2042873,1036451,796555,5005322))
		OR ci.currency = 20)
		)	

CREATE TABLE #MemberTemp
(
	CustID INT PRIMARY KEY CLUSTERED
)

CREATE TABLE #SMATemp
(
	CustID INT PRIMARY KEY CLUSTERED,	
	roleid TINYINT
)

	
INSERT INTO #MemberTemp (CustID)
SELECT custid
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid = 1  AND Enabled = 1 AND custid > @maxcustid
	
INSERT INTO #SMATemp (CustID, roleid)
SELECT custid, roleid
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid IN (2,3,4) AND Enabled = 1 AND custid > @maxcustid 

	DECLARE @DefaultLossLimit MONEY
	DECLARE @ProductID INT
	SELECT @ProductID=24
	SELECT @DefaultLossLimit = ISNULL(DefaultLossLimit,0)
	FROM LossLimit_GlobalSetting WITH (NOLOCK)
	WHERE ProductId = @ProductID AND ExchangeId = @ExchangeID
--------------------------------------WinLossLimit-------------------------------------------------
	--SuperLevel
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, 219, 1011
		, 0 AS MaxWinLimit	
		, @DefaultLossLimit AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #SMATemp si WITH (NOLOCK) 		
	
	--Member Level
	INSERT INTO CustWinLossLimit_Member(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, 219, 1011
		, 0 AS MaxWinLimit	
		, @DefaultLossLimit AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #MemberTemp si WITH (NOLOCK) 
	--------------------------------------PT-------------------------------------------------
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
		cs.custid, 219, 1011, 0
		,CASE	WHEN @ExchangeID IN (5,13,67) THEN 70
				WHEN @ExchangeID IN (1,2) AND spositiontaking IN (0.7,0.8)THEN spositiontaking*100
				WHEN @ExchangeID IN (1,2) AND spositiontaking = 0.85 THEN 90
				WHEN @ExchangeID NOT IN (5,13,67,1,2) AND spositiontaking = 0.85 THEN 90
				ELSE spositiontaking*100 
				END
		,CASE	WHEN @ExchangeID IN (5,13,67) THEN 70
				WHEN @ExchangeID IN (1,2) AND spositiontaking IN (0.7,0.8) THEN spositiontaking*100
				WHEN @ExchangeID IN (1,2) AND spositiontaking = 0.85 THEN 90
				WHEN @ExchangeID NOT IN (5,13,67,1,2) AND spositiontaking = 0.85 THEN 90
				ELSE spositiontaking*100 
				END
		,CASE	WHEN @ExchangeID IN (5,13,67) THEN 70
				WHEN @ExchangeID IN (1,2) AND spositiontaking IN (0.7,0.8)THEN spositiontaking*100
				WHEN @ExchangeID IN (1,2) AND spositiontaking = 0.85 THEN 90
				WHEN @ExchangeID NOT IN (5,13,67,1,2) AND spositiontaking = 0.85 THEN 90
				ELSE spositiontaking*100 
				END
		,0
		,0
		,0
		,0
		,0
		,90
	FROM dbo.CustSetting3rd cs WITH(NOLOCK)		
	INNER JOIN #SMATemp s ON cs.custid=s.CustID	
	WHERE s.roleid=4 AND cs.sporttype=161 AND	 cs.bettype=85
	
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
		ci.custid, 219, 1011, 0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,90
	FROM #SMATemp ci 
	WHERE  ci.roleid IN(2,3)
	
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
		ci.custid, 219, 1011, 0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
	FROM 	#MemberTemp ci WITH(NOLOCK) 
		  
DROP TABLE #SMATemp
DROP TABLE #MemberTemp
DROP TABLE #supers

