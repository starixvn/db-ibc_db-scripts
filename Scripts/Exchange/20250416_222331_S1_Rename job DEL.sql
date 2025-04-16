/*<info serverAlias="DBEXT-bodb02"></info>*/

/*
	Created by: 20250416@Kelvin
	DB: DBEXT-bodb02
	Task: Enhance ExchangeDailyOANDA job - Check & Correct [RedmineID: #222331]
*/

GO

--DB053/DB052
--=====================================================================================================================================
USE [msdb]

GO

EXEC dbo.sp_update_job @job_name = N'bodb02: Check/Verify ExchangeDaily', @new_name = N'DEL_bodb02: Check/Verify ExchangeDaily', @enabled = 0 ;

--=====================================================================================================================================



