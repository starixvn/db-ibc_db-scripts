/*
	Created: Winnie 
	Task: Offer for ('755555','Indo', 'KORIBC')
	DB: DBCUST/CustDB
	Date: 20170217
*/ 
DECLARE @Sporttype INT
SELECT @Sporttype = 219
	
DELETE FROM ProductStatusSiteCurrency WHERE SportType=@Sporttype AND SiteID IN(22,11,35)
AND Currency<>72

