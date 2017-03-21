

/*
	Created: Winnie
	Task: Copy PT & LossLimit for newly created direct acc
	DB: DBCUST/CustDB
	Date: 20170313
*/ 
		
DECLARE @maxcustid INT
SELECT @maxcustid = xxx
	

CREATE TABLE #MemberTemp
(
	CustID INT PRIMARY KEY CLUSTERED,exchangeid INT
)

CREATE TABLE #SMATemp
(
	CustID INT PRIMARY KEY CLUSTERED,exchangeid INT	,
	roleid TINYINT
)
------------STARTING Dummy Processing
CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY,roleid INT)
CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY,mrecommend INT,roleid INT)
CREATE TABLE #DirectMember (CustID INT PRIMARY KEY,recommend INT,mrecommend INT,roleid INT)			
--- get direct master
INSERT INTO #DirectMaster (CustID,roleid)
SELECT c.custid, c.roleid
FROM Customer c with(nolock)
INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid=c.custid
WHERE SITE in ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
	and c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and c.srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and c.roleid=3 
	AND (ci.custid <=100-- dummy acc =<100
	OR ci.custid IN(1469577, 21278849, 21278858))
	AND ci.Enabled=1

--- get direct agent
INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
SELECT c.custid, c.mrecommend,c.roleid
FROM Customer c WITH(NOLOCK)
INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid=c.custid
WHERE site in  ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
	and c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and c.mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and c.roleid=2 
	AND (ci.custid <=100-- dummy acc =<100
	OR ci.custid IN(1469577, 21278849, 21278858))
	AND ci.Enabled=1
	
INSERT INTO #DirectMember(CustID,recommend,mrecommend,roleid)
SELECT c.custid, c.recommend,c.mrecommend,c.roleid
FROM Customer c WITH(NOLOCK)
INNER JOIN Customer ca (nolock) on c.recommend=ca.custid 
INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid=c.custid
WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.roleid=1 
	AND (ci.custid <=100-- dummy acc =<100
	OR ci.custid IN(1469577, 21278849, 21278858))
	AND  ca.site in ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
	AND ci.Enabled=1
----------- For SMA  -----------
INSERT INTO #SMATemp (CustID,roleid,exchangeid)

SELECT CI.CustID,CI.roleid,ci.currency -- Direct Master 
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster D ON CI.custid = D.CustID 
WHERE ci.custid > @maxcustid 

UNION 

SELECT DISTINCT CI.CustID,CI.roleid,ci.currency -- Master of direct agent
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent D ON CI.custid = D.mrecommend 
WHERE ci.custid > @maxcustid 
	
UNION 

SELECT CI.CustID,CI.roleid ,ci.currency-- Agent of direct master
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
WHERE CI.roleid = 2
	AND ci.custid > @maxcustid AND ci.Enabled=1
UNION 
SELECT CI.CustID,CI.roleid,ci.currency -- Direct Agent
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent D ON CI.custid = D.CustID 
WHERE ci.custid > @maxcustid 

UNION 

SELECT DISTINCT CI.CustID,CI.roleid,ci.currency -- Master of direct member
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMember D ON CI.custid = D.mrecommend 
WHERE  ci.Enabled = 1  AND ci.custid > @maxcustid 

UNION 
SELECT DISTINCT CI.CustID,CI.roleid,ci.currency -- agent of direct member
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMember D ON CI.custid = D.recommend 
WHERE  ci.Enabled = 1 AND ci.custid > @maxcustid 
	
---------- For members ---------
INSERT INTO #MemberTemp (CustID,exchangeid)
SELECT CI.custid,ci.currency
FROM Custinfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster M ON CI.mrecommend = M.CustID
WHERE CI.roleid = 1	AND ci.custid > @maxcustid AND ci.Enabled=1
	
UNION 
SELECT CI.custid,ci.currency
FROM Custinfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent M ON CI.recommend = M.CustID
WHERE CI.roleid = 1 AND ci.custid > @maxcustid AND ci.Enabled=1

UNION 
SELECT CI.custid,ci.currency
FROM Custinfo CI WITH (NOLOCK)
	INNER JOIN #DirectMember M ON CI.custid = M.CustID
WHERE ci.custid > @maxcustid
DECLARE @Sporttype INT, @Bettype INT, @SporttypeRef INT, @BettypeRef INT,@MaxPT TINYINT,@ProductID INT

SELECT @Sporttype = 219, @Bettype = 1011, @SporttypeRef = 161,@BettypeRef=85,@ProductID=24
SELECT @MaxPT= MaxPT from ProductSettingDetail WITH(NOLOCK) where SportType=@Sporttype and BetType=@Bettype and SettingType=1
	
