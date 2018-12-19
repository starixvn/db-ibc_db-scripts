/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_DBA_Schedules
	(
	ScheduleId int NOT NULL,
	Name nvarchar(128) NULL,
	TaskId int NULL,
	IsEnable bit NULL,
	FrequenceType int NULL,
	FrequenceInterval int NULL,
	FrequenceSubDayType int NULL,
	FrequenceSubdayInterval int NULL,
	ActiveStartDate datetime NULL,
	ActiveEndDate datetime NULL,
	ActiveStartTime time(7) NULL,
	ActiveEndTime time(7) NULL,
	DateCreated datetime NULL,
	DateModified datetime NULL,
	NotifyLevelEmail int NULL,
	Emails varchar(MAX) NULL
	)  ON bodb_Consistency_INDEX
	 TEXTIMAGE_ON bodb_Consistency_DATA
GO
ALTER TABLE dbo.Tmp_DBA_Schedules SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.DBA_Schedules)
	 EXEC('INSERT INTO dbo.Tmp_DBA_Schedules (ScheduleId, Name, TaskId, IsEnable, FrequenceType, FrequenceInterval, FrequenceSubDayType, FrequenceSubdayInterval, ActiveStartDate, ActiveEndDate, ActiveStartTime, ActiveEndTime, DateCreated, DateModified, NotifyLevelEmail, Emails)
		SELECT ScheduleId, Name, TaskId, IsEnable, FrequenceType, FrequenceInterval, FrequenceSubDayType, FrequenceSubdayInterval, ActiveStartDate, ActiveEndDate, ActiveStartTime, ActiveEndTime, DateCreated, DateModified, NotifyLevelEmail, Emails FROM dbo.DBA_Schedules WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.DBA_Schedules
GO
EXECUTE sp_rename N'dbo.Tmp_DBA_Schedules', N'DBA_Schedules', 'OBJECT' 
GO
ALTER TABLE dbo.DBA_Schedules ADD CONSTRAINT
	PK_DBA_Schedules_ScheduleId PRIMARY KEY CLUSTERED 
	(
	ScheduleId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON bodb_Consistency_INDEX

GO
CREATE TRIGGER [dbo].[Trg_DBA_Consistency_SchedulesDel]
   ON  dbo.DBA_Schedules
   AFTER DELETE
AS 
/*
	Created: 20180808@Kathy
	Task: Data consistency
	DB: DBTP/bodb_Consistency

	Revisions: 
		- 20180808@Kathy: initial SP
	
	Param's Expanation:
*/
BEGIN
	SET NOCOUNT ON;
	
	DECLARE	@currentdate	DATETIME 
			,@currenttime	TIME
	
	SET @currentdate = GETDATE()
	SET @currenttime = CONVERT(TIME(0), @currentdate)

	DELETE j
	FROM	dbo.DBA_JobActivity j
		INNER JOIN DELETED d
			ON j.ScheduleId = d.ScheduleId	

END
GO
CREATE TRIGGER [dbo].[Trg_DBA_Consistency_SchedulesIns]
   ON  dbo.DBA_Schedules
   AFTER INSERT
AS 
/*
	Created: 20180808@Kathy
	Task: Data consistency
	DB: DBTP/bodb_Consistency

	Revisions: 
		- 20180808@Kathy: initial SP
	
	Param's Expanation:
*/
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @curr_day DATETIME
			,@curr_time TIME
			,@curr_datetime DATETIME
			,@maxtime TIME
			,@IsEnable		BIT
		

	SET @curr_datetime = GETDATE()
	SET @curr_day = CONVERT(DATE, @curr_datetime)
	SET @curr_time = CONVERT(TIME(0), @curr_datetime)	
	SET @maxtime = '23:59:59'
		
	INSERT INTO dbo.DBA_JobActivity(
		ScheduleId
		,StatusId
		,StartExecutionDate
		,LastExecutedDate
		,StopExecutionDate
		,NextExecutedDate
	)
	SELECT 
			i.Scheduleid
			,0 StatusId
			,NULL StartExecutionDate
			,NULL LastExecutedDate
			,NULL StopExecutionDate		
			,CASE
					WHEN i.FrequenceType = 4 -- daily
						THEN CASE
								WHEN @curr_datetime <= a.ActivateDateTime THEN a.ActivateDateTime
								WHEN m.actual_day_diff % i.FrequenceInterval = 0 -- run on this day
									THEN CASE
											WHEN i.FrequenceSubDayType = 1 
												THEN CASE
														WHEN @curr_time <= i.ActiveStartTime THEN DATEADD(DAY,m.actual_day_diff,a.ActivateDateTime)
														ELSE s.nextschedule_day
														END
											WHEN @curr_time < i.ActiveStartTime AND DAY(@curr_datetime) = DAY(s.nextschedule_time)  -- run on this day but it's not time to run
												THEN DATEADD(DAY,m.actual_day_diff,a.ActivateDateTime)
											WHEN @curr_time BETWEEN i.ActiveStartTime AND a.ActiveEndTime -- run on this day, after the active time 
												THEN CASE 
														WHEN s.nextschedule_time > @curr_day + a.ActiveEndTime THEN s.nextschedule_day
														ELSE s.nextschedule_time
													END
											ELSE s.nextschedule_day
											END
								ELSE s.nextschedule_day   -- the day is gone --> move on the next schedule
								END 
					WHEN i.FrequenceType = 8 -- weekly
						THEN CASE
								WHEN @curr_datetime <= a.ActivateDateTime THEN s.nextschedule_day
								WHEN i.FrequenceInterval & POWER(2,m.dbit)  > 0  -- run on this day
									THEN CASE
											WHEN i.FrequenceSubDayType = 1
												THEN CASE
														WHEN @curr_time <= i.ActiveStartTime THEN DATEADD(DAY,m.actual_day_diff,a.ActivateDateTime)
														ELSE s.nextschedule_day
														END
											WHEN @curr_time < i.ActiveStartTime AND DAY(@curr_datetime) = DAY(s.nextschedule_time)  -- run on this day but it's not time to run
												THEN DATEADD(DAY,m.actual_day_diff,a.ActivateDateTime)
											WHEN @curr_time BETWEEN i.ActiveStartTime AND a.ActiveEndTime -- run on this day, after the active time 
												THEN CASE 
														WHEN s.nextschedule_time > @curr_day + a.ActiveEndTime THEN s.nextschedule_day
														ELSE s.nextschedule_time
													END
											ELSE s.nextschedule_day
											END
								ELSE s.nextschedule_day -- the day is gone --> move on the next schedule
								END
					ELSE NULL
				END next_schedule
	FROM	INSERTED i
		CROSS APPLY (
			SELECT	CAST(i.ActiveStartDate AS DATETIME) + CAST(i.ActiveStartTime AS DATETIME) AS ActivateDateTime
					,CAST(i.ActiveEndDate AS DATETIME) + CAST(ISNULL(i.ActiveEndTime,@maxtime) AS DATETIME) AS ActivateEndDateTime
					,ISNULL(i.ActiveEndTime, @maxtime) AS ActiveEndTime
		)a
			CROSS APPLY (
			SELECT	CASE WHEN @curr_datetime <= a.ActivateDateTime THEN DATEADD(DAY,-1,a.ActivateDateTime) ELSE @curr_datetime END AS startdate
		)sd
		CROSS APPLY (
				SELECT	CAST(DATEDIFF(MILLISECOND,a.ActivateDateTime, sd.startdate) AS FLOAT) AS ms
						,DATEDIFF(DAY, a.ActivateDateTime, sd.startdate) AS actual_day_diff					
						,CASE 
							WHEN DATENAME(dw,sd.startdate) = 'Sunday' THEN 0
							WHEN DATENAME(dw,sd.startdate) = 'Monday' THEN 1
							WHEN DATENAME(dw,sd.startdate) = 'Tuesday' THEN 2
							WHEN DATENAME(dw,sd.startdate) = 'Wednesday' THEN 3
							WHEN DATENAME(dw,sd.startdate) = 'Thursday' THEN 4
							WHEN DATENAME(dw,sd.startdate) = 'Friday' THEN 5
							WHEN DATENAME(dw,sd.startdate) = 'Saturday' THEN 6
							ELSE NULL
							END AS dbit	
										
		)m
			OUTER APPLY (
				SELECT	value AS nextdayofSchedule
				FROM	dbo.f_DBA_Consistency_NumberNextDaySel(i.FrequenceInterval,m.dbit) 
		)w
			CROSS APPLY (
				SELECT	CASE 
							WHEN i.ActiveEndDate IS NULL THEN nextschedule_day
							WHEN nextschedule_day > a.ActivateEndDateTime THEN NULL
							ELSE nextschedule_day
						END AS nextschedule_day
						,CASE 
							WHEN i.ActiveEndDate IS NULL THEN nextschedule_time
							WHEN nextschedule_time > a.ActivateEndDateTime THEN NULL
							ELSE nextschedule_time
						END AS nextschedule_time
				FROM	dbo.f_DBA_Consistency_NextScheduleDaySel(m.ms, i.FrequenceSubdayInterval, i.FrequenceSubDayType, i.FrequenceInterval, i.FrequenceType
																	,a.ActivateDateTime, m.actual_day_diff, w.nextdayofSchedule)
		)s	

END
GO
/*<info serverAlias="DBTP-bodb_Consistency" executers="" viewers="vnteam" isFunction="0"></info>*/
CREATE TRIGGER [dbo].[Trg_DBA_Consistency_SchedulesUpd]
   ON  dbo.DBA_Schedules
   AFTER UPDATE
AS 
/*
	Created: 20180808@Kathy
	Task: Data consistency
	DB: DBTP/bodb_Consistency

	Revisions: 
		- 20180808@Kathy: initial SP
	
	Param's Expanation:
*/
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @curr_day DATETIME
			,@curr_time TIME
			,@curr_datetime DATETIME
			,@maxtime TIME
			,@IsEnable		BIT
		

	SET @curr_datetime = GETDATE()
	SET @curr_day = CONVERT(DATE, @curr_datetime)
	SET @curr_time = CONVERT(TIME(0), @curr_datetime)	
	SET @maxtime = '23:59:59'
	
	UPDATE  j
		SET NextExecutedDate = CASE
					WHEN i.FrequenceType = 4 -- daily
						THEN CASE
								WHEN @curr_datetime <= a.ActivateDateTime THEN a.ActivateDateTime
								WHEN m.actual_day_diff % i.FrequenceInterval = 0 -- run on this day
									THEN CASE
											WHEN i.FrequenceSubDayType = 1 
												THEN CASE
														WHEN @curr_time <= i.ActiveStartTime THEN DATEADD(DAY,m.actual_day_diff,a.ActivateDateTime)
														ELSE s.nextschedule_day
														END
											WHEN @curr_time < i.ActiveStartTime AND DAY(@curr_datetime) = DAY(s.nextschedule_time)  -- run on this day but it's not time to run
												THEN DATEADD(DAY,m.actual_day_diff,a.ActivateDateTime)
											WHEN @curr_time BETWEEN i.ActiveStartTime AND a.ActiveEndTime -- run on this day, after the active time 
												THEN CASE 
														WHEN s.nextschedule_time > @curr_day + a.ActiveEndTime THEN s.nextschedule_day
														ELSE s.nextschedule_time
													END
											ELSE s.nextschedule_day
											END
								ELSE s.nextschedule_day   -- the day is gone --> move on the next schedule
								END 
					WHEN i.FrequenceType = 8 -- weekly
						THEN CASE
								WHEN @curr_datetime <= a.ActivateDateTime THEN s.nextschedule_day
								WHEN i.FrequenceInterval & POWER(2,m.dbit)  > 0  -- run on this day
									THEN CASE
											WHEN i.FrequenceSubDayType = 1
												THEN CASE
														WHEN @curr_time <= i.ActiveStartTime THEN DATEADD(DAY,m.actual_day_diff,a.ActivateDateTime)
														ELSE s.nextschedule_day
														END
											WHEN @curr_time < i.ActiveStartTime AND DAY(@curr_datetime) = DAY(s.nextschedule_time)  -- run on this day but it's not time to run
												THEN DATEADD(DAY,m.actual_day_diff,a.ActivateDateTime)
											WHEN @curr_time BETWEEN i.ActiveStartTime AND a.ActiveEndTime -- run on this day, after the active time 
												THEN CASE 
														WHEN s.nextschedule_time > @curr_day + a.ActiveEndTime THEN s.nextschedule_day
														ELSE s.nextschedule_time
													END
											ELSE s.nextschedule_day
											END
								ELSE s.nextschedule_day -- the day is gone --> move on the next schedule
								END
					ELSE NULL
				END
	FROM	 INSERTED  i
		INNER JOIN dbo.DBA_JobActivity j		
			ON j.ScheduleId = i.ScheduleId
		CROSS APPLY (
			SELECT	CAST(i.ActiveStartDate AS DATETIME) + CAST(i.ActiveStartTime AS DATETIME) AS ActivateDateTime
					,CAST(i.ActiveEndDate AS DATETIME) + CAST(ISNULL(i.ActiveEndTime,@maxtime) AS DATETIME) AS ActivateEndDateTime
					,ISNULL(i.ActiveEndTime, @maxtime) AS ActiveEndTime
		)a
			CROSS APPLY (
			SELECT	CASE WHEN @curr_datetime <= a.ActivateDateTime THEN DATEADD(DAY,-1,a.ActivateDateTime) ELSE @curr_datetime END AS startdate
		)sd
		CROSS APPLY (
				SELECT	CAST(DATEDIFF(MILLISECOND,a.ActivateDateTime, sd.startdate) AS FLOAT) AS ms
						,DATEDIFF(DAY, a.ActivateDateTime, sd.startdate) AS actual_day_diff					
						,CASE 
							WHEN DATENAME(dw,sd.startdate) = 'Sunday' THEN 0
							WHEN DATENAME(dw,sd.startdate) = 'Monday' THEN 1
							WHEN DATENAME(dw,sd.startdate) = 'Tuesday' THEN 2
							WHEN DATENAME(dw,sd.startdate) = 'Wednesday' THEN 3
							WHEN DATENAME(dw,sd.startdate) = 'Thursday' THEN 4
							WHEN DATENAME(dw,sd.startdate) = 'Friday' THEN 5
							WHEN DATENAME(dw,sd.startdate) = 'Saturday' THEN 6
							ELSE NULL
							END AS dbit	
										
		)m
			OUTER APPLY (
				SELECT	value AS nextdayofSchedule
				FROM	dbo.f_DBA_Consistency_NumberNextDaySel(i.FrequenceInterval,m.dbit) 
		)w
			CROSS APPLY (
				SELECT	CASE 
							WHEN i.ActiveEndDate IS NULL THEN nextschedule_day
							WHEN nextschedule_day > a.ActivateEndDateTime THEN NULL
							ELSE nextschedule_day
						END AS nextschedule_day
						,CASE 
							WHEN i.ActiveEndDate IS NULL THEN nextschedule_time
							WHEN nextschedule_time > a.ActivateEndDateTime THEN NULL
							ELSE nextschedule_time
						END AS nextschedule_time
				FROM	dbo.f_DBA_Consistency_NextScheduleDaySel(m.ms, i.FrequenceSubdayInterval, i.FrequenceSubDayType, i.FrequenceInterval, i.FrequenceType
																	,a.ActivateDateTime, m.actual_day_diff, w.nextdayofSchedule)
		)s	
	WHERE	i.IsEnable = 1
	
	UPDATE j
		SET NextExecutedDate = NULL 
	FROM	dbo.DBA_JobActivity j
		INNER JOIN INSERTED i
			ON j.ScheduleId = i.ScheduleId
	WHERE	i.IsEnable = 0

END
GO
COMMIT