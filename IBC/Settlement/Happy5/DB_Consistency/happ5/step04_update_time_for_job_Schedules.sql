/*
	Created: Vicky
	Task: update Schedules for Happy5 & NG
	DB: DBTP/bodb_Consistency
	Date: 20181218
*/
USE [bodb_Consistency]
GO


UPDATE [DBA_Schedules]
SET ActiveStartTime = '01:30:00'
WHERE TaskId IN (22, 28)
	
	