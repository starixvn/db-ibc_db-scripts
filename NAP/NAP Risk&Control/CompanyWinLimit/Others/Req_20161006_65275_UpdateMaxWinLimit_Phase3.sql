/*
	Created By: Helen
	Create Date: 20161216
	Task: CWL - phase 3 - https://nexdev.net/issues/61220
	
	DB: DBCUST/custdb
	
*/
USE CustDB
GO
UPDATE T
	SET MaxWinLimit_RM = 10000
FROM WinLimit_ProductSettingDetail_UAT T WITH (ROWLOCK)
WHERE LevelID = 1

UPDATE T
	SET MaxWinLimit_RM = 30000
FROM WinLimit_ProductSettingDetail_UAT T WITH (ROWLOCK)
WHERE LevelID = 2

UPDATE T
	SET MaxWinLimit_RM = 100000
FROM WinLimit_ProductSettingDetail_UAT T WITH (ROWLOCK)
WHERE LevelID = 3

GO

EXEC Task_Winlimit_CurrencyMaxWinLimitUpd


