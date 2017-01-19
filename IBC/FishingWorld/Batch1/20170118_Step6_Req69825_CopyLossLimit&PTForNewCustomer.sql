

/*
	Created: Winnie
	Task: Copy PT & LossLimit for newly created customer
	DB: DBCUST/CustDB
	Date: 20170118
*/ 
		
DECLARE @maxcustid INT
	
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
		OR (currency=20 AND ci.custid NOT IN(23003140,14771858,15323100,15744710,17996464,18002026,18011327,18012360,18012400,18012427,18012473,18012480,18012482,18012484,18012696
											,18362423,18524451,18829945,19000014,19295126,19392121,19562449,19562472,20269385,20660425,20669162,20786437,21005407,21005647,21005670
											,21005685,21005748,21005851,21005868,21005888,21305783,21984259,23715203,24338704,1176070)))
		)	

CREATE TABLE #MemberTemp
(
	CustID INT PRIMARY KEY CLUSTERED,exchangeid INT
)

CREATE TABLE #SMATemp
(
	CustID INT PRIMARY KEY CLUSTERED,exchangeid INT,
	roleid TINYINT
)

	
INSERT INTO #MemberTemp (CustID,exchangeid)
SELECT custid,currency
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid = 1  AND Enabled = 1 AND custid > @maxcustid
	
INSERT INTO #SMATemp (CustID, roleid,exchangeid)
SELECT custid, roleid,currency
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid IN (2,3,4) AND Enabled = 1 AND custid > @maxcustid 

--------------------------------------WinLossLimit-------------------------------------------------
	--SuperLevel
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, 219, 1011
		, 0 AS MaxWinLimit	
		,(SELECT ISNULL(DefaultLossLimit,0) FROM LossLimit_GlobalSetting WITH (NOLOCK) WHERE ProductId = 24 AND ExchangeId = si.exchangeid)AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #SMATemp si WITH (NOLOCK) 		
	
	--Member Level
	INSERT INTO CustWinLossLimit_Member(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, 219, 1011
		, 0 AS MaxWinLimit	
		, (SELECT ISNULL(DefaultLossLimit,0) FROM LossLimit_GlobalSetting WITH (NOLOCK) WHERE ProductId = 24 AND ExchangeId = si.exchangeid)AS MaxLossLimit 
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
		,CASE	WHEN c.currency IN (5,13,67) THEN 70
				WHEN c.currency IN (1,2) AND slivepositiontaking IN (0.7,0.8)THEN slivepositiontaking*100
				WHEN c.currency IN (1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN c.currency NOT IN (5,13,67,1,2) AND slivepositiontaking = 0.85 THEN 90
				ELSE slivepositiontaking*100 
				END
		,CASE	WHEN c.currency IN (5,13,67) THEN 70
				WHEN c.currency IN (1,2) AND slivepositiontaking IN (0.7,0.8) THEN slivepositiontaking*100
				WHEN c.currency IN (1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN c.currency NOT IN (5,13,67,1,2) AND slivepositiontaking = 0.85 THEN 90
				ELSE slivepositiontaking*100 
				END
		,CASE	WHEN c.currency IN (5,13,67) THEN 70
				WHEN c.currency IN (1,2) AND slivepositiontaking IN (0.7,0.8)THEN slivepositiontaking*100
				WHEN c.currency IN (1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN c.currency NOT IN (5,13,67,1,2) AND slivepositiontaking = 0.85 THEN 90
				ELSE slivepositiontaking*100 
				END
		,0
		,0
		,0
		,0
		,0
		,90
	FROM dbo.CustSetting3rd cs WITH(NOLOCK)	
	INNER JOIN custInfo c WITH(NOLOCK) ON cs.custid=c.custid	
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

