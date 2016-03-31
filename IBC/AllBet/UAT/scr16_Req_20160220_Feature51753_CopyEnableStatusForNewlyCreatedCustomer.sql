/*
	Created: Elodie	
	Task: Initialize Product Status of AllBet for Newly created Credit customers
	DB: DBCUST/CustDB
	Date: 20160301
*/ 
DECLARE @max_custid INT
	
SELECT @max_custid = xxx
	
CREATE TABLE #supers (custid int)
	
INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.currency IN (20) --UUS

DECLARE @BitmapOrder TINYINT

SELECT @BitmapOrder = PSP.bitmapOrder
FROM dbo.ProductSettingDetail psd WITH(NOLOCK)  
	INNER JOIN dbo.ProductStatusProfile psp WITH (NOLOCK) ON psp.Sporttype = psd.SportType AND psp.Bettype = psd.BetType
WHERE psd.SettingType = 4 AND psd.ProductID = 21

/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
UPDATE cs
SET
		bitmapHasSynced = CASE WHEN ci.SyncLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapHasSynced, @BitmapOrder, 1) ELSE bitmapHasSynced END,
		bitmapIsHidden = CASE WHEN ci.SyncLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsHidden, @BitmapOrder, 0) ELSE bitmapIsHidden END,
		bitmapIsDisabled = CASE WHEN ci.DisableLiveCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 0) ELSE bitmapIsDisabled END
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
WHERE ci.srecommend IN (SELECT CustID FROM #supers)
	AND ci.CustID > @max_custid 
