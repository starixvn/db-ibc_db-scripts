/*
	Created: Elodie
	Task: Adjust WinLossLimit 
	DB: DBCUST/CustDB
	Date: 20160420
*/ 

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
 AND ci.currency IN (20, 4, 15, 22, 33, 34, 43, 44, 45, 47, 62) --'KRW', 'IDR', 'THB'

DECLARE @SportType SMALLINT, @BetType SMALLINT, @exchangeID INT, @DefaultLossLimit MONEY
SELECT @SportType = 212, @BetType = 4001

CREATE TABLE #MemberTemp
(
	CustID INT PRIMARY KEY CLUSTERED,
	SyncCasino BIT
)

CREATE TABLE #SMATemp
(
	CustID INT PRIMARY KEY CLUSTERED,
	roleid TINYINT,
	SyncCasino BIT
)

INSERT INTO #MemberTemp (CustID, SyncCasino)
SELECT CustID, SyncCasino
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid = 1  AND Enabled = 1
	
	
INSERT INTO #SMATemp (CustID, roleid, SyncCasino)
SELECT CustID, roleid, SyncCasino
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid IN (2,3,4) AND Enabled = 1
		
--------------------------------------WinLossLimit-------------------------------------------------
--SuperLevel
UPDATE csVB		
SET csVB.MaxWinLimit = cs.MaxWinLimit,
	csVB.IsAutoReset = cs.IsAutoReset,
	csVB.MaxLossLimit = cs.MaxLossLimit
FROM CustWinLossLimit_Agent csVB WITH (NOLOCK)
	INNER JOIN CustWinLimit cs WITH(NOLOCK) ON csVB.custid = cs.custid
	INNER JOIN #SMATemp ci WITH (NOLOCK) ON ci.custid = csVB.CustId 
WHERE ci.roleid = 4 AND ci.SyncCasino = 1 
	AND cs.SportType = 208 AND cs.BetType = 2101 AND csVB.SportType = @SportType AND csVB.BetType = @BetType
	AND (csVB.MaxWinLimit <> cs.MaxWinLimit OR csVB.IsAutoReset <> cs.IsAutoReset OR csVB.MaxLossLimit <> cs.MaxLossLimit)

--Master Level
UPDATE csVB		
SET csVB.MaxWinLimit = CASE	WHEN ci.SyncCasino  = 1 THEN cs.MaxWinLimit 
							WHEN si.SyncCasino = 1 THEN ss.MaxWinLimit  END,
	csVB.IsAutoReset = CASE	WHEN ci.SyncCasino  = 1 THEN cs.isAutoReset
							WHEN si.SyncCasino = 1 THEN ss.isAutoReset END,
	csVB.MaxLossLimit = CASE	WHEN ci.SyncCasino  = 1 THEN cs.MaxLossLimit
							WHEN si.SyncCasino = 1 THEN ss.MaxLossLimit END
FROM CustWinLossLimit_Agent csVB WITH (NOLOCK)
	INNER JOIN dbo.CustWinLimit cs WITH(NOLOCK)	ON csVB.CustId = cs.CustId
	INNER JOIN CustInfo ci WITH (NOLOCK) ON ci.custid = cs.CustId		
	INNER JOIN #SMATemp si WITH (NOLOCK) ON ci.srecommend = si.custid
	INNER JOIN CustWinLimit ss WITH (NOLOCK) ON ss.CustId = ci.srecommend AND ss.BetType = cs.BetType AND ss.SportType = cs.SportType
WHERE ci.roleid = 3
	AND cs.SportType = 208 AND cs.BetType = 2101 AND csVB.SportType = @SportType AND csVB.BetType = @BetType
	AND (csVB.MaxWinLimit <> CASE	WHEN ci.SyncCasino = 1 THEN cs.MaxWinLimit 
									WHEN si.SyncCasino = 1 THEN ss.MaxWinLimit  END 
		OR csVB.IsAutoReset <> CASE	WHEN ci.SyncCasino = 1 THEN cs.isAutoReset
									WHEN si.SyncCasino = 1 THEN ss.isAutoReset END
		OR csVB.MaxLossLimit <> CASE WHEN ci.SyncCasino = 1 THEN cs.MaxLossLimit
									 WHEN si.SyncCasino = 1 THEN ss.MaxLossLimit END)

--Agent Level
UPDATE csVB		
SET csVB.MaxWinLimit = CASE	WHEN ci.SyncCasino = 1 THEN cs.MaxWinLimit
							WHEN mi.SyncCasino = 1 THEN ms.MaxWinLimit 
							WHEN si.SyncCasino = 1 THEN ss.MaxWinLimit END,
	csVB.IsAutoReset = CASE	WHEN ci.SyncCasino = 1 THEN cs.isAutoReset
							WHEN mi.SyncCasino = 1 THEN ms.isAutoReset 
							WHEN si.SyncCasino = 1 THEN ss.isAutoReset END,
	csVB.MaxLossLimit = CASE	WHEN ci.SyncCasino = 1 THEN cs.MaxLossLimit
								WHEN mi.SyncCasino = 1 THEN ms.MaxLossLimit 
								WHEN si.SyncCasino = 1 THEN ss.MaxLossLimit END
