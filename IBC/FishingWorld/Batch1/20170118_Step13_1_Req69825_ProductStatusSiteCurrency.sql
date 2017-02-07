/*
	Created: Winnie 
	Task: Offer for 
	DB: DBCUST/CustDB
	Date: 20170118
*/ 
DECLARE @Sporttype INT, @Bettype INT
SELECT @Sporttype = 219, @Bettype = 1011
	
DELETE FROM ProductStatusSiteCurrency WHERE SportType=@Sporttype

INSERT INTO ProductStatusSiteCurrency (SportType,BetType,SiteID, Currency, IsHidden,IsDisabled)
SELECT @Sporttype,@Bettype,siteid,e.exchangeid,1,1
FROM Site (NOLOCK)
CROSS JOIN exchange e (nolock) 
WHERE siteID NOT IN (23,24,25,26,21)
AND isLicensee = 0 AND e.exchangeid<>20
