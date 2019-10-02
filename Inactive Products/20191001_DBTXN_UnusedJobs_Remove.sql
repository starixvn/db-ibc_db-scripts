use msdb
go

/*
	Created: 20191001@Percy
	DB: DBTXN
	Task: Remove inactive products - Remove unused jobs
*/

exec dbo.sp_delete_job @job_name = 'DBTRANS : Reset Winnings Daily - Amount due to Partners'