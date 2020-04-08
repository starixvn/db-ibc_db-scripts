/*
	Created: 20200401@Max
	Task: Virtual Games - Check Data Consistency - [Redmine:#131485]
	DB: DBCONSISTENCY-bodb_Consistency

*/
USE bodb_Consistency
GO

DECLARE @taskId_g1 INT, @taskId_g2 INT, @taskId_g3 INT, @taskId_g4 INT

DECLARE @ErrCode INT, @ErrMsg VARCHAR(100)

--G2 - Check PT value
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (2, N'EXEC dbo.DBA_Consistency_PTChecking @ProductId = 245, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId_g2 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Check PT value'
 ,@TaskId = @taskId_g2
 ,@IsEnable  = 1
 ,@FrequenceType = 4 -- daily = 4, weekly = 8
 ,@FrequenceInterval = 1 -- every xx days
 ,@FrequenceSubDayType = 8 -- specified time: 1, second: 2, min: 4, hour: 8
 ,@FrequenceSubDayInterval = 1 -- specified time: 0; <> 0: every FrequenceSubDayType
 ,@ActiveStartDate = '2020-04-06' 
 ,@ActiveEndDate = NULL
 ,@ActiveStartTime  = '00:00'
 ,@ActiveEndTime = NULL
 ,@NotifyLevelEmail = 2
 --,@Emails = 'max.tran@starixsoft.com;helen.do@starixsoft.com'
 ,@Emails = 'dbaadmin@starixsoft.com'
 ,@ErrCode  = @ErrCode OUTPUT
 ,@ErrMsg = @ErrMsg OUTPUT

SELECT 'Check PT value' AS RuleChecking, @ErrCode, @ErrMsg

--G3 - Check Stake
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (3, N'EXEC dbo.DBA_Consistency_StakeChecking @ProductId = 245, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId_g3 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Check Stake >0 for dedicated bettypes'
 ,@TaskId = @taskId_g3
 ,@IsEnable  = 1
 ,@FrequenceType = 4 -- daily = 4, weekly = 8
 ,@FrequenceInterval = 1 -- every xx days
 ,@FrequenceSubDayType = 8 -- specified time: 1, second: 2, min: 4, hour: 8
 ,@FrequenceSubDayInterval = 1 -- specified time: 0; <> 0: every FrequenceSubDayType
 ,@ActiveStartDate = '2020-04-06' 
 ,@ActiveEndDate = NULL
 ,@ActiveStartTime  = '00:00'
 ,@ActiveEndTime = NULL
 ,@NotifyLevelEmail = 2
 --,@Emails = 'max.tran@starixsoft.com;helen.do@starixsoft.com'
 ,@Emails = 'dbaadmin@starixsoft.com'
 ,@ErrCode  = @ErrCode OUTPUT
 ,@ErrMsg = @ErrMsg OUTPUT

SELECT 'Check Stake >0 for dedicated bettypes' AS RuleChecking, @ErrCode, @ErrMsg

--G4 - Check Valid IP
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (4, N'EXEC dbo.DBA_Consistency_IPChecking @ProductId = 245, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId_g4 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Check Valid IP'
 ,@TaskId = @taskId_g4
 ,@IsEnable  = 1
 ,@FrequenceType = 4 -- daily = 4, weekly = 8
 ,@FrequenceInterval = 1 -- every xx days
 ,@FrequenceSubDayType = 8 -- specified time: 1, second: 2, min: 4, hour: 8
 ,@FrequenceSubDayInterval = 1 -- specified time: 0; <> 0: every FrequenceSubDayType
 ,@ActiveStartDate = '2020-04-06' 
 ,@ActiveEndDate = NULL
 ,@ActiveStartTime  = '00:00'
 ,@ActiveEndTime = NULL
 ,@NotifyLevelEmail = 2
 --,@Emails = 'max.tran@starixsoft.com;helen.do@starixsoft.com'
 ,@Emails = 'dbaadmin@starixsoft.com'
 ,@ErrCode  = @ErrCode OUTPUT
 ,@ErrMsg = @ErrMsg OUTPUT

SELECT 'Check Valid IP' AS RuleChecking, @ErrCode, @ErrMsg






