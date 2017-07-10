
/*
	Created: 20170710@Helen
	Task: https://nexdev.net/issues/77564
	DB: DBCUST/CUSTDB
*/
USE CUSTDB
GO

UPDATE PSD
	SET MaxWinLimit = CASE WHEN psd.ExchangeID = 20 THEN MaxWinLimit_RM ELSE ROUND(MaxWinLimit_RM / e.actualrate,2) END
 FROM WinLimit_ProductSettingDetail PSD WITH(ROWLOCK, UPDLOCK)         
	INNER JOIN Exchange e WITH (NOLOCK)  ON e.ExchangeId = psd.ExchangeID
WHERE PSD.MaxWinLimit_RM IS NOT NULL AND PSD.ProductID = 28


