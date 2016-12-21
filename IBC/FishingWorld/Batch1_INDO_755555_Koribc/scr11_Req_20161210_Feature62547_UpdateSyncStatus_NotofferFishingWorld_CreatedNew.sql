/*
	Created: Helen	
	Task: Initialize Hide/SYNC Status of Fishing World for Newly created Credit customers
	DB: DBCUST/CustDB
	Date: 20161222
*/ 
DECLARE @max_custid INT, @Mod BIT
	
SELECT @max_custid = xxx

CREATE TABLE #supers (CustID INT)	

INSERT INTO #supers
SELECT custid
FROM  Customer WITH (NOLOCK)
WHERE roleid = 4 AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND site NOT in ('INDO','755555','Koribc')
	AND custid <> 72

/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
--bitmapHasSynced = 1 BY DEFAULT
--- Update sync Status
UPDATE cs
		SET bitmapHasSynced = dbo.f_GenerateProductStatus(cs.bitmapHasSynced,8,0)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON cs.CustID = ci.CustID
WHERE ci.srecommend IN (SELECT CustID FROM #supers)
	AND ci.CustID > @max_custid 
