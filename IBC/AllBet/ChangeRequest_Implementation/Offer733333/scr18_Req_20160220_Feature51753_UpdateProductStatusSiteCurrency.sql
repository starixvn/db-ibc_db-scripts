/*
	Created: Helen 
	Task: Offer for 
	DB: DBCUST/CustDB
	Date: 20160317
	
	,11,22,31 --Site:INDO,755555,35
*/ 

/* -- 23: 222223; 21	733333
*/

DELETE FROM ProductStatusSiteCurrency
WHERE  SportType = 211 AND BetType IN (2401,2402) 
	AND SiteID IN (21,23) -- Site 222223; 733333
	--AND Currency = 0 -- (0,1,2,5,13,67)  -- SD$,RM,HK$,RMB,HKK

GO

INSERT INTO ProductStatusSiteCurrency (SportType,BetType,Currency,SiteID,IsHidden,IsDisabled)
SELECT 211,2401,e.exchangeid,site,1,1
FROM Site S WITH (NOLOCK)
	CROSS JOIN exchange e WITH (NOLOCK) 
WHERE e.exchangeid NOT IN (1,2,5,13,67) AND siteid IN (21,23)	

UNION ALL

SELECT 211,2402,e.exchangeid,site,1,1
FROM Site S WITH (NOLOCK)
	CROSS JOIN exchange e WITH (NOLOCK) 
WHERE e.exchangeid NOT IN (1,2,5,13,67) AND siteid IN (21,23)	

