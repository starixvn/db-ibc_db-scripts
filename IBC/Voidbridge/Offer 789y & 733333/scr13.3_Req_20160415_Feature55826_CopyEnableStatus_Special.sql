/*
	Created: Elodie	
	Task: Initialize Product Status of Voidbridge for special customers
	DB: DBCUST/CustDB
	Date: 20160420
*/ 
	
CREATE TABLE #supers (custid INT, SyncCasino BIT, DisableCasino BIT)
	
INSERT INTO #supers(custid, SyncCasino, DisableCasino)
SELECT ci.custid, SyncCasino, DisableCasino
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Customer c WITH (NOLOCK) ON c.custid = ci.custid
WHERE c.site IN ('611111')
	AND ci.username IN ('S56HK'						,'S56T'						,'S56KK'						,'S56AC'						,'S56AD'						,'S56A'						,'HK06'						,'S56AE'						,'HK09')

/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
UPDATE cs
SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN #supers ci WITH(NOLOCK) ON cs.CustID = ci.CustID

UPDATE cs
SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
WHERE ci.username IN ('S688T', 'LLR')
	 
