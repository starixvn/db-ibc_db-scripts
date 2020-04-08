/*
	Created: 20200401@Max
	Task: New Product - Check Data Consistency - [Redmine:#131485]
	DB: DBCONSISTENCY-bodb_Consistency

	* Specific Rule for Product: Virtual Games, Table Games, Saba.club
		- Rule #3: Settled tickets in translog but not having in bettrans
		- Rule #16: Wrong discount or comm value

*/
USE bodb_Consistency
GO

DECLARE @ruleId_s3 INT	,@taskId_s3 INT,
		@ruleId_s16 INT	,@taskId_s16 INT

DECLARE @ErrCode INT, @ErrMsg VARCHAR(100)

--S3 - Settled tickets in translog but not having in bettrans
INSERT [dbo].[DBA_Rules] ([Name], [Description], [SeverityLevel]) 
VALUES (N'Settled tickets in translog but not having in bettrans', N'Settled tickets in translog but not having in bettrans', N'High')

SET @ruleId_s3 = SCOPE_IDENTITY()

--ProductId 245 - Virtual Games
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (@ruleId_s3, N'EXEC dbo.DBA_Consistency_SpecificRulesChecking @ProductId = 245, @Rule = ''translog'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId_s3 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Settled tickets in translog but not having in bettrans'
 ,@TaskId = @taskId_s3
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

SELECT 'Settled tickets in translog but not having in bettrans' AS RuleChecking, @ErrCode, @ErrMsg

--ProductId 222 - Table Games
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (@ruleId_s3, N'EXEC dbo.DBA_Consistency_SpecificRulesChecking @ProductId = 222, @Rule = ''translog'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId_s3 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Settled tickets in translog but not having in bettrans'
 ,@TaskId = @taskId_s3
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

SELECT 'Settled tickets in translog but not having in bettrans' AS RuleChecking, @ErrCode, @ErrMsg


----S16 - Wrong discount or comm value
INSERT [dbo].[DBA_Rules] ([Name], [Description], [SeverityLevel]) 
VALUES (N'Wrong discount or comm value', N'Wrong discount or comm value', N'High')

SET @ruleId_s16 = SCOPE_IDENTITY()


--ProductId 245 - Virtual Games
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (@ruleId_s16, N'EXEC dbo.DBA_Consistency_SpecificRulesChecking @ProductId = 245, @Rule = ''no_discount_comm'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

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

--ProductId 222 - Table Games
INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (@ruleId_s16, N'EXEC dbo.DBA_Consistency_SpecificRulesChecking @ProductId = 222, @Rule = ''no_discount_comm'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

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

--ProductId 200 - Saba.club
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