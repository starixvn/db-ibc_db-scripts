/*
	Created: Vicky
	Task: insert task for Happy5
	DB: DBTXN/bodb02
	Date: 20181019
*/
USE [bodb_Consistency]
GO


DECLARE @activeStartDate VARCHAR(20)
SET @activeStartDate = '2018-12-18 00:00:00'
------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO [DBA_Schedules] (ScheduleId,Name,TaskId,IsEnable,FrequenceType,FrequenceInterval,FrequenceSubDayType,FrequenceSubdayInterval,ActiveStartDate,ActiveEndDate,ActiveStartTime,ActiveEndTime,DateCreated,DateModified,NotifyLevelEmail,Emails)
VALUES
	 --PT
	 (19,'Check PT value for Happy5'								,19,1,4,1,8,1, @activeStartDate,NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	 
	 --stake
	,(20,'Check Stake >0 for dedicated bettypes for Happy5'			,20,1,4,1,8,1, @activeStartDate,NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
	--IP
	,(21,'Check Valid IP for Happy5'								,21,1,4,1,8,1, @activeStartDate,NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
	--Check all yesterday tickets must be settled
	,(22,'Check all yesterday tickets must be settled for Happy5'	,22,1,4,1,1,0, @activeStartDate,NULL,'00:01:30',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
	--check betteam
	,(23,'Check PT value for Happy5'								,23,1,4,1,8,1, @activeStartDate,NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
	--check comm, discount
	,(24,'Check comm, discount value for Happy5'					,24,1,4,1,8,1, @activeStartDate,NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
	