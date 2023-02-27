
/*<info serverAlias="DBACC-bodb02"></info>*/
Use bodb02

/*
Create: 20230227@Danny
DB : DBACC-bodb02
Task: Stop job CN88 [Redmine: #184200]

*/

EXEC msdb.dbo.sp_update_job @job_name='bodb02 : Task CN88 Headline Balance',@enabled = 0

EXEC msdb.dbo.sp_update_job @job_name='bodb02 : Task CN88 Headline Balance - Check and Correct Data',@enabled = 0 