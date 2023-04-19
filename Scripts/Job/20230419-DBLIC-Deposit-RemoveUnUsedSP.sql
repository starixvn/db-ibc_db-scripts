/*<info serverAlias="DBLIC-bodb_3rdproduct"></info>*/
USE bodb_3rdproduct

/*
	Created: 20230419@Evan
	DB: DBLIC-bodb_3rdproduct
	Task: Drop un-used SP [Redmine: #181424]
*/
GO

sp_rename 'Task_DOT_VoidBridge_DailySummary', 'DEL_Task_DOT_VoidBridge_DailySummary'