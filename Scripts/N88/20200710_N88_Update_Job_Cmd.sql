/*<info serverAlias="DBN88-bodb_N88" isFunction="0" isNested=""></info>*/
/*
Created: 20200710@Sol
Task: Update command for job step 1 - use new sp [Redmine: #137064]
DB: DBN88-bodb_N88
*/

USE [msdb]

GO

EXEC msdb.dbo.sp_update_jobstep @job_name =N'bodb_N88: Generate daily data for N88_RptWinloss', @step_id=1 , 
		@command=N'EXEC Task_N88_RptWinloss_Job'

GO
