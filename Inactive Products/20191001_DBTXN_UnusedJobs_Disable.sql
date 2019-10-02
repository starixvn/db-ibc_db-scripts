use msdb
go

/*
	Created: 20191001@Percy
	DB: DBTXN
	Task: Remove inactive products - Disable unused jobs
*/

exec dbo.sp_update_job
	@job_name = 'DBTRANS : Reset Winnings Daily - Amount due to Partners'
	,@enabled = 0