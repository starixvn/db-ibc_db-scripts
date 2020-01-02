/*
	Created: 20191112@Percy
	DB: DBTXN
	Task: Bet Follow - Drop job (PRO)
*/

use msdb
go

exec dbo.sp_delete_job @job_name = N'bodb02 : New Task FollowBet', @delete_unused_schedule = 1
go