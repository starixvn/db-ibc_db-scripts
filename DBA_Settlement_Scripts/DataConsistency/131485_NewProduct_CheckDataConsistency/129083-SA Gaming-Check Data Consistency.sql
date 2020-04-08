/*
	Created: 20200401@Max
	Task: SA Gaming - Check Data Consistency - [Redmine:#129083]
	DB: DBCONSISTENCY-bodb_Consistency

*/
USE bodb_Consistency
GO

DECLARE @taskId_g1 INT, @taskId_g2 INT, @taskId_g3 INT, @taskId_g4 INT, @taskId_g7 INT,
		@ruleId_s26 INT, @taskId_s26 INT,
		@ruleId_s27 INT, @taskId_s27 INT

DECLARE @ErrCode INT, @ErrMsg VARCHAR(100)

-- G1 - Check Discount value
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (1, N'EXEC dbo.DBA_Consistency_DiscountChecking @ProductId = 244, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId_g1 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Check Discount value'
 ,@TaskId = @taskId_g1
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

SELECT 'Check Discount value' AS RuleChecking, @ErrCode, @ErrMsg
---------------------------------------------------------

--G2 - Check PT value
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (2, N'EXEC dbo.DBA_Consistency_PTChecking @ProductId = 244, @tablename = ''bettransLC'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

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
---------------------------------------------------------

--G3 - Check Stake
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (3, N'EXEC dbo.DBA_Consistency_StakeChecking @ProductId = 244, @tablename = ''bettransLC'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

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
---------------------------------------------------------

--G4 - Check Valid IP
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (4, N'EXEC dbo.DBA_Consistency_IPChecking @ProductId = 244, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

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
---------------------------------------------------------

--G5 - Check all yesterday tickets must be settled
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (5, N'EXEC dbo.DBA_Consistency_StatusChecking @ProductId = 244, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId_g7 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Check all yesterday tickets must be settled'
 ,@TaskId = @taskId_g7
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
---------------------------------------------------------

--S26 - Check Member Winlost Consistent
INSERT [dbo].[DBA_Rules] ([Name], [Description], [SeverityLevel]) 
VALUES (N'Check Member Winlost Consistent', N'Check Member Winlost Consistent', N'High')

SET @ruleId_s26 = SCOPE_IDENTITY()

INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (@ruleId_s26, N'EXEC dbo.DBA_Consistency_SpecificRulesChecking @ProductId = 244, @Rule = ''winlost'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId_s26 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Check Member Winlost Consistent'
 ,@TaskId = @taskId_s26
 ,@IsEnable  = 1
 ,@FrequenceType = 4 -- daily = 4, weekly = 8
 ,@FrequenceInterval = 1 -- every xx days
 ,@FrequenceSubDayType = 1 -- specified time: 1, second: 2, min: 4, hour: 8
 ,@FrequenceSubDayInterval = 0 -- specified time: 0; <> 0: every FrequenceSubDayType
 ,@ActiveStartDate = '2020-04-06' 
 ,@ActiveEndDate = NULL
 ,@ActiveStartTime  = '00:30'
 ,@ActiveEndTime = NULL
 ,@NotifyLevelEmail = 2
 --,@Emails = 'max.tran@starixsoft.com;helen.do@starixsoft.com'
 ,@Emails = 'dbaadmin@starixsoft.com'
 ,@ErrCode  = @ErrCode OUTPUT
 ,@ErrMsg = @ErrMsg OUTPUT

SELECT 'Check Member Winlost Consistent' AS RuleChecking, @ErrCode, @ErrMsg
---------------------------------------------------------

--S27 - Check Member Stake Consistent
INSERT [dbo].[DBA_Rules] ([Name], [Description], [SeverityLevel]) 
VALUES (N'Check Member Stake Consistent', N'Check Member Stake Consistent', N'High')

SET @ruleId_s27 = SCOPE_IDENTITY()

INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (@ruleId_s27, N'EXEC dbo.DBA_Consistency_SpecificRulesChecking @ProductId = 244, @Rule = ''stake'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId_s27 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Check Member Stake Consistent'
 ,@TaskId = @taskId_s27
 ,@IsEnable  = 1
 ,@FrequenceType = 4 -- daily = 4, weekly = 8
 ,@FrequenceInterval = 1 -- every xx days
 ,@FrequenceSubDayType = 1 -- specified time: 1, second: 2, min: 4, hour: 8
 ,@FrequenceSubDayInterval = 0 -- specified time: 0; <> 0: every FrequenceSubDayType
 ,@ActiveStartDate = '2020-04-06' 
 ,@ActiveEndDate = NULL
 ,@ActiveStartTime  = '00:30'
 ,@ActiveEndTime = NULL
 ,@NotifyLevelEmail = 2
 --,@Emails = 'max.tran@starixsoft.com;helen.do@starixsoft.com'
 ,@Emails = 'dbaadmin@starixsoft.com'
 ,@ErrCode  = @ErrCode OUTPUT
 ,@ErrMsg = @ErrMsg OUTPUT

SELECT 'Check Member Stake Consistent' AS RuleChecking, @ErrCode, @ErrMsg
---------------------------------------------------------





