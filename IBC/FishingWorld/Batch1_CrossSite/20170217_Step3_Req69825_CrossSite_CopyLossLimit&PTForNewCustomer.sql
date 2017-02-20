

/*
	Created: Winnie
	Task: Copy PT & LossLimit for newly created customer Cross site
	DB: DBCUST/CustDB
	Date: 20170217
*/ 
		
DECLARE @maxcustid INT
	
SELECT @maxcustid = xxx
	
CREATE TABLE #supers (custid int,exchangeid INT)
	
INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
FROM dbo.Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND c.Enabled=1
		-- Production
		AND ci.custid IN (5005322,1036451,993226,2042873,1156957,506057,796555,2453866)
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
DECLARE @Sporttype INT, @Bettype INT, @SporttypeRef INT, @BettypeRef INT,@MaxPT TINYINT,@ProductID INT

SELECT @Sporttype = 219, @Bettype = 1011, @SporttypeRef = 161,@BettypeRef=85,@ProductID=24
SELECT @MaxPT= MaxPT from ProductSettingDetail WITH(NOLOCK) where SportType=@Sporttype and BetType=@Bettype and SettingType=1

--------------------------------------WinLossLimit-------------------------------------------------
	--SuperLevel
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, @Sporttype, @Bettype
		, 0 AS MaxWinLimit	
		,(SELECT ISNULL(DefaultLossLimit,0) FROM LossLimit_GlobalSetting WITH (NOLOCK) WHERE ProductId = @ProductID AND ExchangeId = si.exchangeid)AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #SMATemp si WITH (NOLOCK) 		
	WHERE NOT EXISTS(SELECT TOP 1 1 FROM CustWinLossLimit_Agent cw WITH(NOLOCK) WHERE cw.Sporttype=@Sporttype AND cw.CustId=si.CustID )
	
	--Member Level
	INSERT INTO CustWinLossLimit_Member(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, @Sporttype, @Bettype
		, 0 AS MaxWinLimit	
		, (SELECT ISNULL(DefaultLossLimit,0) FROM LossLimit_GlobalSetting WITH (NOLOCK) WHERE ProductId = @ProductID AND ExchangeId = si.exchangeid)AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #MemberTemp si WITH (NOLOCK) 
	WHERE NOT EXISTS(SELECT TOP 1 1 FROM CustWinLossLimit_Member cw WITH(NOLOCK) WHERE cw.Sporttype=@Sporttype AND cw.CustId=si.CustID )
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
		cs.custid, @Sporttype, @Bettype, 0
		,CASE	WHEN c.currency IN (5,13,67) THEN 70
				WHEN c.currency IN (1,2) AND slivepositiontaking IN (0.7,0.8)THEN slivepositiontaking*100
				WHEN c.currency IN (1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN c.currency NOT IN (5,13,67,1,2) AND slivepositiontaking = 0.85 THEN 90
				ELSE ISNULL(slivepositiontaking*100,90)
				END
		,CASE	WHEN c.currency IN (5,13,67) THEN 70
				WHEN c.currency IN (1,2) AND slivepositiontaking IN (0.7,0.8) THEN slivepositiontaking*100
				WHEN c.currency IN (1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN c.currency NOT IN (5,13,67,1,2) AND slivepositiontaking = 0.85 THEN 90
				ELSE ISNULL(slivepositiontaking*100,90)
				END
		,CASE	WHEN c.currency IN (5,13,67) THEN 70
				WHEN c.currency IN (1,2) AND slivepositiontaking IN (0.7,0.8)THEN slivepositiontaking*100
				WHEN c.currency IN (1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN c.currency NOT IN (5,13,67,1,2) AND slivepositiontaking = 0.85 THEN 90
				ELSE ISNULL(slivepositiontaking*100,90)
				END
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM  #SMATemp s
	INNER JOIN custInfo c WITH(NOLOCK) ON s.custid=c.custid
	LEFT JOIN  dbo.CustSetting3rd cs WITH(NOLOCK) ON cs.custid=c.CustID	
	WHERE s.roleid=4 AND cs.sporttype=@SporttypeRef AND	 cs.bettype=@BettypeRef
	AND NOT EXISTS(SELECT TOP 1 1 FROM CustPTSetting3rd_Agent pt WITH(NOLOCK) WHERE pt.Sporttype=@Sporttype AND pt.CustId=s.CustID )
	
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
	FROM #SMATemp ci 
	WHERE  ci.roleid IN(2,3)
	AND NOT EXISTS(SELECT TOP 1 1 FROM CustPTSetting3rd_Agent pt WITH(NOLOCK) WHERE pt.Sporttype=@Sporttype AND pt.CustId=ci.CustID )
	
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
	FROM 	#MemberTemp ci WITH(NOLOCK) 
	WHERE NOT EXISTS(SELECT TOP 1 1 FROM CustPTSetting3rd_Member pt WITH(NOLOCK) WHERE pt.Sporttype=@Sporttype AND pt.CustId=ci.CustID )
		  
DROP TABLE #SMATemp
DROP TABLE #MemberTemp
DROP TABLE #supers

