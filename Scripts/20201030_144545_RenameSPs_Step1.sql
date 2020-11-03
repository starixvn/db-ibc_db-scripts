/*<info serverAlias="DBRPT-bodb_report"></info>*/

/*
	Created: 20201030@Malcolm
	DB: DBRPT-bodb_Report
	Task: rename Sps [RedmineId : #144545]
*/

EXEC sp_rename 'Task_rptDepwinlost_CheckOutstanding', 'Del_Task_rptDepwinlost_CheckOutstanding'