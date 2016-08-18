/*
	Created: Helen 
	Task: Offer for 
	DB: DBCUST/CustDB
	Date: 20160317
*/ 

DELETE FROM ProductStatusSiteCurrency 
WHERE SportType = 211
	-- UAT 
	--AND currency = 20
	-- Production
	AND siteID in (22,11,35)-- INDO: 11; 755555:22;  Koribc: 35
	