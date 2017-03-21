

/*
	Created: Winnie
	Task: Copy PT & LossLimit for newly created customer
	DB: DBCUST/CustDB
	Date: 20170313
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
AND ci.site IN ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')
-- exclude dummy <=100
AND  ci.custid >100
-- exclude dummy >100
AND ci.custid NOT IN (1469577, 21278849, 21278858)) 
-- CROSS-SITE
OR ci.custid IN (674248,395075,1164457,17721601,1016771,324561,1127269,938136)		

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
	
	--Member Level
	INSERT INTO CustWinLossLimit_Member(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, @Sporttype, @Bettype
		, 0 AS MaxWinLimit	
		, (SELECT ISNULL(DefaultLossLimit,0) FROM LossLimit_GlobalSetting WITH (NOLOCK) WHERE ProductId = @ProductID AND ExchangeId = si.exchangeid)AS MaxLossLimit 
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
		cs.custid, @Sporttype, @Bettype, 0
		,CASE	WHEN c.srecommend=938136 AND c.currency IN (5,13,67) THEN 70
				WHEN c.srecommend=938136 AND c.currency IN (1,2) AND slivepositiontaking IN (0.7,0.8)THEN slivepositiontaking*100
				WHEN c.srecommend=938136 AND c.currency IN (1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN c.srecommend=938136 AND c.currency NOT IN (5,13,67,1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN c.srecommend IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269) AND c.currency =3 AND slivepositiontaking=0.73 THEN 80
				WHEN c.srecommend IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269) AND c.currency <>3 AND slivepositiontaking <0.9  THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='611111' AND c.currency =4 THEN 70
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='611111' AND c.currency <>4 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='722222' AND c.currency IN(5,67,13) THEN 70
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='722222' AND c.currency IN(2,1) THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='766666' AND c.currency =70 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =35 AND slivepositiontaking=0.85 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =35 AND slivepositiontaking=0.5 THEN 50
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =35 AND slivepositiontaking<>0.5 AND slivepositiontaking<>0.85 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency IN (40,17,64) THEN 80
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =16 AND slivepositiontaking<>0.85 THEN 80
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =16 AND slivepositiontaking=0.85 THEN 85
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='7aa666' AND c.currency =69 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='Best-odds' THEN slivepositiontaking*100
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='XYZbet' AND c.currency =21 THEN 80
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='XYZbet' AND c.currency =6 THEN 90
				ELSE ISNULL(slivepositiontaking*100,90)
				END
		,CASE	WHEN c.srecommend=938136 AND c.currency IN (5,13,67) THEN 70
				WHEN c.srecommend=938136 AND c.currency IN (1,2) AND slivepositiontaking IN (0.7,0.8)THEN slivepositiontaking*100
				WHEN c.srecommend=938136 AND c.currency IN (1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN c.srecommend=938136 AND c.currency NOT IN (5,13,67,1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN c.srecommend IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269) AND c.currency =3 AND slivepositiontaking=0.73 THEN 80
				WHEN c.srecommend IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269) AND c.currency <>3 AND slivepositiontaking <0.9  THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='611111' AND c.currency =4 THEN 70
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='611111' AND c.currency <>4 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='722222' AND c.currency IN(5,67,13) THEN 70
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='722222' AND c.currency IN(2,1) THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='766666' AND c.currency =70 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =35 AND slivepositiontaking=0.85 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =35 AND slivepositiontaking=0.5 THEN 50
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =35 AND slivepositiontaking<>0.5 AND slivepositiontaking<>0.85 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency IN (40,17,64) THEN 80
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =16 AND slivepositiontaking<>0.85 THEN 80
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =16 AND slivepositiontaking=0.85 THEN 85
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='7aa666' AND c.currency =69 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='Best-odds' THEN slivepositiontaking*100
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='XYZbet' AND c.currency =21 THEN 80
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='XYZbet' AND c.currency =6 THEN 90
				ELSE ISNULL(slivepositiontaking*100,90)
				END
		,CASE	
				WHEN c.srecommend=938136 AND c.currency IN (5,13,67) THEN 70
				WHEN c.srecommend=938136 AND c.currency IN (1,2) AND slivepositiontaking IN (0.7,0.8)THEN slivepositiontaking*100
				WHEN c.srecommend=938136 AND c.currency IN (1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN c.srecommend=938136 AND c.currency NOT IN (5,13,67,1,2) AND slivepositiontaking = 0.85 THEN 90
				WHEN c.srecommend IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269) AND c.currency =3 AND slivepositiontaking=0.73 THEN 80
				WHEN c.srecommend IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269) AND c.currency <>3 AND slivepositiontaking <0.9  THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='611111' AND c.currency =4 THEN 70
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='611111' AND c.currency <>4 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='722222' AND c.currency IN(5,67,13) THEN 70
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='722222' AND c.currency IN(2,1) THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='766666' AND c.currency =70 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =35 AND slivepositiontaking=0.85 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =35 AND slivepositiontaking=0.5 THEN 50
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =35 AND slivepositiontaking<>0.5 AND slivepositiontaking<>0.85 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency IN (40,17,64) THEN 80
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =16 AND slivepositiontaking<>0.85 THEN 80
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='789y' AND c.currency =16 AND slivepositiontaking=0.85 THEN 85
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='7aa666' AND c.currency =69 THEN 90
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='Best-odds' THEN slivepositiontaking*100
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='XYZbet' AND c.currency =21 THEN 80
				WHEN c.srecommend NOT IN (674248,395075,1164457,1016771,17721601,1016771,324561,1127269,938136) AND c.site='XYZbet' AND c.currency =6 THEN 90
				ELSE ISNULL(slivepositiontaking*100,90)
				END
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM  #SMATemp s
	INNER JOIN Customer c WITH(NOLOCK) ON s.custid=c.custid
	LEFT JOIN  dbo.CustSetting3rd cs WITH(NOLOCK) ON cs.custid=c.CustID	
	WHERE s.roleid=4 AND cs.sporttype=@SporttypeRef AND	 cs.bettype=@BettypeRef
	
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
DROP TABLE #supers

