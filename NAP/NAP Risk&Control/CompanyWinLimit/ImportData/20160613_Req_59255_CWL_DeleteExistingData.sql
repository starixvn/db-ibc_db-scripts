/*
	Created By: Helen
	Created Date: 20162007
	Task: Currency Setting Initialization for CWL
	
	DB: DBCust/CUSTDB
	
	We have 181 SITE, 25 CURRENCY, 4 PRODUCT, 3 LEVEL --> SELECT 181*25*4 * 3= 56472 rows to be inserted
*/

USE CustDB

GO

TRUNCATE TABLE WinLimit_ProductSettingDetail

GO

TRUNCATE TABLE WinLimit_CustGameSetting

GO

TRUNCATE TABLE WinLimit_CustGameStatus

GO

TRUNCATE TABLE WinLimit_CustGameMonitoring

GO

TRUNCATE TABLE dbo.WinLimit_CustGameMonitoring_History




