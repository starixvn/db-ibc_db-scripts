/*
	Created: 20161028@Elodie
	DB: DBCUST/CustDB
	Task: Enable NG2 on PRO on IT release day (9/11/2016)
*/

USE CustDB
GO

UPDATE dbo.ProductSettingDetail
SET SettingStatus = 0
WHERE ProductID = 23

GO
UPDATE dbo.ProductStatusSiteCurrency
SET IsHidden = 1
WHERE SportType = 213 AND Currency <> 20