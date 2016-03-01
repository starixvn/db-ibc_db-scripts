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

CREATE TABLE #CustomerTemp
(
	CustID INT PRIMARY KEY CLUSTERED
)
	
	
INSERT #CustomerTemp(CustID)
SELECT CustID
FROM dbo.customer WITH(NOLOCK)
WHERE srecommend IN (SELECT CustID FROM #supers)
	AND CustID > @max_custid

DECLARE @BitmapOrder TINYINT

SELECT @BitmapOrder = PSP.bitmapOrder
FROM dbo.ProductSettingDetail psd WITH(NOLOCK)  
	INNER JOIN dbo.ProductStatusProfile psp WITH (NOLOCK) ON psp.Sporttype = psd.SportType AND psp.Bettype = psd.BetType
WHERE psd.SettingType = 4 AND psd.ProductID = 21

/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
UPDATE cs
SET
		bitmapHasSynced = CASE WHEN ci.SyncLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapHasSynced, @BitmapOrder, 1) ELSE bitmapHasSynced END,
		bitmapIsHidden = CASE WHEN ci.SyncLiveCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsHidden, @BitmapOrder, 1) ELSE bitmapIsHidden END,
		bitmapIsDisabled = CASE WHEN ci.DisableLiveCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 1) ELSE bitmapIsDisabled END
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
	INNER JOIN #CustomerTemp tmp ON cs.CustID = tmp.CustID
