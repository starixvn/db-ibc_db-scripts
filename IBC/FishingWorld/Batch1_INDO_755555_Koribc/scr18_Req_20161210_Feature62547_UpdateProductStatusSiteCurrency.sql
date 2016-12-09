/*
	Created: Helen 
	Task: Offer for 
	DB: DBCUST/CustDB
	Date: 20160317
*/ 

/*-- INDO: 11; 755555:22;  Koribc: 35
*/
--INDO/ 755555/ Koribc
CREATE TABLE #SiteCurrency (siteid INT, exchangeID INT)
INSERT INTO #SiteCurrency (siteid,exchangeID)
-- 755555
SELECT 22, exchangeid 
FROM exchange WHERE code in ('KRW','IDR','THB')
UNION ALL
-- INDO
SELECT 11, exchangeid 
FROM exchange WHERE code in ('KRW','IDR','THB')
UNION ALL
--KORIBC
SELECT 35, exchangeid 
FROM exchange WHERE code in ('KRW','IDR','THB')

DELETE FROM ProductStatusSiteCurrency 
WHERE SportType = 219

INSERT INTO ProductStatusSiteCurrency (SportType,BetType,SiteID, Currency, IsHidden,IsDisabled)
SELECT 219,1011,siteid,0,1,1
FROM Site (NOLOCK)
WHERE siteID NOT IN (22,11,35)-- INDO: 11; 755555:22;  Koribc: 35
	AND isLicensee = 0

UNION ALL

SELECT 219,1011,siteid, e.exchangeid,1,1
FROM Site S (NOLOCK)
	CROSS JOIN exchange e (nolock) 
WHERE S.siteID IN (22,11,35)
	AND isLicensee = 0
	and e.exchangeid NOT IN (SELECT currency FROM #SiteCurrency T WHERE S.SiteID =  T.SiteID)

DROP TABLE #SiteCurrency
