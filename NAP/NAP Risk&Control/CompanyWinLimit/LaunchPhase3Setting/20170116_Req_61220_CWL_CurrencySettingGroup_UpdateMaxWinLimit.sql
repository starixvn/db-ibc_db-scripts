/*
	Created: 20170120@Helen
	Task: initialize data - https://nexdev.net/issues/61220
	DB: DBCUST/CUSTDB
*/
 
DECLARE @Fromdate DATE= GETDATE(), @Todate DATE= GETDATE()  

UPDATE PSD
	SET MaxWinLimit = CASE WHEN psd.ExchangeID = 20 THEN MaxWinLimit_RM ELSE ROUND(MaxWinLimit_RM / FEX.MYR,2) END
FROM WinLimit_ProductSettingDetail PSD 
	INNER JOIN Lrf_f_GetExchangeDaily(@Fromdate, @Todate) fEx  ON fEx.ExchangeId = psd.ExchangeID
WHERE PSD.MaxWinLimit_RM IS NOT NULL
	


			
		