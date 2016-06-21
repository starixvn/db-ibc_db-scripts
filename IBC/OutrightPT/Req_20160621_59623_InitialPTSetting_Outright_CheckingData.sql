CREATE TABLE #SportTypeBetType (SportType SMALLINT, Bettype SMALLINT)
INSERT INTO #SportTypeBetType
VALUES(2,10)
	,(3,10)
	,(5,10)
	,(8,10)
	,(10,10)
	,(11,10)
	,(99,10)

select COUNT(1)
FROM CustSetting T	
	INNER JOIN Customer C (NOLOCK) ON T.custid = C.custid --AND C.currency = 2
	INNER JOIN #SportTypeBetType T1 ON T.sporttype = T1.SportType AND T.bettype = T1.Bettype


select COUNT(1)
FROM Dep_CustSetting T	
	INNER JOIN Customer C (NOLOCK) ON T.custid = C.custid --AND C.currency = 2
	INNER JOIN #SportTypeBetType T1 ON T.sporttype = T1.SportType AND T.bettype = T1.Bettype 
	

select count(ci.custid) 
from Custinfo ci (nolock) 
	inner join custSetting cs (nolock) on cs.custid = ci.custid
where ci.enabled = 1 and sporttype = 1 and bettype = 10


