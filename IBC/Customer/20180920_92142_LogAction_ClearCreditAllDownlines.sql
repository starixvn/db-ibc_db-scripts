USE [bodb_CustomerLog]
GO

/*
	Created: 20180920@Percy
	DB: DBLOG.bodb_CustomerLog
	Task: New log ActionID for clear credit all downlines
*/


INSERT INTO dbo.LogAction (ActionID, SPName, IsInternal, ActionNameEN)
VALUES (1212, 'Age_ClearCredit_All_Ins', 0, 'Clear Credit all downlines')