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
WHERE ci.username IN ('S56ARM','S56BRM','S56CRM','S56H','S56AH','S56CH','S56DH','S56HH','S56QH','S56SD','S56ASD')

/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
UPDATE cs
SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN #supers ci WITH(NOLOCK) ON cs.CustID = ci.CustID

UPDATE cs
SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
WHERE ci.username IN ('S2H')
	 
