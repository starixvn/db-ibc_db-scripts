USE bodb_CustomerLog
GO
/*	Creator: Kathy
	Date: 20190529
	Task: Add new log action for BetBuilder 
	DB: DBLOG/bodb_CustomerLog
	
*/	
INSERT INTO dbo.LogAction (ActionID, SPName, ActionNameEN)
VALUES(81013, 'NAP_Admin_Settlement_AutoWriteLog', 'API Auto Settlement: succeed'), (81014, 'NAP_Admin_Settlement_AutoWriteLog', 'API Auto Settlement: failed')

GO