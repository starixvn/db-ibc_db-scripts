/*
	Created: Elodie	
	Task: Initialize Product Status of Voidbridge for special customers
	DB: DBCUST/CustDB
	Date: 20160420
*/ 
	
CREATE TABLE #supers (custid INT, SyncCasino BIT)
	
INSERT INTO #supers(custid, SyncCasino)
SELECT ci.custid, SyncCasino
FROM CustInfo ci WITH(NOLOCK)
 INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
WHERE ci.currency IN (20, 4, 15, 22, 33, 34, 43, 44, 45, 47, 62) --'KRW', 'IDR', 'THB'
	AND c.site IN ('755555', 'INDO', 'KORIBC')
	AND c.username IN ('S42RM','S42H','S42AH','S42S','S42BH','S42CH','S42DH','M42M','S42ARM','S42M','S42D','YH','YHA','TWS','S88ML','S42U','S42EH','S42T','S42K','HPO')

/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
UPDATE cs
SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN #supers ci WITH(NOLOCK) ON cs.CustID = ci.CustID
	 
