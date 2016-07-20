/*
	Created By: Helen
	Created Date: 20162007
	Task: Update product profile for CWL
	
	DB: DBCust/CUSTDB
	
	
*/

USE CustDB

GO

UPDATE Winlimit_ProductSetting SET SettingStatus = 0
WHERE ProductID IN (6,13,17,22)

GO