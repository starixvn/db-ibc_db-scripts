/*<info serverAlias="DBAFF12BET-Affiliate_12BET"></info>*/

/*
	Created: 20201030@Malcolm
	DB: DBAFF12BET-Affiliate_12BET
	Task: rename Sps [RedmineId : #144545]
*/

EXEC sp_rename 'Task_Aff_MemberDaily_CheckData_Job', 'Del_Task_Aff_MemberDaily_CheckData_Job'

EXEC sp_rename 'Task_APIProduct_ImportQueue_Product_Job', 'Del_Task_APIProduct_ImportQueue_Product_Job'