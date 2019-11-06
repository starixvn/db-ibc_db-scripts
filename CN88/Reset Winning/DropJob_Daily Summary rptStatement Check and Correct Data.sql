USE [msdb]
GO

/*Create: 20191106@Sophia
Task: drop current job, use new job "bodb02: Check and Correct Data - After MoveBets "
*/

/****** Object:  Job [bodb_Report: Daily Summary rptStatement Check and Correct Data]    Script Date: 11/6/2019 5:06:08 PM ******/
EXEC msdb.dbo.sp_delete_job @job_name=N'bodb_Report: Daily Summary rptStatement Check and Correct Data', @delete_unused_schedule=1
GO


