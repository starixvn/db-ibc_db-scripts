/*
	Created: Vicky
	Task: insert task for Happy5
	DB: DBTP/bodb_Consistency
	Date: 20181019
*/
USE [bodb_Consistency]
GO




DECLARE @activeStartDate VARCHAR(20)
SET @activeStartDate = '2018-12-18 00:00:00'
------------------------------------------------------------------------------------------------------------------------------------------------------------


INSERT INTO [DBA_Schedules] (Name,TaskId,IsEnable,FrequenceType,FrequenceInterval,FrequenceSubDayType,FrequenceSubdayInterval,ActiveStartDate,ActiveEndDate,ActiveStartTime,ActiveEndTime,DateCreated,DateModified,NotifyLevelEmail,Emails)
VALUES
	 --PT
	 ('Check PT value'									,25,1,4,1,8,1, @activeStartDate,NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	 
	 --stake
	,('Check Stake >0 for dedicated bettypes'			,26,1,4,1,8,1, @activeStartDate,NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
	--IP
	,('Check Valid IP'									,27,1,4,1,8,1, @activeStartDate,NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
	--Check all yesterday tickets must be settled
	,('Check all yesterday tickets must be settled'		,28,1,4,1,1,0, @activeStartDate,NULL,'00:01:30',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
	--check betteam
	,('Check Betteam'									,29,1,4,1,8,1, @activeStartDate,NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
	--check comm, discount
	,('Check if no discount, no comm'					,30,1,4,1,8,1, @activeStartDate,NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
