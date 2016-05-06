/*
	Created: Elodie
	Task: Copy StakeLevel & WinLossLimit for newly created customer
	DB: DBCUST/CustDB
	Date: 20150420
*/ 

DECLARE @maxcustID2 INT
	
SELECT @maxcustID2 = xxx
	
CREATE TABLE #supers (custid int)
	
INSERT INTO #supers(custid)
SELECT ci.custid
FROM CustInfo ci WITH(NOLOCK)
 INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
 INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
 LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
 AND ci.username NOT LIKE '3rdSuper%'
 AND cs.isinternal = 0
 AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
 AND s.islicensee = 0
 AND ci.currency IN (34,45,43) --IDR,WON,'THB'
 
DECLARE @SportType SMALLINT, @BetType SMALLINT
SELECT @SportType = 212, @BetType = 4001

CREATE TABLE #MemberTemp
(
	CustID INT PRIMARY KEY CLUSTERED,
	srecommend INT,
	mrecommend INT,
	recommend INT,
	SyncCasino BIT
)

CREATE TABLE #SMATemp
(
	CustID INT PRIMARY KEY CLUSTERED,
	roleid TINYINT,
	srecommend INT,
	mrecommend INT,
	recommend INT,
	SyncCasino BIT
)
	
INSERT INTO #MemberTemp (CustID, srecommend, mrecommend, recommend, SyncCasino)
SELECT custid, srecommend, mrecommend, recommend, SyncCasino
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid = 1  AND Enabled = 1 AND custid > @maxcustID2	
	
INSERT INTO #SMATemp (CustID, roleid, srecommend, mrecommend, recommend, SyncCasino)
SELECT custid, roleid, srecommend, mrecommend, recommend, SyncCasino
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid IN (2,3,4) AND Enabled = 1 AND custid > @maxcustID2 

--------------------------------------WinLossLimit-------------------------------------------------
--SuperLevel
INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
SELECT cs.custid, @SportType, @BetType	
	,CASE WHEN ci.SyncCasino = 0 THEN 0 ELSE cs.MaxWinLimit END AS MaxWinLimit
	,CASE WHEN ci.SyncCasino = 0 THEN lg.DefaultLossLimit ELSE cs.MaxLossLimit END AS MaxLossLimit
	,CASE WHEN ci.SyncCasino = 0 THEN 1 ELSE cs.IsAutoReset END AS IsAutoReset
FROM dbo.CustWinLimit cs WITH (NOLOCK) 
	INNER JOIN #SMATemp ci WITH(NOLOCK)	ON ci.custid = cs.custid
	INNER JOIN dbo.custInfo c WITH (NOLOCK) ON ci.CustID = c.custid
	INNER JOIN LossLimit_GlobalSetting lg WITH (NOLOCK) ON lg.ExchangeId = c.currency AND lg.ProductId = 22
WHERE ci.roleid = 4 AND cs.SportType = 208 AND cs.BetType = 2101
									
--Master Level
INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
SELECT cs.custid, @SportType, @BetType	
	,CASE	WHEN tmpci.SyncCasino  = 1 THEN cs.MaxWinLimit
			WHEN si.SyncCasino = 1 THEN ss.MaxWinLimit 
			ELSE 0 END AS MaxWinLimit
	,CASE	WHEN tmpci.SyncCasino  = 1 THEN cs.MaxLossLimit
			WHEN si.SyncCasino = 1 THEN ss.MaxLossLimit 
			ELSE lg.DefaultLossLimit END AS MaxLossLimit 
	,CASE	WHEN tmpci.SyncCasino  = 1 THEN cs.IsAutoReset
			WHEN si.SyncCasino = 1 THEN ss.IsAutoReset 
			ELSE 1 END AS IsAutoReset
