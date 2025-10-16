/*<info serverAlias="DBEXT-msdb"></info>*/

/*
	Created by: 20251014@Kelvin
	DB: DBEXT-msdb
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

GO

-- DB053/DB052
--=====================================================================================================================================
USE [msdb]

GO
EXEC dbo.sp_update_job @job_name = N'bodb_YashBet: API_Queue Process', @enabled = 0 ;

--=====================================================================================================================================



