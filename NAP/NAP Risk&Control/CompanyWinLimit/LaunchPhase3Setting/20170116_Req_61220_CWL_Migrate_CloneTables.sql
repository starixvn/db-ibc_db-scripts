/*
	Created: 20170120@Helen
	Task: Migrate data - https://nexdev.net/issues/61220
	DB: DBCUST/CUSTDB
*/

USE CustDB

GO
SELECT *
INTO PRO_WinLimit_CustGameSetting
FROM WinLimit_CustGameSetting WITH (NOLOCK)

GO

SELECT *
INTO PRO_WinLimit_ProductSettingDetail
FROM WinLimit_ProductSettingDetail WITH (NOLOCK)

GO

SELECT * 
INTO PRO_WinLimit_CustGameMonitoring
FROM WinLimit_CustGameMonitoring WITH (NOLOCK)

GO
SELECT * 
INTO PRO_WinLimit_CustGameMonitoring_History
FROM WinLimit_CustGameMonitoring_History WITH (NOLOCK)