/*
	Created: 20190717@Kathy
	Task: Check BetBuilder Data Consistency
	DB: DBCONSISTENCY/bodb_Consistency
*/
USE bodb_Consistency
GO

DECLARE @taskId INT
		,@schedulename VARCHAR(200)
		,@Emails VARCHAR(MAX)

		,@ErrCode INT
		,@ErrMsg VARCHAR(100)

SET @Emails = 'kathy.nguyen@starixsoft.com'

-- check discount
BEGIN
	-- Insert Task
	INSERT INTO dbo.DBA_Tasks (RuleId, command) 
		VALUES (1, 'EXEC dbo.DBA_Consistency_DiscountChecking @ProductId = 1, @Bettype = 38, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

	SET @taskId = SCOPE_IDENTITY()
	SET @schedulename = 'Check Discount value'

	EXEC dbo.DBA_Consistency_ScheduleIns @Name = @schedulename
	 ,@TaskId = @taskId
	 ,@IsEnable  = 1
	 ,@FrequenceType = 4 -- daily = 4, weekly = 8
	 ,@FrequenceInterval = 1 -- every xx days
	 ,@FrequenceSubDayType = 8 -- specified time: 1, second: 2, min: 4, hour: 8
	 ,@FrequenceSubDayInterval = 1 -- specified time: 0; <> 0: every FrequenceSubDayType
	 ,@ActiveStartDate = '2019-07-25' 
	 ,@ActiveEndDate = NULL
	 ,@ActiveStartTime  = '00:00'
	 ,@ActiveEndTime = NULL
	 ,@NotifyLevelEmail = 2
	 ,@Emails = @Emails
	 ,@ErrCode  = @ErrCode OUTPUT
	 ,@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg
END

-- check PT
BEGIN
	INSERT INTO dbo.DBA_Tasks (RuleId, command) 
		VALUES (2, 'EXEC dbo.DBA_Consistency_PTChecking @ProductId = 1, @Bettype = 38, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

	SET @taskId = SCOPE_IDENTITY()
	SET @schedulename = 'Check PT value'

	EXEC dbo.DBA_Consistency_ScheduleIns @Name = @schedulename
	 ,@TaskId = @taskId
	 ,@IsEnable  = 1
	 ,@FrequenceType = 4 -- daily = 4, weekly = 8
	 ,@FrequenceInterval = 1 -- every xx days
	 ,@FrequenceSubDayType = 8 -- specified time: 1, second: 2, min: 4, hour: 8
	 ,@FrequenceSubDayInterval = 1 -- specified time: 0; <> 0: every FrequenceSubDayType
	 ,@ActiveStartDate = '2019-07-25' 
	 ,@ActiveEndDate = NULL
	 ,@ActiveStartTime  = '00:00'
	 ,@ActiveEndTime = NULL
	 ,@NotifyLevelEmail = 2
	 ,@Emails = @Emails
	 ,@ErrCode  = @ErrCode OUTPUT
	 ,@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg

END

-- check Stake
BEGIN
	INSERT INTO dbo.DBA_Tasks (RuleId, command) 
		VALUES (3, 'EXEC dbo.DBA_Consistency_StakeChecking @ProductId = 1, @Bettype = 38, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT ')

	SET @taskId = SCOPE_IDENTITY()
	SET @schedulename = 'Check Stake value'

	EXEC dbo.DBA_Consistency_ScheduleIns @Name = @schedulename
	 ,@TaskId = @taskId
	 ,@IsEnable  = 1
	 ,@FrequenceType = 4 -- daily = 4, weekly = 8
	 ,@FrequenceInterval = 1 -- every xx days
	 ,@FrequenceSubDayType = 8 -- specified time: 1, second: 2, min: 4, hour: 8
	 ,@FrequenceSubDayInterval = 1 -- specified time: 0; <> 0: every FrequenceSubDayType
	 ,@ActiveStartDate = '2019-07-25' 
	 ,@ActiveEndDate = NULL
	 ,@ActiveStartTime  = '00:00'
	 ,@ActiveEndTime = NULL
	 ,@NotifyLevelEmail = 2
	 ,@Emails = @Emails
	 ,@ErrCode  = @ErrCode OUTPUT
	 ,@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg

END

-- check IP
BEGIN
	INSERT INTO dbo.DBA_Tasks (RuleId, command) 
		VALUES (4, 'EXEC dbo.DBA_Consistency_IPChecking @ProductId = 1, @Bettype = 38, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT  ')

	SET @taskId = SCOPE_IDENTITY()
	SET @schedulename = 'Check Valid IP'

	EXEC dbo.DBA_Consistency_ScheduleIns @Name = @schedulename
	 ,@TaskId = @taskId
	 ,@IsEnable  = 1
	 ,@FrequenceType = 4 -- daily = 4, weekly = 8
	 ,@FrequenceInterval = 1 -- every xx days
	 ,@FrequenceSubDayType = 8 -- specified time: 1, second: 2, min: 4, hour: 8
	 ,@FrequenceSubDayInterval = 1 -- specified time: 0; <> 0: every FrequenceSubDayType
	 ,@ActiveStartDate = '2019-07-25' 
	 ,@ActiveEndDate = NULL
	 ,@ActiveStartTime  = '00:00'
	 ,@ActiveEndTime = NULL
	 ,@NotifyLevelEmail = 2
	 ,@Emails = @Emails
	 ,@ErrCode  = @ErrCode OUTPUT
	 ,@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg

END


-- check yesterday ticket
BEGIN
	INSERT INTO dbo.DBA_Tasks (RuleId, command) 
		VALUES (5, 'EXEC dbo.DBA_Consistency_StatusChecking @ProductId = 1, @Bettype = 38, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT, @SampleData = @SampleData OUTPUT   ')

	SET @taskId = SCOPE_IDENTITY()
	SET @schedulename = 'Check all yesterday tickets must be settled'

	EXEC dbo.DBA_Consistency_ScheduleIns @Name = @schedulename
	 ,@TaskId = @taskId
	 ,@IsEnable  = 1
	 ,@FrequenceType = 4 -- daily = 4, weekly = 8
	 ,@FrequenceInterval = 1 -- every xx days
	 ,@FrequenceSubDayType = 1 -- specified time: 1, second: 2, min: 4, hour: 8
	 ,@FrequenceSubDayInterval = 0 -- specified time: 0; <> 0: every FrequenceSubDayType
	 ,@ActiveStartDate = '2019-07-25' 
	 ,@ActiveEndDate = NULL
	 ,@ActiveStartTime  = '01:30'
	 ,@ActiveEndTime = NULL
	 ,@NotifyLevelEmail = 2
	 ,@Emails = @Emails
	 ,@ErrCode  = @ErrCode OUTPUT
	 ,@ErrMsg = @ErrMsg OUTPUT

	SELECT @ErrCode, @ErrMsg

END
