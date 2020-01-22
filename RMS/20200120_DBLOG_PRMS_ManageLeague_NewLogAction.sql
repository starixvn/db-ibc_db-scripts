USE bodb_CustomerLog
GO

/*
	Created: 20200120@Percy
	DB: DBLOG.bodb_CustomerLog
	Task: PRMS - Add new ActionId for League Management
*/

INSERT INTO dbo.LogAction (ActionID, ActionNameEN, SPName, IsInternal)
SELECT 10500, 'Add new special league', 'RMS_LeagueIns', 0
UNION ALL
SELECT 10501, 'Update special league to new group', 'RMS_LeagueUpd', 0