--------------------------------------WinLossLimit-------------------------------------------------
	--Master Agent Level
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, @Sporttype, @Bettype
		, 0 AS MaxWinLimit	
		, (SELECT ISNULL(DefaultLossLimit,0) FROM LossLimit_GlobalSetting WITH (NOLOCK) WHERE ProductId = @ProductID AND ExchangeId = si.exchangeid)AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #SMATemp si WITH (NOLOCK) 		
	
	--Member Level
	INSERT INTO CustWinLossLimit_Member(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, @Sporttype, @Bettype
		, 0 AS MaxWinLimit	
		,(SELECT ISNULL(DefaultLossLimit,0) FROM LossLimit_GlobalSetting WITH (NOLOCK) WHERE ProductId = @ProductID AND ExchangeId = si.exchangeid)AS MaxLossLimit 
		, 1 IsAutoReset
	FROM #MemberTemp si WITH (NOLOCK) 
	
	--------------------------------------PT Setting-------------------------------------------------	
	--Master LEVEL
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
		dm.custid,  @Sporttype, @Bettype, 0
		,0
		,CASE	WHEN ci.site='611111' AND ci.currency =4 THEN 70
				WHEN ci.site='611111' AND ci.currency <>4 THEN 90
				WHEN ci.site='722222' AND ci.currency IN(5,67,13) THEN 70
				WHEN ci.site='722222' AND ci.currency IN(2,1) THEN 90
				WHEN ci.site='766666' AND ci.currency =70 THEN 90
				WHEN ci.site='789y' AND ci.currency =35 AND mlivepositiontaking=0.85 THEN 90
				WHEN ci.site='789y' AND ci.currency =35 AND mlivepositiontaking=0.5 THEN 50
				WHEN ci.site='789y' AND ci.currency =3 AND slivepositiontaking IN(0, 0.70, 0.80, 0.85)  THEN 90
				WHEN ci.site='789y' AND ci.currency IN (40,17,64) THEN 80
				WHEN ci.site='789y' AND ci.currency =16 AND mlivepositiontaking<>0.85 THEN 80
				WHEN ci.site='789y' AND ci.currency =16 AND mlivepositiontaking=0.85 THEN 85
				WHEN ci.site='7aa666' AND ci.currency =69 THEN 90
				WHEN ci.site='Best-odds' THEN mlivepositiontaking*100
				WHEN ci.site='XYZbet' AND ci.currency =21 THEN 80
				WHEN ci.site='XYZbet' AND ci.currency =6 THEN 90
				ELSE ISNULL(mlivepositiontaking*100,90)
				END
		,0
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #DirectMaster dm WITH(NOLOCK) 	
	INNER JOIN Customer ci WITH(NOLOCK) ON dm.CustID=ci.custid
	LEFT JOIN dbo.CustSetting3rd cs WITH(NOLOCK)ON dm.CustID=cs.custid	
	WHERE dm.RoleID=3 AND cs.sporttype=@SporttypeRef AND	 cs.bettype=@BettypeRef AND dm.custid > @maxcustid
	
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
		ci.custid,  @Sporttype, @Bettype, 0
		,0
		,@MaxPT
		,0
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #SMATemp ci WITH(NOLOCK) 		
	WHERE ci.RoleID=3 AND ci.CustID NOT IN(SELECT CustID FROM #DirectMaster)	
	
	--Agent LEVEL
	--direct agent
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
		da.custid, @Sporttype, @Bettype, 0
		,0
		,0
		,CASE	WHEN ci.site='611111' AND ci.currency =4 THEN 70
				WHEN ci.site='611111' AND ci.currency <>4 THEN 90
				WHEN ci.site='722222' AND ci.currency IN(5,67,13) THEN 70
				WHEN ci.site='722222' AND ci.currency IN(2,1) THEN 90
				WHEN ci.site='766666' AND ci.currency =70 THEN 90
				WHEN ci.site='789y' AND ci.currency =35 AND alivepositiontaking=0.85 THEN 90
				WHEN ci.site='789y' AND ci.currency =35 AND alivepositiontaking=0.5 THEN 50
				WHEN ci.site='789y' AND ci.currency =3 AND slivepositiontaking IN(0, 0.70, 0.80, 0.85) THEN 90
				WHEN ci.site='789y' AND ci.currency IN (40,17,64) THEN 80
				WHEN ci.site='789y' AND ci.currency =16 AND alivepositiontaking<>0.85 THEN 80
				WHEN ci.site='789y' AND ci.currency =16 AND alivepositiontaking=0.85 THEN 85
				WHEN ci.site='7aa666' AND ci.currency =69 THEN 90
				WHEN ci.site='Best-odds' THEN alivepositiontaking*100
				WHEN ci.site='XYZbet' AND ci.currency =21 THEN 80
				WHEN ci.site='XYZbet' AND ci.currency =6 THEN 90
				ELSE ISNULL(alivepositiontaking*100,90)
				END
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #DirectAgent da WITH(NOLOCK) 	
	INNER JOIN Customer ci WITH(NOLOCK) ON da.CustID=ci.custid
	LEFT JOIN dbo.CustSetting3rd cs WITH(NOLOCK)ON da.CustID=cs.custid	
	WHERE da.RoleID=2 AND da.custid > @maxcustid
	
	-- agent of direct master
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
		ci.custid,  @Sporttype, @Bettype, 0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,@MaxPT	
	FROM custInfo CI WITH (NOLOCK)
		INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
	WHERE CI.roleid = 2 AND CI.custid > @maxcustid AND ci.Enabled=1
	
		-- dummy agent of member	
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
		ci.custid,  @Sporttype, @Bettype, 0
		,0
		,0
		,@MaxPT
		,0
		,0
		,0
		,0
		,0
		,@MaxPT		
	FROM #SMATemp ci WITH(NOLOCK) 
	WHERE RoleID=2 AND ci.CustID NOT IN(SELECT CustID FROM #DirectAgent)	
	AND ci.CustID NOT IN (SELECT cii.CustID FROM custInfo cii WITH (NOLOCK)
							INNER JOIN #DirectMaster D ON Cii.mrecommend = D.CustID 
							WHERE Cii.roleid = 2 AND Cii.custid > @maxcustid AND cii.Enabled=1)	

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

	DROP TABLE #SMATemp
	DROP TABLE #MemberTemp	
	DROP TABLE #DirectAgent
	DROP TABLE #DirectMaster
	DROP TABLE #DirectMember