/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20220919@Sol
	DB: DBLIC-bodb_LicenseeReport
	Task: gen data - [Redmine: #177979]
*/

--## RUN IN DB052 ONLY ##--

USE bodb_PlaytechCS

GO 

---insert data into Product3rd_ImportQueue table - db052
SET IDENTITY_INSERT bodb_PlaytechCS.dbo.Product3rd_ImportQueue ON

;WITH rs
AS (
	SELECT QueueId,
		CheckInTime,
		FinishedTime,
		LicenseeName,
		ProductID,
		XmlData,
		Winlostdate,
		LogDesc,
		isSummarized,
		JobType,
		StartDate,
		EndDate,
		IsForceUpdate
	FROM OPENQUERY(DB053, N'\
			SELECT QueueId
				,CheckInTime
				,FinishedTime
				,LicenseeName
				,ProductID
				,CONVERT(NVARCHAR(MAX), XmlData) XmlData
				,Winlostdate
				,LogDesc
				,isSummarized
				,JobType
				,StartDate
				,EndDate
				,IsForceUpdate
			from bodb_PlaytechCS.dbo.Product3rd_ImportQueue WITH (NOLOCK)
			where QueueId IN 
				(
					831728
					,831729
					,831730
					,831731
					,831732)
			') AS t
	)
INSERT INTO bodb_PlaytechCS.dbo.Product3rd_ImportQueue (
	QueueID,
	CheckInTime,
	FinishedTime,
	LicenseeName,
	ProductID,
	XmlData,
	Winlostdate,
	LogDesc,
	isSummarized,
	JobType,
	StartDate,
	EndDate,
	IsForceUpdate
	)
SELECT t.NewQueueId,
	CheckInTime,
	FinishedTime,
	LicenseeName,
	ProductID,
	XmlData,
	Winlostdate,
	LogDesc,
	isSummarized,
	JobType,
	StartDate,
	EndDate,
	IsForceUpdate
FROM rs
CROSS APPLY (
	SELECT t.NewQueueId
	FROM (
		VALUES (831728,174970),
			(831729,174971),
			(831730,174972),
			(831731,174973),
			(831732,174974)
		) AS t(OldQueueId, NewQueueId)
	WHERE t.OldQueueId = rs.QueueID
	) t

SET IDENTITY_INSERT bodb_PlaytechCS.dbo.Product3rd_ImportQueue OFF

GO

---run sp to read data from bodb_PlaytechCS.dbo.Product3rd_ImportQueue
USE bodb_3rdProduct

GO 

DECLARE @errCode INT = 0
		,@errMsg NVARCHAR(2000) = ''
EXEC bodb_3rdProduct.[dbo].[Task_Product3rd_ImportQueue_ProcessData]
	@QueueIDInput = 174970,
	@ProductID = 31,
	@ErrCode = @errCode OUTPUT,
	@ErrMsg	= @errMsg OUTPUT

GO

DECLARE @errCode INT = 0
		,@errMsg NVARCHAR(2000) = ''
EXEC bodb_3rdProduct.[dbo].[Task_Product3rd_ImportQueue_ProcessData]
	@QueueIDInput = 174971,
	@ProductID = 31,
	@ErrCode = @errCode OUTPUT,
	@ErrMsg	= @errMsg OUTPUT

GO

DECLARE @errCode INT = 0
		,@errMsg NVARCHAR(2000) = ''
EXEC bodb_3rdProduct.[dbo].[Task_Product3rd_ImportQueue_ProcessData]
	@QueueIDInput = 174972,
	@ProductID = 31,
	@ErrCode = @errCode OUTPUT,
	@ErrMsg	= @errMsg OUTPUT

GO

DECLARE @errCode INT = 0
		,@errMsg NVARCHAR(2000) = ''
EXEC bodb_3rdProduct.[dbo].[Task_Product3rd_ImportQueue_ProcessData]
	@QueueIDInput = 174973,
	@ProductID = 31,
	@ErrCode = @errCode OUTPUT,
	@ErrMsg	= @errMsg OUTPUT

GO

DECLARE @errCode INT = 0
		,@errMsg NVARCHAR(2000) = ''
EXEC bodb_3rdProduct.[dbo].[Task_Product3rd_ImportQueue_ProcessData]
	@QueueIDInput = 174974,
	@ProductID = 31,
	@ErrCode = @errCode OUTPUT,
	@ErrMsg	= @errMsg OUTPUT

GO