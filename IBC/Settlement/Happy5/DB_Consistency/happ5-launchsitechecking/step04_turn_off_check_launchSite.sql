/*
	Created: Vicky
	Task: turn off Happy5's launch site checking
	DB: DBTP/bodb_Consistency
	Date: 20190215
*/
USE [bodb_Consistency]
GO


--------------------------------------------------------------------------------


UPDATE DBA_Schedules
SET IsEnable = 0
	, DateModified	= GETDATE()
WHERE TaskId IN (31)


UPDATE DBA_Schedules
SET IsEnable = 0
	, ActiveEndTime = GETDATE()
	, ActiveEndDate = CONVERT(DATE, GETDATE())
	, DateModified	= GETDATE()
WHERE TaskId IN (32)