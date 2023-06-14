/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20230612@Evan
	DB: DBLIC
	Task: Drop code related to Saba Promotion -- Remove unused jobs   
	https://nexdev.net/issues/189234
*/
USE [msdb]
GO

EXEC msdb.dbo.sp_delete_job @job_name=N'bodb_LicenseeReport: DWPromotion - Generate Daily', @delete_unused_schedule=1

GO
