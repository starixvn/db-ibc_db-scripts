/*
	Created: Elodie	
	Task: Initialize Product Status of Voidbridge for Newly created Credit customers
	DB: DBCUST/CustDB
	Date: 20160420
*/ 
	
CREATE TABLE #supers (custid int)
	
INSERT INTO #supers(custid)
SELECT ci.custid
FROM CustInfo ci WITH(NOLOCK)
 INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
 INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
 LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
 AND ci.username NOT LIKE '3rdSuper%'
 AND cs.isinternal = 0
 AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
 AND s.islicensee = 0
 AND ci.currency IN (20)

/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
UPDATE cs
SET
		bitmapHasSynced = CASE WHEN ci.SyncCasino = 1 THEN (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapHasSynced, '<root><r b="5" s="1"/></root>')) 
						ELSE (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapHasSynced, '<root><r b="5" s="0"/></root>')) END,
		bitmapIsHidden = CASE WHEN ci.SyncCasino = 1 THEN (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, '<root><r b="5" s="0"/></root>')) 
						ELSE (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, '<root><r b="5" s="1"/></root>')) END,
		bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsDisabled, '<root><r b="5" s="0"/></root>')) 
						ELSE (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsDisabled, '<root><r b="5" s="1"/></root>')) END
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
WHERE ci.srecommend IN (SELECT CustID FROM #supers)
	AND (
			(ci.SyncCasino = 1 AND CASE substring(cs.bitmapHasSynced, 1+((5-1)/8), 1) & POWER(2, (5-1)%8) WHEN 0 THEN 0 ELSE 1 END = 0)
			OR (ci.SyncCasino = 0 AND CASE substring(cs.bitmapHasSynced, 1+((5-1)/8), 1) & POWER(2, (5-1)%8) WHEN 0 THEN 0 ELSE 1 END = 1)
			OR (ci.SyncCasino = 1 AND CASE substring(cs.bitmapIsHidden, 1+((5-1)/8), 1) & POWER(2, (5-1)%8) WHEN 0 THEN 0 ELSE 1 END = 1)
			OR (ci.SyncCasino = 0 AND CASE substring(cs.bitmapIsHidden, 1+((5-1)/8), 1) & POWER(2, (5-1)%8) WHEN 0 THEN 0 ELSE 1 END = 0)
			OR (ci.SyncCasino = 1 AND ci.DisableCasino = 0 AND CASE substring(cs.bitmapIsDisabled, 1+((5-1)/8), 1) & POWER(2, (5-1)%8) WHEN 0 THEN 0 ELSE 1 END = 1)
			OR (NOT (ci.SyncCasino = 1 AND ci.DisableCasino = 0) AND CASE substring(cs.bitmapIsDisabled, 1+((5-1)/8), 1) & POWER(2, (5-1)%8) WHEN 0 THEN 0 ELSE 1 END = 0)
		)
	 
