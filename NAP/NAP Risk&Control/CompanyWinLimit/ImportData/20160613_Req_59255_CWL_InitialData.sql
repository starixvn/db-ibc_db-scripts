/*
	Created by: Helen
	Created Date: 20160613
	Description: Company Win Limit Structure - Phase 2 
	Database: DBCUST/CUSTDB 
	
*/

INSERT INTO Winlimit_LevelSetting (LevelID, LevelName) 
VALUES 
 (1,	'Orange')
, (2,	'Yellow')
, (3,	'Red')
GO

INSERT INTO Winlimit_ActionSetting (ActionID, ActionName) 
VALUES 
 (0,	'Warning') 
,(1,	'Blocked Placebet')
,(2,	'Unblocked Placebet')
,(3,	'Blocked Transfer/Withdraw')
,(4,	'Unblocked Transfer/Withdraw')
,(5,	'Blocked Placebet and Blocked Transfer/Withdraw')

GO

INSERT INTO Winlimit_ProductSetting (ProductID,	BettypeID, LevelID, SettingStatus)
VALUES
(6,	2101,	1,	1)
,(6,	2101,	2,	1)
,(6,	2101,	3,	1)
,(13,	2001,	1,	1)
,(13,	2001,	2,	1)
,(13,	2001,	3,	1)
,(17,	2008,	1,	1)
,(17,	2008,	2,	1)
,(17,	2008,	3,	1)
,(22,	4001,	1,	1)
,(22,	4001,	2,	1)
,(22,	4001,	3,	1)


GO

