/*
	Created: Winnie 
	Task: Offer for ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
	DB: DBCUST/CustDB
	Date: 20170313
*/ 
DECLARE @Sporttype INT
SELECT @Sporttype = 219
	
DELETE FROM ProductStatusSiteCurrency WHERE SportType=@Sporttype AND SiteID IN(16,20,184,3,188,1,13)
