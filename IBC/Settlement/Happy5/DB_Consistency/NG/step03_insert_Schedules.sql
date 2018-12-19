/*
	Created: Vicky
	Task: insert task for Happy5
	DB: DBTXN/bodb02
	Date: 20181019
*/
USE [bodb_Consistency]
GO



------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO [DBA_Schedules] (Name,TaskId,IsEnable,FrequenceType,FrequenceInterval,FrequenceSubDayType,FrequenceSubdayInterval,ActiveStartDate,ActiveEndDate,ActiveStartTime,ActiveEndTime,DateCreated,DateModified,NotifyLevelEmail,Emails)
VALUES
	 --PT
	 ('Check PT value for Happy5'								,25,1,4,1,8,1, GETDATE(),NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	 
	 --stake
	,('Check Stake >0 for dedicated bettypes for Happy5'		,26,1,4,1,8,1, GETDATE(),NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
	--IP
	,('Check Valid IP for Happy5'								,27,1,4,1,8,1, GETDATE(),NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
	--Check all yesterday tickets must be settled
	,('Check all yesterday tickets must be settled for Happy5'	,28,1,4,1,1,0, GETDATE(),NULL,'00:01:30',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
	--check betteam
	,('Check PT value for Happy5'								,29,1,4,1,8,1, GETDATE(),NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')
	
	--check comm, discount
	,('Check comm, discount value for Happy5'					,30,1,4,1,8,1, GETDATE(),NULL,'00:00:00',NULL,GETDATE(),GETDATE(),2, 'vicky.phan@nexcel.vn')