FROM CustWinLossLimit_Agent csVB WITH (NOLOCK)
	INNER JOIN dbo.CustWinLimit cs WITH(NOLOCK)	ON cs.CustId = csVB.CustId
	INNER JOIN dbo.custInfo ci WITH(NOLOCK)ON ci.custid = cs.CustId
	INNER JOIN #SMATemp mi WITH (NOLOCK) ON ci.mrecommend = mi.custid	
	INNER JOIN dbo.CustWinLimit ms WITH (NOLOCK) ON ms.CustId = mi.CustID AND ms.BetType = cs.BetType AND ms.SportType = cs.SportType
	INNER JOIN #SMATemp si WITH (NOLOCK) ON ci.srecommend = si.custid
	INNER JOIN dbo.CustWinLimit ss WITH (NOLOCK) ON ss.CustId = si.CustID AND ss.BetType = cs.BetType AND ss.SportType = cs.SportType
WHERE ci.roleid = 2
	AND cs.SportType = 208 AND cs.BetType = 2101 AND csVB.SportType = @SportType AND csVB.BetType = @BetType
	AND (csVB.MaxWinLimit <> CASE	WHEN ci.SyncCasino = 1 THEN cs.MaxWinLimit
									WHEN mi.SyncCasino = 1 THEN ms.MaxWinLimit 
									WHEN si.SyncCasino = 1 THEN ss.MaxWinLimit END
		OR csVB.IsAutoReset <> CASE	WHEN ci.SyncCasino = 1 THEN cs.isAutoReset
									WHEN mi.SyncCasino = 1 THEN ms.isAutoReset 
									WHEN si.SyncCasino = 1 THEN ss.isAutoReset END
		OR csVB.MaxLossLimit <> CASE	WHEN ci.SyncCasino = 1 THEN cs.MaxLossLimit
									WHEN mi.SyncCasino = 1 THEN ms.MaxLossLimit 
									WHEN si.SyncCasino = 1 THEN ss.MaxLossLimit END)

--Member Level
UPDATE csVB		
SET csVB.MaxWinLimit = CASE	WHEN ci.SyncCasino  = 1 THEN cs.MaxWinLimit
							WHEN ai.SyncCasino = 1 THEN ags.MaxWinLimit 
							WHEN mi.SyncCasino = 1 THEN ms.MaxWinLimit 
							WHEN si.SyncCasino = 1 THEN ss.MaxWinLimit END,
	csVB.IsAutoReset = CASE	WHEN ci.SyncCasino  = 1 THEN cs.isAutoReset
							WHEN ai.SyncCasino = 1 THEN ags.isAutoReset 
							WHEN mi.SyncCasino = 1 THEN ms.isAutoReset 
							WHEN si.SyncCasino = 1 THEN ss.isAutoReset END,
	csVB.MaxLossLimit = CASE WHEN ci.SyncCasino  = 1 THEN cs.MaxLossLimit
							 WHEN ai.SyncCasino = 1 THEN ags.MaxLossLimit 
							 WHEN mi.SyncCasino = 1 THEN ms.MaxLossLimit 
							 WHEN si.SyncCasino = 1 THEN ss.MaxLossLimit END
FROM dbo.CustWinLossLimit_Member csVB WITH (NOLOCK)
	INNER JOIN dbo.CustWinLimit cs WITH(NOLOCK)	ON cs.CustId = csVB.CustId
	INNER JOIN dbo.custInfo ci WITH(NOLOCK)ON ci.custid = cs.CustId
	INNER JOIN #SMATemp ai WITH (NOLOCK) ON ci.recommend = ai.custid	
	INNER JOIN dbo.CustWinLimit ags WITH (NOLOCK) ON ags.CustId = ai.CustID AND ags.BetType = cs.BetType AND ags.SportType = cs.SportType
	INNER JOIN #SMATemp mi WITH (NOLOCK) ON ci.mrecommend = mi.custid	
	INNER JOIN dbo.CustWinLimit ms WITH (NOLOCK) ON ms.CustId = mi.CustID AND ms.BetType = cs.BetType AND ms.SportType = cs.SportType
	INNER JOIN #SMATemp si WITH (NOLOCK) ON ci.srecommend = si.custid
	INNER JOIN dbo.CustWinLimit ss WITH (NOLOCK) ON ss.CustId = si.CustID AND ss.BetType = cs.BetType AND ss.SportType = cs.SportType
WHERE ci.roleid = 1
	AND cs.SportType = 208 AND cs.BetType = 2101 AND csVB.SportType = @SportType AND csVB.BetType = @BetType
	AND (csVB.MaxWinLimit = CASE	WHEN ci.SyncCasino  = 1 THEN cs.MaxWinLimit
							WHEN ai.SyncCasino = 1 THEN ags.MaxWinLimit 
							WHEN mi.SyncCasino = 1 THEN ms.MaxWinLimit 
							WHEN si.SyncCasino = 1 THEN ss.MaxWinLimit END
		OR csVB.IsAutoReset = CASE	WHEN ci.SyncCasino  = 1 THEN cs.isAutoReset
									WHEN ai.SyncCasino = 1 THEN ags.isAutoReset 
									WHEN mi.SyncCasino = 1 THEN ms.isAutoReset 
									WHEN si.SyncCasino = 1 THEN ss.isAutoReset END
		OR csVB.MaxLossLimit = CASE WHEN ci.SyncCasino  = 1 THEN cs.MaxLossLimit
									WHEN ai.SyncCasino = 1 THEN ags.MaxLossLimit 
									WHEN mi.SyncCasino = 1 THEN ms.MaxLossLimit 
									WHEN si.SyncCasino = 1 THEN ss.MaxLossLimit END)	

DROP TABLE #SMATemp
DROP TABLE #MemberTemp
