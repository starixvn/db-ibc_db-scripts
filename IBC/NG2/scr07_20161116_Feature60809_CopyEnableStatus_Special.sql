/*
	Created: Elodie	
	Task: Initialize Product Status of Voidbridge for special customers
	DB: DBCUST/CustDB
	Date: 20160420
*/ 
DECLARE @max_custid INT

SELECT @max_custid = xxx
	
CREATE TABLE #supers (custid INT)
	
INSERT INTO #supers(custid)
SELECT c.custid
FROM Customer c WITH (NOLOCK)
WHERE c.site IN ('789y')
	AND c.custid <= @max_custid
	AND c.username IN ('S56HK'						,'S56T'						,'S56KK'						,'S56AC'						,'S56AD'						,'S56A'						,'HK06'						,'S56AE'						,'HK09')

DECLARE @BitmapOrder TINYINT = 4

/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
UPDATE cs
SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 0)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN #supers ci WITH(NOLOCK) ON cs.CustID = ci.CustID
WHERE cs.CustID <= @max_custid

UPDATE cs
SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 0)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
WHERE ci.username IN ('S688T', 'LLR')
	AND cs.CustID <= @max_custid
	 
