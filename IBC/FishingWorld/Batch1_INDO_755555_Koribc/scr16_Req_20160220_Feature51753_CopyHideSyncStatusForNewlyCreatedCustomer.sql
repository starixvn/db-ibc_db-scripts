/*
	Created: Helen	
	Task: Initialize Hide/SYNC Status of AllBet for Newly created Credit customers
	DB: DBCUST/CustDB
	Date: 20160820
*/ 
DECLARE @max_custid INT, @Mod BIT
	
SELECT @max_custid = xxx

CREATE TABLE #supers (CustID INT)	

INSERT INTO #supers
SELECT custid
FROM  Customer WITH (NOLOCK)
WHERE roleid = 4 AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND site in ('INDO','755555','Koribc')
	AND custid <> 72

DECLARE @bitmapOrder INT
SET @bitmapOrder = (SELECT bitmapOrder FROM ProductStatusProfile (NOLOCK) WHERE Sporttype = 219 AND Bettype = 1011)

/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
--bitmapHasSynced = 1 BY DEFAULT
UPDATE cs
		SET bitmapIsHidden =  dbo.f_GenerateProductStatus(bitmapIsHidden, @bitmapOrder, 0)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON cs.CustID = ci.CustID
WHERE ci.srecommend IN (SELECT CustID FROM #supers)
	AND ci.CustID > @max_custid 

-- For dummy

CREATE TABLE #DirrectMaster (custid INT)
CREATE TABLE #DirrectAgent (custid INT, mrecommend INT)

--Get Dirrect master
INSERT INTO #DirrectMaster(custid)
SELECT ci.custid
FROM customer c WITH(NOLOCK)
	INNER JOIN CustInfo ci WITH(NOLOCK) ON c.custid = ci.custid
WHERE ci.srecommend in (2,4,13,15) AND c.site IN ('INDO','755555','Koribc') AND ci.roleid = 3

--Get Dirrect agent
INSERT INTO #DirrectAgent(custid, mrecommend)
SELECT ci.custid, ci.mrecommend
FROM customer c WITH(NOLOCK)
	INNER JOIN CustInfo ci WITH(NOLOCK) ON c.custid = ci.custid
WHERE ci.srecommend in (2,4,13,15) AND c.site IN ('INDO','755555','Koribc') AND ci.roleid = 2
	AND ci.mrecommend NOT IN (SELECT custid FROM #DirrectMaster)

IF EXISTS (SELECT 1 FROM #DirrectMaster)
BEGIN
	UPDATE cs
		SET bitmapIsHidden =  dbo.f_GenerateProductStatus(bitmapIsHidden, @bitmapOrder, 0) 
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
	WHERE ci.CustID > @max_custid AND (ci.mrecommend IN (SELECT custid FROM #DirrectMaster))
END

IF EXISTS (SELECT 1 FROM #DirrectAgent)
BEGIN
	UPDATE cs
		SET bitmapIsHidden = dbo.f_GenerateProductStatus(bitmapIsHidden, @bitmapOrder, 0)  
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
	WHERE ci.CustID > @max_custid 
		AND (ci.recommend IN (SELECT custid FROM #DirrectAgent) 
			 OR ci.custid IN (SELECT mrecommend FROM #DirrectAgent)
			 )
END	
			
	
		