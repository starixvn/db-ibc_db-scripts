/*
	Created: 20200326@Max
	Task: New Data Consistency Rule for Abnormal Parlay Ticket [Redmine: #130644]
	DB: DBCONSISTENCY/bodb_Consistency

	Rule: 28 (daily every 5 min) - Not allow parlay ticket that have more than 2 sub selection which are on the same match

*/
USE bodb_Consistency
GO

DECLARE @ruleId_s28 INT	,@taskId_s28 INT

-- S28 - Check actualstake = stake * 5
INSERT [dbo].[DBA_Rules] ([Name], [Description], [SeverityLevel]) 
VALUES (N'Not allow parlay ticket that have more than 2 sub selection which are on the same match'
	, N'Not allow parlay ticket that have more than 2 sub selection which are on the same match', N'High')

SET @ruleId_s28 = SCOPE_IDENTITY()

INSERT [dbo].[DBA_Tasks] ([RuleId], [command]) 
VALUES (@ruleId_s28
	, N'EXEC dbo.DBA_Consistency_ParlayDuplicatedSubTicketChecking @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT  ')

SET @taskId_s28 = SCOPE_IDENTITY()

--------- SCHEDULE ---------------
DECLARE @ErrCode INT, @ErrMsg VARCHAR(100)
-- Stake, Actualstake checking - daily at 00:15
EXEC dbo.DBA_Consistency_ScheduleIns @Name = 'Not allow parlay ticket that have more than 2 sub selection which are on the same match'
 ,@TaskId = @taskId_s28
 ,@IsEnable  = 1
 ,@FrequenceType = 4 -- daily = 4, weekly = 8
 ,@FrequenceInterval = 1 -- every xx days
 ,@FrequenceSubDayType = 4 -- specified time: 1, second: 2, min: 4, hour: 8
 ,@FrequenceSubDayInterval = 5 -- specified time: 0; <> 0: every FrequenceSubDayType
 ,@ActiveStartDate = '2020-03-26' 
 ,@ActiveEndDate = NULL
 ,@ActiveStartTime  = '00:00'
 ,@ActiveEndTime = NULL
 ,@NotifyLevelEmail = 2
 ,@Emails = 'max.tran@starixsoft.com'--,helen.do@starixsoft.com'
 --,@Emails = 'dbaadmin@starixsoft.com'
 ,@ErrCode  = @ErrCode OUTPUT
 ,@ErrMsg = @ErrMsg OUTPUT

SELECT 'Not allow parlay ticket that have more than 2 sub selection which are on the same match' AS RuleChecking, @ErrCode, @ErrMsg

GO