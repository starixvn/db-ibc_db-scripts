/*
	Created: Vicky
	Task: insert Schedules for Happy5
	DB: DBTP/bodb_Consistency
	Date: 20181218
*/
USE [bodb_Consistency]
GO


DECLARE @activeStartDate VARCHAR(20), @email VARCHAR(MAX)

SET @activeStartDate = '2019-01-03 00:00:00'
SET @email = 'dbaadmin@starixsoft.com'

------------------------------------------------------------------------------------------------------------------------------------------------------------


INSERT INTO [DBA_Schedules] (Name,TaskId,IsEnable,FrequenceType,FrequenceInterval,FrequenceSubDayType,FrequenceSubdayInterval,ActiveStartDate,ActiveEndDate,ActiveStartTime,ActiveEndTime,DateCreated,DateModified,NotifyLevelEmail,Emails)
VALUES
	 --Check un-launched sites
	 ('Check un-launched sites'									,31,1,4,1,8,1, @activeStartDate,NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, @email)