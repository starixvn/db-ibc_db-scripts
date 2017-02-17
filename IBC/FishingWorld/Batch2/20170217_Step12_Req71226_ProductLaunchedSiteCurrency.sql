
/*
	Created: Winnie 
	Task: Insert CanSee for FW
	DB: DBCUST/CustDB
	Date: 20170217
*/ 
DECLARE @Sporttype INT
SELECT @Sporttype = 219

INSERT INTO ProductLaunchedSiteCurrency (SportType, Currency, SiteID, IsLaunched, IsTest)
SELECT @Sporttype AS SportType, 0 AS Currency, siteid AS SiteID, 1 AS IsLaunched, 0 AS IsTest
FROM Site (NOLOCK)
WHERE siteID IN(22,11,35)
