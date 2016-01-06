/*
	Created by: Helen
	Date: 2015-08-21
	Task: # Colossus Bet Product - Disallow SMA changes password or updates account status of members [Redmine: #49967]
	DB: DBCUST / CustDB
*/
USE CustDB
GO
INSERT INTO MsgError (MsgID,MsgGroupID,MsgNameEN,IsActive) VALUES (40033,5,'You are currently not authorized to perform this action. Please contact the Customer Service Department for further assistance.',1)

GO

UPDATE ProductGlobalSetting
	SET Maxsdiscount = 0.1012500
WHERE sporttype = 204  AND bettype = 18001    	

GO

UPDATE ProductGlobalSetting
	SET Maxsdiscount = 0.375000
WHERE sporttype = 204  AND bettype = 18002    	


