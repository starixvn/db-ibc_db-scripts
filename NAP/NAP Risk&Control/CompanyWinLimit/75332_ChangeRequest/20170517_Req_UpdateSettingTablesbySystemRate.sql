/*
	Create: 20170517@Helen
	Task : NAP Risk & Control - Phase 3 [Redmine: 75332]
	DB: DBCUST/CustDB
*/
USE CUSTDB
GO

UPDATE PSD
	SET MaxWinLimit = CASE WHEN psd.ExchangeID = 20 THEN MaxWinLimit_RM ELSE ROUND(MaxWinLimit_RM / e.actualrate,2) END
 FROM WinLimit_ProductSettingDetail PSD WITH(ROWLOCK, UPDLOCK)         
	INNER JOIN Exchange e WITH (NOLOCK)  ON e.ExchangeId = psd.ExchangeID
WHERE PSD.MaxWinLimit_RM IS NOT NULL
	
UPDATE PSD
	SET MaxWinLimit = CASE WHEN CI.currency = 20 THEN MaxWinLimit_RM ELSE ROUND(MaxWinLimit_RM / e.actualrate,2) END
FROM WinLimit_CustGameSetting PSD WITH(ROWLOCK, UPDLOCK)         
	INNER JOIN custInfo CI WITH (NOLOCK) ON CI.custid = PSD.CustID
	INNER JOIN Exchange e WITH (NOLOCK)  ON e.ExchangeId = CI.currency
	
WHERE PSD.MaxWinLimit_RM IS NOT NULL