FROM dbo.CustWinLimit cs WITH(NOLOCK)	
	INNER JOIN #SMATemp tmpci WITH (NOLOCK) ON tmpci.custid = cs.CustId		
	INNER JOIN custInfo si WITH (NOLOCK) ON tmpci.srecommend = si.custid
	INNER JOIN LossLimit_GlobalSetting lg WITH (NOLOCK) ON lg.ExchangeId = si.currency AND lg.ProductId = 22
	INNER JOIN CustWinLimit ss WITH (NOLOCK) ON ss.CustId = si.custid AND ss.BetType = cs.BetType AND ss.SportType = cs.SportType
WHERE tmpci.roleid = 3 AND cs.SportType = 208 AND cs.BetType = 2101

--Agent Level
INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
SELECT cs.custid, @SportType, @BetType	
	,CASE	WHEN tmpci.SyncCasino  = 1 THEN cs.MaxWinLimit
			WHEN mi.SyncCasino = 1 THEN ms.MaxWinLimit 
			WHEN si.SyncCasino = 1 THEN ss.MaxWinLimit 
			ELSE 0 END AS MaxWinLimit
	,CASE	WHEN tmpci.SyncCasino  = 1 THEN cs.MaxLossLimit
			WHEN mi.SyncCasino = 1 THEN ms.MaxLossLimit 
			WHEN si.SyncCasino = 1 THEN ss.MaxLossLimit 
			ELSE lg.DefaultLossLimit END AS MaxLossLimit 
	,CASE	WHEN tmpci.SyncCasino  = 1 THEN cs.IsAutoReset
			WHEN mi.SyncCasino = 1 THEN ms.IsAutoReset 
			WHEN si.SyncCasino = 1 THEN ss.IsAutoReset 
			ELSE 1 END AS IsAutoReset
FROM dbo.CustWinLimit cs WITH(NOLOCK)	
	INNER JOIN #SMATemp tmpci WITH (NOLOCK) ON tmpci.custid = cs.CustId		
	INNER JOIN custInfo mi WITH (NOLOCK) ON tmpci.mrecommend = mi.custid	
	INNER JOIN dbo.CustWinLimit ms WITH (NOLOCK) ON ms.CustId = mi.CustID AND ms.BetType = cs.BetType AND ms.SportType = cs.SportType
	INNER JOIN custInfo si WITH (NOLOCK) ON tmpci.srecommend = si.custid
	INNER JOIN dbo.CustWinLimit ss WITH (NOLOCK) ON ss.CustId = si.CustID AND ss.BetType = cs.BetType AND ss.SportType = cs.SportType
	INNER JOIN LossLimit_GlobalSetting lg WITH (NOLOCK) ON lg.ExchangeId = si.currency AND lg.ProductId = 22
WHERE tmpci.roleid = 2 AND cs.SportType = 208 AND cs.BetType = 2101

