/*
	Created: Elodie	
	Task: Initialize Product Status of Voidbridge for Newly created Credit customers
	DB: DBCUST/CustDB
	Date: 20160420
*/ 
DECLARE @MaxCustID2 INT
	
SELECT @MaxCustID2 = xxx
	
CREATE TABLE #supers (custid int)
	
INSERT INTO #supers(custid)
SELECT ci.custid
FROM CustInfo ci WITH(NOLOCK)
 INNER JOIN customer c WITH (NOLOCK) ON ci.custid = c.custid
 INNER JOIN site s WITH (NOLOCK) ON c.site = s.site
 LEFT JOIN custsuper cs WITH (NOLOCK) ON ci.custid = cs.custid
WHERE ci.roleid = 4  
 AND ci.username NOT LIKE '3rdSuper%'
 AND cs.isinternal = 0
 AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
 AND s.islicensee = 0
 AND ci.currency IN (34,45,43) --IDR,WON,'THB'

DECLARE @BitmapOrder TINYINT

SELECT @BitmapOrder = PSP.bitmapOrder
FROM dbo.ProductSettingDetail psd WITH(NOLOCK)  
	INNER JOIN dbo.ProductStatusProfile psp WITH (NOLOCK) ON psp.Sporttype = psd.SportType AND psp.Bettype = psd.BetType
WHERE psd.SettingType = 4 AND psd.ProductID = 22

/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
UPDATE cs
SET
		bitmapHasSynced = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapHasSynced, @BitmapOrder, 1) ELSE bitmapHasSynced END,
		bitmapIsHidden = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsHidden, @BitmapOrder, 0) ELSE bitmapIsHidden END,
		bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, @BitmapOrder, 0) ELSE bitmapIsDisabled END
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
WHERE ci.srecommend IN (SELECT CustID FROM #supers)
	AND ci.CustID > @MaxCustID2 
