
/*
	Created: Winnie 
	Task: Insert CanSee for FW
	DB: DBCUST/CustDB
	Date: 20170118
*/ 

INSERT INTO ProductLaunchedSiteCurrency (SportType, Currency, SiteID, IsLaunched, IsTest)
SELECT 219 AS SportType, 20 AS Currency, 0 AS SiteID, 1 AS IsLaunched, 0 AS IsTest
UNION
SELECT 219 AS SportType, 0 AS Currency, siteid AS SiteID, 1 AS IsLaunched, 0 AS IsTest
FROM Site (NOLOCK)
WHERE siteID IN (23,24,25,26,21)
