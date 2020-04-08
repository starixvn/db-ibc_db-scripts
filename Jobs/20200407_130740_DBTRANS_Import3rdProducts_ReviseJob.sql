USE msdb
GO

EXEC sp_update_jobstep
	@job_name=N'bodb02: Licensee Winloss AG GD VG',
	@step_name=N'Generate data',
	@step_id=1,
	@on_success_action=1,
	@command=N'DECLARE @WinlostDate SMALLDATETIME
SELECT  @WinlostDate = CONVERT(VARCHAR(10), DATEADD(DAY, -1, GETDATE()), 112)
EXEC dbo.Task_DEP_SeparatedWallet_GenerateData @WinlostDate = @WinlostDate',
	@database_name=N'bodb02'
GO

EXEC sp_delete_jobstep
	@job_name=N'bodb02: Licensee Winloss AG GD VG',
	@step_id=3
GO

EXEC sp_delete_jobstep
	@job_name=N'bodb02: Licensee Winloss AG GD VG',
	@step_id=2
GO