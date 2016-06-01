/*
	Created: Elodie	
	Task: Initialize Product Status of Voidbridge for special customers
	DB: DBCUST/CustDB
	Date: 20160420
*/ 
	
CREATE TABLE #supers (custid INT, SyncCasino BIT, DisableCasino BIT)
	
INSERT INTO #supers(custid, SyncCasino, DisableCasino)
SELECT ci.custid, SyncCasino, DisableCasino
FROM customer ci WITH(NOLOCK)
WHERE ci.site IN ('611111')
	AND ci.username IN ('S56HK'						,'S56T'						,'S56KK'						,'S56AC'						,'S56AD'						,'S56A'						,'HK06'						,'S56AE'						,'HK09'						,'S688T'						,'LLR')

/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
UPDATE cs
SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN #supers ci WITH(NOLOCK) ON cs.CustID = ci.CustID
	 
