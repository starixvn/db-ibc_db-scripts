

/*
	Created: Helen
	Date: 20160715
	Task: Delete redundant Outright settings 
	DB: DBCust/CustDB
*/
DECLARE @maxcustID INT = xxx

CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT ci.custid
FROM customer ci WITH (NOLOCK) 
	INNER JOIN site s WITH (NOLOCK) ON ci.site = s.site
	INNER JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
	AND ci.username NOT LIKE '3rdSuper%'
	AND cs.isinternal = 1
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND s.islicensee = 0

DELETE cs
FROM [dbo].CustSetting cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype IN (2,3,5,8,10,11,99)
	AND cs.Bettype = 10
	AND c.srecommend IN (SELECT custid FROM #supers)
	
DELETE cs
FROM [dbo].custoverride cs WITH(UPDLOCK,ROWLOCK)
WHERE cs.CustID > @maxcustID
	AND cs.Sporttype IN (2,3,5,8,10,11,99)
	AND cs.Bettype = 10
	AND c.srecommend IN (SELECT custid FROM #supers)