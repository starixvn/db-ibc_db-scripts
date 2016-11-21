CREATE TABLE #Cust (custid INT PRIMARY KEY, srecommend INT, mrecommend INT, recommend INT, roleid TINYINT) 

DECLARE @max_custid INT

SELECT @max_custid = xxx

INSERT INTO #Cust(custid, srecommend, mrecommend, recommend, roleid)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.recommend, ci.roleid
FROM customer ci WITH(NOLOCK)
	INNER JOIN dbo.custAccount ca WITH (NOLOCK) ON ca.custid = ci.custid
WHERE ca.groupID = 515

DECLARE @BitmapOrder TINYINT = 4

/*******************************CUST PRODUCT STATUS TABLE*******************************/	
UPDATE cs
SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 1)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
	INNER JOIN #Cust sma WITH(NOLOCK) ON ci.srecommend = sma.CustID
WHERE sma.roleid = 4 AND ci.custid > @max_custid

UPDATE cs
SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 1)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
	INNER JOIN #Cust sma WITH(NOLOCK) ON ci.mrecommend = sma.CustID
WHERE sma.roleid = 3 AND ci.custid > @max_custid

UPDATE cs
SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 1)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
	INNER JOIN #Cust sma WITH(NOLOCK) ON ci.recommend = sma.CustID
WHERE sma.roleid = 2 AND ci.custid > @max_custid