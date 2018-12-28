/*
	Created: Vicky
	Task: insert Schedules for Happy5
	DB: DBTP/bodb_Consistency
	Date: 20181218
*/
USE [bodb_Consistency]
GO


UPDATE [DBA_Schedules]
SET ActiveStartTime = '01:30:00'
WHERE TaskId IN (22, 28)
	
	