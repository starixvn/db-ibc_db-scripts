/*
	Created: 20191125@Max
	Task: New rule of Allbet Bull Game - [Redmine:#124351]
	DB: DBCONSISTENCY-bodb_Consistency
Rule: 
Rule
23 (daily 00:15) - With betchoice Double, check actual_stake = stake * 5

*/
USE bodb_Consistency
GO

DECLARE @ruleId_s23 INT	,@taskId_s23 INT

-- S23 - Check actualstake = stake * 5
INSERT [dbo].[DBA_Rules] ([Name], [Description], [SeverityLevel]) 
VALUES (N'With betchoice Double, check actual_stake = stake * 5', N'With betchoice Double, check actual_stake = stake * 5', N'High')

SET @ruleId_s23 = SCOPE_IDENTITY()

INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (@ruleId_s23, N'EXEC dbo.DBA_Consistency_SpecificRulesChecking @ProductId = 211, @Rule = ''BullGame_2407'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT  ')

SET @taskId_s23 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
DECLARE @ErrCode INT, @ErrMsg VARCHAR(100)
-- Stake, Actualstake checking - daily at 00:15
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'With betchoice Double, check actual_stake = stake * 5'
 ,@TaskId = @taskId_s23
 ,@IsEnable  = 1
 ,@FrequenceType = 4 -- daily = 4, weekly = 8
 ,@FrequenceInterval = 1 -- every xx days
 ,@FrequenceSubDayType = 1 -- specified time: 1, second: 2, min: 4, hour: 8
 ,@FrequenceSubDayInterval = 0 -- specified time: 0; <> 0: every FrequenceSubDayType
 ,@ActiveStartDate = '2019-12-09' 
 ,@ActiveEndDate = NULL
 ,@ActiveStartTime  = '00:15'
 ,@ActiveEndTime = NULL
 ,@NotifyLevelEmail = 2
  --,@Emails = 'max.tran@starixsoft.com,helen.do@starixsoft.com'
 ,@Emails = 'dbaadmin@starixsoft.com'
 ,@ErrCode  = @ErrCode OUTPUT
 ,@ErrMsg = @ErrMsg OUTPUT

SELECT 'With betchoice Double, check actual_stake = stake * 5' AS RuleChecking, @ErrCode, @ErrMsg



