/*
	Created: Elodie	
	Task: Update Synced Status of NG2 = 0 for all customer (NOT (ci.site IN ('789y')  AND (ci.currency = 20 OR ci.custid = 2454112))--STESTUS$)
	DB: DBCUST/CustDB
	Date: 20161010
*/ 

--Run on UM (9/11/2016)
DECLARE @MaxCustID INT
SELECT @MaxCustID = xxx

CREATE TABLE #supers (custid INT)

INSERT INTO #supers(custid)
SELECT ci.custid
FROM customer ci WITH(NOLOCK)
	INNER JOIN site s WITH (NOLOCK) ON ci.site = s.site
	LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE (ci.roleid = 4  
			AND ci.username NOT LIKE '3rdSuper%'
			AND cs.isinternal = 0
			AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
			AND s.islicensee = 0)
		AND NOT (ci.site IN ('789y')  AND (ci.currency = 20 OR ci.custid = 2454112))--STESTUS$

DECLARE @BitmapOrder TINYINT = 4

UPDATE cs
SET
		bitmapHasSynced = dbo.f_GenerateProductStatus(bitmapHasSynced, @BitmapOrder, 0)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID	
WHERE ci.srecommend IN (SELECT custid FROM #supers) AND ci.custid > @MaxCustID 
