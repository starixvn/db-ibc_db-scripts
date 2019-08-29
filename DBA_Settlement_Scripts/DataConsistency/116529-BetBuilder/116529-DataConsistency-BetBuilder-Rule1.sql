/*
	Created: 20190717@Kathy
	Task: Check BetBuilder Data Consistency
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
	VALUES ('Check the consistency of results of selections', 'A selection of a market has the only one result', 'High')

SET @ruleId = SCOPE_IDENTITY()

-- Insert Task
INSERT INTO dbo.DBA_Tasks (RuleId, command) 
	VALUES (@ruleId, 'EXEC dbo.DBA_Consistency_BetBuilderResultChecking @Rule = ''SelectionResult'', @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT')

SET @taskId = SCOPE_IDENTITY()
SET @schedulename = 'Check the consistency of BetBuilder results'

-- Insert Schedule
EXEC dbo.DBA_Consistency_ScheduleIns @Name = @schedulename
 ,@TaskId = @taskId
 ,@IsEnable  = 1
 ,@FrequenceType = 4 -- daily = 4, weekly = 8
 ,@FrequenceInterval = 1 -- every xx days
 ,@FrequenceSubDayType = 8 -- specified time: 1, second: 2, min: 4, hour: 8
 ,@FrequenceSubDayInterval = 4 -- specified time: 0; <> 0: every FrequenceSubDayType
 ,@ActiveStartDate = '2019-08-29' 
 ,@ActiveEndDate = NULL
 ,@ActiveStartTime  = '00:00'
 ,@ActiveEndTime = NULL
 ,@NotifyLevelEmail = 2
 ,@Emails = @Emails
 ,@ErrCode  = @ErrCode OUTPUT
 ,@ErrMsg = @ErrMsg OUTPUT

SELECT @ErrCode, @ErrMsg

GO