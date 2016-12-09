/*
	Created by: Helen
	Created Date: 20160613
	Description: Company Win Limit Structure - Phase 2 
	Database: DBCUST/CUSTDB 
	
*/

INSERT INTO Winlimit_LevelSetting_UAT (LevelID, LevelName) 
VALUES 
 (1,	'Orange')
, (2,	'Yellow')
, (3,	'Red')
GO

INSERT INTO Winlimit_ActionSetting_UAT (ActionID, ActionName) 
VALUES 
 (0,	'Warning') 
,(1,	'Blocked Placebet')
,(2,	'Unblocked Placebet')
,(3,	'Blocked Transfer/Withdraw')
,(4,	'Unblocked Transfer/Withdraw')
,(5,	'Blocked Placebet and Blocked Transfer/Withdraw')

GO

