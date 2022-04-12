/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Creator:	20220221@Percy
	Task:		MPA - Remove job import N88_RptWinloss (change job name also) - [Redmine: #167823]
	Database:	DBN88.bodb_N88
	Job name: bodb_N88: Generate daily data for N88_RptWinloss
*/
use msdb
go

-- Remove step gen data for N88_RptWinloss
exec sp_delete_jobstep @job_name = 'bodb_N88: Generate daily data for N88_RptWinloss'
     , @step_id = 2

-- Change job name
exec sp_update_job @job_name = 'bodb_N88: Generate daily data for N88_RptWinloss'
     , @new_name = 'bodb_N88: Generate daily data'