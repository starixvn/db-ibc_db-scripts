/*
	Created: Vicky
	Task: turn off Happy5's launch site checking
	DB: DBTP/bodb_Consistency
	Date: 20190215
*/
USE [bodb_Consistency]
GO


------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE DBA_Schedules
SET IsEnable = 0
	, ActiveEndTime = GETDATE()
	, ActiveEndDate = Convert(DATE, GETDATE())
WHERE TaskId IN (31,32)