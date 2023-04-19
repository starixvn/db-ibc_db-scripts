/*<info serverAlias="DBPTCS-bodb_PlaytechCS,DBBAL-bodb_PlaytechCS"></info>*/
USE bodb_PlaytechCS

/*
	Created: 20230419@Evan
	DB: DBPTCS-bodb_PlaytechCS,DBBAL-bodb_PlaytechCS
	Task: Drop un-used SP [Redmine: #181424]
*/
GO

sp_rename 'Task_GoldDeluxe_ImportDataToDB_Queue', 'DEL_Task_GoldDeluxe_ImportDataToDB_Queue'
sp_rename 'Task_DOT_GoldDeluxe_DailySummary', 'DEL_Task_DOT_GoldDeluxe_DailySummary'