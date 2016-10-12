/*
	Created By: Helen
	Created Date: 20161006
	Task: https://nexdev.net/issues/65275
	
	DB: DBCUST/CUSTDB
*/
INSERT INTO WinLimit_ProductSettingDetail (ProductID, BettypeID, ExchangeID, SiteID, LevelID, MaxWinLimit, IsBlockedPlaceBet, IsBlockedTransfer)
SELECT 21,2401,72,22,1,1000,0,0
UNION ALL
SELECT 21,2401,72,22,2,5000,0,0
UNION ALL
SELECT 21,2401,72,22,3,10000,0,0