--Member Level
INSERT INTO dbo.CustWinLossLimit_Member(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
SELECT cs.custid, @SportType, @BetType	
	,CASE	WHEN tmpci.SyncCasino  = 1 THEN cs.MaxWinLimit
			WHEN ai.SyncCasino = 1 THEN ags.MaxWinLimit 
			WHEN mi.SyncCasino = 1 THEN ms.MaxWinLimit 
			WHEN si.SyncCasino = 1 THEN ss.MaxWinLimit 
			ELSE 0 END AS MaxWinLimit
	,CASE	WHEN tmpci.SyncCasino  = 1 THEN cs.MaxLossLimit
			WHEN ai.SyncCasino = 1 THEN ags.MaxLossLimit 
			WHEN mi.SyncCasino = 1 THEN ms.MaxLossLimit 
			WHEN si.SyncCasino = 1 THEN ss.MaxLossLimit 
			ELSE lg.DefaultLossLimit END  AS MaxLossLimit 
	,CASE	WHEN tmpci.SyncCasino  = 1 THEN cs.IsAutoReset
			WHEN ai.SyncCasino = 1 THEN ags.IsAutoReset 
			WHEN mi.SyncCasino = 1 THEN ms.IsAutoReset 
			WHEN si.SyncCasino = 1 THEN ss.IsAutoReset 
			ELSE 1 END AS IsAutoReset
FROM dbo.CustWinLimit cs WITH(NOLOCK)	
	INNER JOIN #MemberTemp tmpci WITH (NOLOCK) ON tmpci.custid = cs.CustId		
	INNER JOIN custInfo ai WITH (NOLOCK) ON tmpci.recommend = ai.custid	
	INNER JOIN dbo.CustWinLimit ags WITH (NOLOCK) ON ags.CustId = ai.CustID AND ags.BetType = cs.BetType AND ags.SportType = cs.SportType
	INNER JOIN custInfo mi WITH (NOLOCK) ON tmpci.mrecommend = mi.custid	
	INNER JOIN dbo.CustWinLimit ms WITH (NOLOCK) ON ms.CustId = mi.CustID AND ms.BetType = cs.BetType AND ms.SportType = cs.SportType
	INNER JOIN custInfo si WITH (NOLOCK) ON tmpci.srecommend = si.custid
	INNER JOIN dbo.CustWinLimit ss WITH (NOLOCK) ON ss.CustId = si.CustID AND ss.BetType = cs.BetType AND ss.SportType = cs.SportType
	INNER JOIN LossLimit_GlobalSetting lg WITH (NOLOCK) ON lg.ExchangeId = si.currency AND lg.ProductId = 22
WHERE cs.SportType = 208 AND cs.BetType = 2101

		
--------------------------------------StakeLevelGroup Setting-------------------------------------------------	
;WITH cte AS
(
	SELECT ExchangeId,StakeLevelID,
         ROW_NUMBER() OVER (PARTITION BY ExchangeId ORDER BY GameGroupID) AS rn
	FROM dbo.StakeLevel WITH(NOLOCK) 
	WHERE ExchangeId IN
	(
		SELECT currency
		FROM custInfo ci WITH (NOLOCK)
		WHERE CustID IN
		(
			SELECT CustID FROM #MemberTemp
		)
	) AND GameTypeID = @BetType 
)
SELECT ExchangeId,StakeLevelID
INTO #CurrencyStakeLevelMember
FROM cte
WHERE rn = 2

;WITH cte AS
(
	SELECT ExchangeId,StakeLevelID,
         ROW_NUMBER() OVER (PARTITION BY ExchangeId ORDER BY GameGroupID) AS rn
	FROM dbo.StakeLevel WITH(NOLOCK) 
	WHERE ExchangeId IN
	(
		SELECT currency
		FROM custInfo ci WITH (NOLOCK)
		WHERE CustID IN
		(
			SELECT CustID FROM #SMATemp
		)
	) AND GameTypeID = @BetType 
)
SELECT a.ExchangeId, StakeLevelIDs = 
    STUFF((SELECT ',' + CAST(StakeLevelID AS VARCHAR(100))
           FROM cte b 
           WHERE b.ExchangeId = a.ExchangeId AND b.rn IN (1,2,3)
          FOR XML PATH('')), 1, 1, '')
INTO #CurrencyStakeLevelSMA
FROM cte a
WHERE rn IN (1,2,3)


INSERT INTO dbo.CustStakeLevel_Agent(CustID, SportType, BetType, StakeLevelList)	
SELECT ci.CustID, @SportType, @BetType, StakeLevelIDs
FROM #SMATemp tmpci
	INNER JOIN custInfo ci WITH (NOLOCK) ON tmpci.custid = ci.custid
	INNER JOIN #CurrencyStakeLevelSMA st WITH (NOLOCK) ON st.ExchangeId = ci.currency

INSERT INTO dbo.CustStakeLevel_Member(CustID, SportType, BetType, StakeLevelList)	
SELECT ci.CustID, @SportType, @BetType, StakeLevelID
FROM #MemberTemp tmpci
	INNER JOIN custInfo ci WITH (NOLOCK) ON tmpci.custid = ci.custid
	INNER JOIN #CurrencyStakeLevelMember st WITH (NOLOCK) ON st.ExchangeId = ci.currency	

DROP TABLE #SMATemp
DROP TABLE #MemberTemp
