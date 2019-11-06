/*
	Created: 20191031@Helen
	Task: New rules for VS, NG, Happy 5 - [Redmine:122716]
Rule: 
Rule
23 (30p)- Check all today tickets running > 30 minutes must be settled
24 (daily 1:30)- detect Yesterday pending  matches for Virtual sports events <> 'completed'

Task: 
Task, rule
57, 23
58, 24

Schedule:
scheduleid, taskid
54, 57
55, 58

select * from DBA_Rules with (nolock)
select * from dba_tasks with (nolock)
select * from DBA_Schedules with (nolock)


*/

DECLARE @ruleId_g9 INT	,@taskId_g9 INT
DECLARE @ruleId_s4 INT	,@taskId_s4 INT

-- G9 - Check all today tickets running > 30 minutes must be settled
INSERT [dbo].[DBA_Rules] ([Name], [Description], [SeverityLevel]) 
VALUES (N'Check all today tickets running > 30 minutes must be settled', N'All today tickets running > 30 minutes must be settled', N'High')

SET @ruleId_g9 = SCOPE_IDENTITY()

INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (@ruleId_g9, N'EXEC dbo.DBA_Consistency_OtherSportsStatusChecking @ProductId = 0, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

SET @taskId_g9 = SCOPE_IDENTITY()

-- S4 - detect Yesterday pending  matches for Virtual sports events <> 'completed'
INSERT [dbo].[DBA_Rules] ([Name], [Description], [SeverityLevel]) 
VALUES (N'Detect Yesterday pending  matches for Virtual sports events', N'Yesterday pending  matches for Virtual sports events', N'High')
SET @ruleId_s4 = SCOPE_IDENTITY()


INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) VALUES (@ruleId_s4, N'EXEC dbo.DBA_Consistency_OtherSportsPendingMatchChecking @ProductId = 0, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')
SET @taskId_s4 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
DECLARE @ErrCode INT, @ErrMsg VARCHAR(100)
--Status checking - every 30p
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Check all today tickets running > 30 minutes must be settled'
 ,@TaskId = @taskId_g9
 ,@IsEnable  = 1
 ,@FrequenceType = 4 -- daily = 4, weekly = 8
 ,@FrequenceInterval = 1 -- every xx days
 ,@FrequenceSubDayType = 4 -- specified time: 1, second: 2, min: 4, hour: 8
 ,@FrequenceSubDayInterval = 30 -- specified time: 0; <> 0: every FrequenceSubDayType
 ,@ActiveStartDate = '2019-11-06' 
 ,@ActiveEndDate = NULL
 ,@ActiveStartTime  = '00:00'
 ,@ActiveEndTime = NULL
 ,@NotifyLevelEmail = 2
  --,@Emails = 'gary.vu@starixsoft.com,helen.do@starixsoft.com'
 ,@Emails = 'dbaadmin@starixsoft.com'
 ,@ErrCode  = @ErrCode OUTPUT
 ,@ErrMsg = @ErrMsg OUTPUT

SELECT 'Check all today tickets running > 30 minutes must be settled' AS RuleChecking, @ErrCode, @ErrMsg
 
-- Pending match checking - daily
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Detect Yesterday pending matches for Virtual sports events not completed yet'
 ,@TaskId = @taskId_s4
 ,@IsEnable  = 1
 ,@FrequenceType = 4 -- daily = 4, weekly = 8
 ,@FrequenceInterval = 1 -- every xx days
 ,@FrequenceSubDayType = 1 -- specified time: 1, second: 2, min: 4, hour: 8
 ,@FrequenceSubDayInterval = 0 -- specified time: 0; <> 0: every FrequenceSubDayType
 ,@ActiveStartDate = '2019-11-06' 
 ,@ActiveEndDate = NULL
 ,@ActiveStartTime  = '01:30'
 ,@ActiveEndTime = NULL
 ,@NotifyLevelEmail = 2
 --,@Emails = 'gary.vu@starixsoft.com,helen.do@starixsoft.com'
 ,@Emails = 'dbaadmin@starixsoft.com'
 ,@ErrCode  = @ErrCode OUTPUT
 ,@ErrMsg = @ErrMsg OUTPUT

SELECT 'Detect Yesterday pending matches for Virtual sports events not completed yet' AS RuleChecking,@ErrCode, @ErrMsg


