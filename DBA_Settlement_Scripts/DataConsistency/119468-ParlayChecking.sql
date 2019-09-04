/*
	Created: 20190904@Kathy
	Task: Check duplicate refno of parlay ticket [Redmine:#119468]
	DB: DBCONSISTENCY/bodb_Consistency
*/
USE bodb_Consistency
GO

DECLARE @ruleId INT
		,@taskId INT
		,@schedulename VARCHAR(200)
		,@Emails VARCHAR(MAX)

		,@ErrCode INT
		,@ErrMsg VARCHAR(100)

SET @Emails = 'dbaadmin@starixsoft.com'

-- Insert Rule
INSERT INTO dbo.DBA_Rules (Name, Description, SeverityLevel) 
	VALUES ('Check refno of parlay ticket', 'Check duplicated refno in bettrans if there are more than 1 ticket in bettrans with the same Refno', 'High')

SET @ruleId = SCOPE_IDENTITY()

-- Insert Task
INSERT INTO dbo.DBA_Tasks (RuleId, command) 
	VALUES (@ruleId, 'EXEC dbo.DBA_Consistency_ParlayDuplicatedRefnoChecking @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT')

SET @taskId = SCOPE_IDENTITY()
SET @schedulename = 'Check refno of parlay ticket'

-- Insert Schedule
EXEC dbo.DBA_Consistency_ScheduleIns @Name = @schedulename
 ,@TaskId = @taskId
 ,@IsEnable  = 1
 ,@FrequenceType = 4 -- daily = 4, weekly = 8
 ,@FrequenceInterval = 1 -- every xx days
 ,@FrequenceSubDayType = 4 -- specified time: 1, second: 2, min: 4, hour: 8
 ,@FrequenceSubDayInterval = 10 -- specified time: 0; <> 0: every FrequenceSubDayType
 ,@ActiveStartDate = '2019-09-04' 
 ,@ActiveEndDate = NULL
 ,@ActiveStartTime  = '00:00'
 ,@ActiveEndTime = NULL
 ,@NotifyLevelEmail = 2
 ,@Emails = @Emails
 ,@ErrCode  = @ErrCode OUTPUT
 ,@ErrMsg = @ErrMsg OUTPUT

SELECT @ErrCode, @ErrMsg

GO