use msdb
go

/*
	Created: 20191125@Percy
	DB: DB06/DB061
	Task: Split out step headline balance from check and correct statement job - Remove step check and correct headline balance
*/

EXEC sp_delete_jobstep
	@job_name = 'bodb02: Check and Correct Data - After MoveBets'
	,@step_id = 3
GO

EXEC sp_update_jobstep
	@job_name = 'bodb02: Check and Correct Data - After MoveBets'
	,@step_id = 1
	,@on_success_action = 4
	,@on_success_step_id = 3
	, @subsystem=N'TSQL'
	,@command=N'-- MB does not start yet or is running --> loop 15 minutes
EXEC dbo.Task_MoveBets_Status_Job

-- BU does not start yet or is running --> loop 15 minutes
EXEC dbo.Task_BalanceUp_Status_Job

-- Headline Balance Correct Job is running --> loop 15 minutes
EXEC DBTXN.bodb02.dbo.Task_HeadlineBalance_Status_Job'
	,@database_name=N'bodb02'
GO