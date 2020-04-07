/*
	Created: 20200401@Max
	Task: Saba.club - Check Data Consistency - [Redmine:#131730]
	DB: DBCONSISTENCY-bodb_Consistency

*/
USE bodb_Consistency
GO

DECLARE @taskId_g1 INT, @taskId_g2 INT, @taskId_g3 INT, @taskId_g4 INT, @taskId_g5 INT,
		@ruleId_s30 INT, @taskId_s30 INT,
		@ruleId_s16 INT	,@taskId_s16 INT

DECLARE @ErrCode INT, @ErrMsg VARCHAR(100)

--G2 - Check PT value
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (2, N'EXEC dbo.DBA_Consistency_PTChecking @ProductId = 200, @tablename = ''bettransRNG'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

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
VALUES (3, N'EXEC dbo.DBA_Consistency_StakeChecking @ProductId = 200, @tablename = ''bettransRNG'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

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
VALUES (4, N'EXEC dbo.DBA_Consistency_IPChecking @ProductId = 200, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

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

--G5 - Check all yesterday tickets must be settled
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (5, N'EXEC dbo.DBA_Consistency_StatusChecking @ProductId = 200, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId_g5 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Check all yesterday tickets must be settled'
 ,@TaskId = @taskId_g5
 ,@IsEnable  = 1
 ,@FrequenceType = 4 -- daily = 4, weekly = 8
 ,@FrequenceInterval = 1 -- every xx days
 ,@FrequenceSubDayType = 1 -- specified time: 1, second: 2, min: 4, hour: 8
 ,@FrequenceSubDayInterval = 0 -- specified time: 0; <> 0: every FrequenceSubDayType
 ,@ActiveStartDate = '2020-04-06' 
 ,@ActiveEndDate = NULL
 ,@ActiveStartTime  = '01:30'
 ,@ActiveEndTime = NULL
 ,@NotifyLevelEmail = 2
 --,@Emails = 'max.tran@starixsoft.com;helen.do@starixsoft.com'
 ,@Emails = 'dbaadmin@starixsoft.com'
 ,@ErrCode  = @ErrCode OUTPUT
 ,@ErrMsg = @ErrMsg OUTPUT

SELECT 'Check all yesterday tickets must be settled' AS RuleChecking, @ErrCode, @ErrMsg

--S30 - Running ticket with transdate + 3 minutes > current time 
INSERT [dbo].[DBA_Rules] ([Name], [Description], [SeverityLevel]) 
VALUES (N'Running ticket with transdate + 3 minutes > current time', N'Running ticket with transdate + 3 minutes > current time', N'High')

SET @ruleId_s30 = SCOPE_IDENTITY()

INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (@ruleId_s30, N'EXEC dbo.DBA_Consistency_SpecificRulesChecking @ProductId = 200, @Rule = ''3min'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId_s30 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Running ticket with transdate + 3 minutes > current time'
 ,@TaskId = @taskId_s30
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

SELECT 'Running ticket with transdate + 3 minutes > current time' AS RuleChecking, @ErrCode, @ErrMsg

----S16 - Wrong discount or comm value
INSERT [dbo].[DBA_Rules] ([Name], [Description], [SeverityLevel]) 
VALUES (N'Wrong discount or comm value', N'Wrong discount or comm value', N'High')

SET @ruleId_s16 = SCOPE_IDENTITY()

INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (@ruleId_s16, N'EXEC dbo.DBA_Consistency_SpecificRulesChecking @ProductId = 200, @Rule = ''no_discount_comm'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId_s16 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Wrong discount or comm value'
 ,@TaskId = @taskId_s16
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

SELECT 'Wrong discount or comm value' AS RuleChecking, @ErrCode, @ErrMsg





