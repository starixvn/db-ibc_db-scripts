/*
	Created: Winnie
	Date: 2016-09-13
	Task: Insert colossus settings for credit customers
	DB: DBCUST/CustDB
*/ 

------------------------------------------------------

USE CustDB
GO
UPDATE ProductGlobalSetting
	SET Maxsdiscount = 0.10
WHERE sporttype = 204  AND bettype = 18001    	

UPDATE ProductGlobalSetting
	SET Maxsdiscount = 0.375
WHERE sporttype = 204  AND bettype = 18002

GO

