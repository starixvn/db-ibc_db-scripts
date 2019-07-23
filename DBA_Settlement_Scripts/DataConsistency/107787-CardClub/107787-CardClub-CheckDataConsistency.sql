USE bodb_Consistency
GO
/*
	Created: 20190717@Kathy
	Task: Card Club- Video Poker Games - Check data Consistency [Redmine:#107787]
	DB: DBCONSISTENCY-bodb_Consistency

*/

UPDATE DBA_Tasks WITH (ROWLOCK, UPDLOCK)
	set command = REPLACE(command,'163', '165')
WHERE TaskId IN (1,2,3,4,5)

DELETE FROM DBA_Schedules WITH (ROWLOCK, UPDLOCK)
WHERE TaskId IN (6,7,8,9,10,11)

DELETE FROM DBA_Tasks WITH(ROWLOCK, UPDLOCK)
WHERE TaskId IN (6,7,8,9,10,11)


DECLARE @taskId INT
		,@schedulename VARCHAR(200)
		,@Emails VARCHAR(MAX)

		,@ErrCode INT
		,@ErrMsg VARCHAR(100)

SET @Emails = 'dbaadmin@starixsoft.com'

-- Insert Task
INSERT INTO dbo.DBA_Tasks (RuleId, command) 
	VALUES (17, 'EXEC DBA_Consistency_LaunchedSiteChecking @ProductId=165, @sites=''Indo,KORIBC'', @IsLaunched = 1, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId = SCOPE_IDENTITY()
SET @schedulename = 'Check un-launched sites'


-- Insert Schedule
EXEC dbo.DBA_Consistency_ScheduleIns @Name = @schedulename
 ,@TaskId = @taskId
 ,@IsEnable  = 1
 ,@FrequenceType = 4 -- daily = 4, weekly = 8
 ,@FrequenceInterval = 1 -- every xx days
 ,@FrequenceSubDayType = 8 -- specified time: 1, second: 2, min: 4, hour: 8
 ,@FrequenceSubDayInterval = 1 -- specified time: 0; <> 0: every FrequenceSubDayType
 ,@ActiveStartDate = '2019-08-08' 
 ,@ActiveEndDate =  '2019-08-21' 
 ,@ActiveStartTime  = '00:00'
 ,@ActiveEndTime = '23:59'
 ,@NotifyLevelEmail = 2
 ,@Emails = @Emails
 ,@ErrCode  = @ErrCode OUTPUT
 ,@ErrMsg = @ErrMsg OUTPUT

SELECT @ErrCode, @ErrMsg
