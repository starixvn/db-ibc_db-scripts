/*
	Created: Helen 
	Task: Offer for 
	DB: DBCUST/CustDB
	Date: 20160317
*/ 

/*-- INDO: 11; 755555:22;  Koribc: 35
*/
-- TW - control member for place bet

CREATE TABLE #exchange (exchangeid INT)

--DELETE ProductLaunchedSiteCurrency WHERE sporttype = 211 --and siteid in (1,22,11,35)
go

CREATE TABLE #ProductLaunchedSiteCurrency (SiteID INT, Currency INT,SportType INT,IsLaunched BIT,IsTest BIT)
/*
INSERT INTO ProductLaunchedSiteCurrency (SiteID, Currency,SportType,IsLaunched,IsTest)
VALUES 
	-- INDO: 11
	(11,47,211,1,1)
	,(11,33,211,1,1)
	,(11,34,211,1,1)
	,(11,15,211,1,1)
	,(11,22,211,1,1)
	-- 755555:22
	,(22,43,211,1,1)
	--Koribc: 35
	, (35,45,211,1,1)
	-- Currenyc YNG for  INDO, KORIBC,755555
	--, (1,72,211,1,1)
	, (11,72,211,1,1)
	, (22,72,211,1,1)
	, (35,72,211,1,1)
GO	
*/

INSERT INTO #ProductLaunchedSiteCurrency (SiteID, Currency,SportType,IsLaunched,IsTest)
VALUES 
	-- INDO: 11
	(11,47,211,1,1)
	,(11,33,211,1,1)
	,(11,34,211,1,1)
	,(11,15,211,1,1)
	,(11,22,211,1,1)
	-- 755555:22
	,(22,43,211,1,1)
	--Koribc: 35
	, (35,45,211,1,1)
	-- Currenyc YNG for  INDO, KORIBC,755555
	--, (1,72,211,1,1)
	, (11,72,211,1,1)
	, (22,72,211,1,1)
	, (35,72,211,1,1)


INSERT INTO #exchange 
SELECT DISTINCT Currency
FROM #ProductLaunchedSiteCurrency
WHERE siteID in (22,11,35) and sporttype = 211

DELETE FROM ProductStatusSiteCurrency 
WHERE SportType = 211

INSERT INTO ProductStatusSiteCurrency (SportType,BetType,SiteID, Currency, IsHidden,IsDisabled)
SELECT 211,2401,siteid, 0,1,1
FROM Site (NOLOCK)
WHERE siteID NOT IN (22,11,35)-- INDO: 11; 755555:22;  Koribc: 35
	AND isLicensee = 0

UNION ALL

SELECT 211,2402,siteid, 0,1,1
FROM Site (NOLOCK)
WHERE siteID NOT IN (22,11,35)-- INDO: 11; 755555:22;  Koribc: 35
	AND isLicensee = 0

UNION ALL

SELECT 211,2401,siteid, e.exchangeid,1,1
FROM Site (NOLOCK)
	cross join exchange e (nolock) 
WHERE siteID IN (22,11,35)-- INDO: 11; 755555:22;  Koribc: 35
	AND isLicensee = 0
	and e.exchangeid NOT IN (select exchangeid from #exchange)

UNION ALL

SELECT 211,2402,siteid, e.exchangeid,1,1
FROM Site (NOLOCK)
	cross join exchange e (nolock) 
WHERE siteID IN (22,11,35)-- INDO: 11; 755555:22;  Koribc: 35
	AND isLicensee = 0
	and e.exchangeid not in (select exchangeid from #exchange)

UNION ALL

SELECT 211,2401,siteid,72,0,0
FROM Site (NOLOCK)
WHERE siteID IN (22,11,35)-- INDO: 11; 755555:22;  Koribc: 35
	AND isLicensee = 0

UNION ALL

SELECT 211,2402,siteid,72,1,1
FROM Site (NOLOCK)
WHERE siteID IN (22,11,35)-- INDO: 11; 755555:22;  Koribc: 35
	AND isLicensee = 0
	

