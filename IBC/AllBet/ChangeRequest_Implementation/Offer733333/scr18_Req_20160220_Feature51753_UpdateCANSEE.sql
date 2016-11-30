
/*
	Created: Helen 
	Task: Offer for 
	DB: DBCUST/CustDB
	Date: 20161130
	
 -- 23: 222223; 21	733333
*/ 

INSERT INTO ProductLaunchedSiteCurrency (SiteID,Currency,SportType,IsLaunched,IsTest)
SELECT S.siteid,E.exchangeid,211,1,0
FROM Site S WITH (NOLOCK)
	CROSS JOIN exchange e WITH (NOLOCK) 
WHERE e.exchangeid IN (1,2,5,13,67) -- ('HK$','HKK','RM','RMB','SD$')
	AND S.siteid IN (21,23)	

		