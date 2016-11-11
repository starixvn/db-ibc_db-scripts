/*
	Created: Elodie	
	Task: Initialize Product Status of Voidbridge for special customers
	DB: DBCUST/CustDB
	Date: 20160420
*/ 
	
CREATE TABLE #supers (custid INT)
	
INSERT INTO #supers(custid)
SELECT c.custid
FROM Customer c WITH (NOLOCK)
WHERE c.site IN ('789y')
	AND c.username IN ('S56HK'						,'S56T'						,'S56KK'						,'S56AC'						,'S56AD'						,'S56A'						,'HK06'						,'S56AE'						,'HK09')

DECLARE @BitmapOrder TINYINT

SELECT @BitmapOrder = PSP.bitmapOrder
FROM dbo.ProductSettingDetail psd WITH(NOLOCK)  
	INNER JOIN dbo.ProductStatusProfile psp WITH (NOLOCK) ON psp.Sporttype = psd.SportType AND psp.Bettype = psd.BetType
WHERE psd.SettingType = 11 AND psd.ProductID = 23

/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
UPDATE cs
SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 0)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN #supers ci WITH(NOLOCK) ON cs.CustID = ci.CustID

UPDATE cs
SET bitmapIsDisabled = dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 0)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN CustInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
WHERE ci.username IN ('S688T', 'LLR')
	 
