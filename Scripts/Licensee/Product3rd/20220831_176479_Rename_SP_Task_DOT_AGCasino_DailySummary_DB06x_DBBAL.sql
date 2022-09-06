/*<info serverAlias="DBACC-bodb02,DBBAL-bodb02"></info>*/
/*
	Created: 20220831@Sol
	DB: DBACC-bodb02,DBBAL-bodb02
	Task: rename unused sp Task_DOT_AGCasino_DailySummary in DBACC and DBBAL - [RedmineID: #176479]
*/

USE bodb02

GO

EXEC sp_rename 'Task_DOT_AGCasino_DailySummary', 'DEL_Task_DOT_AGCasino_DailySummary'; 

GO