/*
	Created: 20161028@Elodie
	DB: DBCUST/CustDB
	Task: Disable NG2 on PRO (16/11/2016)
*/

USE CustDB
GO

UPDATE dbo.ProductSettingDetail
SET SettingStatus = 0
WHERE ProductID = 23