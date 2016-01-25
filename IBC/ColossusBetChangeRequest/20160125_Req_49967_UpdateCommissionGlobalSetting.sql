/*
	Created by: Helen
	Date: 2016-01-13
	Task: # Colossus Bet Change Request - [Redmine: 51387]
	DB: DBCUST / CustDB
*/
USE CustDB
GO
UPDATE ProductGlobalSetting
	SET Maxsdiscount = 0.10
WHERE sporttype = 204  AND bettype = 18001    	

GO

