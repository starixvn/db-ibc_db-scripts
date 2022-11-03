/*<info serverAlias="DBPTCS-bodb_PlaytechCS"></info>*/
/*
	Created: 20220919@Sol
	DB: DBPTCS-bodb_PlaytechCS
	Task: Sync data from DB53 to DB052 for table Product3rd_ImportQueue - [Redmine: #177979]
*/

--## RUN IN DB052 ONLY ##--

USE bodb_PlaytechCS

GO

DECLARE 
	@rowPerBatch INT = 5,
	@fromQueueId INT = 825911,
	@toQueueId INT = 831732,
	@batchFromQueueId INT = 0,
	@batchToQueueId INT = 0

DECLARE 
	@queryMatch NVARCHAR(MAX)
	,@execSql NVARCHAR(MAX)

---variable table to contain processing queue ID
DECLARE @runningQueueId TABLE (QueueID BIGINT)

---temp table to loop through
CREATE TABLE #QueueIdList (QueueID BIGINT)

---get queueid list to loop
;WITH t
AS (
	SELECT ID
	FROM (
			VALUES (@fromQueueId)
		) t(id)
	)
	,rs
AS (
		SELECT ID
		FROM t
		UNION ALL
		SELECT rs.id + 1 AS id
		FROM rs
			INNER JOIN t ON rs.id + 1 > t.id
		WHERE rs.id < @toQueueId
	)
INSERT INTO #QueueIdList (QueueID)
SELECT *
FROM rs
OPTION (MAXRECURSION 0)

---temp table from db053
CREATE TABLE #db053_ImportQueue 
(
	QueueID BIGINT PRIMARY KEY
	,CheckInTime DATETIME
	,FinishedTime DATETIME
	,LicenseeName VARCHAR(200)
	,ProductID INT
	,XmlData XML
	,Winlostdate DATE
	,LogDesc VARCHAR(200)
	,isSummarized BIT
	,JobType TINYINT
	,StartDate DATETIME
	,EndDate DATETIME
	,IsForceUpdate BIT
)

---loop and copy data to main table in db052
WHILE EXISTS (
		SELECT 1
		FROM #QueueIdList
		)
BEGIN
	--cleare all data and prepare to run
	DELETE
	FROM @runningQueueId

	TRUNCATE TABLE #db053_ImportQueue

	DELETE TOP (@rowPerBatch)
	FROM #QueueIdList
	OUTPUT deleted.QueueID
	INTO @runningQueueId(QueueID)

	--get min/max queueid from batch
	SELECT @batchFromQueueId = MIN(r.QueueID), @batchToQueueId = MAX(r.QueueId) 
	FROM @runningQueueId r

	---insert to temp table
	SET @queryMatch = '	select QueueID
						,CheckInTime
						,FinishedTime
						,LicenseeName
						,ProductID
						,CONVERT(NVARCHAR(MAX), XmlData)
						,Winlostdate
						,LogDesc
						,isSummarized
						,JobType
						,StartDate
						,EndDate
						,IsForceUpdate
						from bodb_PlaytechCS.dbo.Product3rd_ImportQueue WITH (NOLOCK)
						WHERE ProductID = 31
							and queueid between @batchFromQueueId and @batchToQueueId'
	SET @execSql = 'DB053.bodb02.dbo.sp_executesql @queryMatch,N''@batchFromQueueId INT, @batchToQueueId INT'', @batchFromQueueId, @batchToQueueId'


	---insert data into temp table to process queue
	INSERT INTO #db053_ImportQueue
	EXECUTE sys.sp_executesql @execSql ,N'@queryMatch NVARCHAR(MAX),@batchFromQueueId INT, @batchToQueueId INT',@queryMatch, @batchFromQueueId, @batchToQueueId


	---insert data into Product3rd_ImportQueue table - db052
	SET IDENTITY_INSERT bodb_PlaytechCS.dbo.Product3rd_ImportQueue ON

	INSERT INTO bodb_PlaytechCS.dbo.Product3rd_ImportQueue
	(	
		QueueID 
		,CheckInTime
		,FinishedTime
		,LicenseeName
		,ProductID
		,XmlData
		,Winlostdate
		,LogDesc
		,isSummarized
		,JobType
		,StartDate
		,EndDate
		,IsForceUpdate
	)
	SELECT QueueID 
		,CheckInTime
		,FinishedTime
		,LicenseeName
		,ProductID
		,XmlData
		,Winlostdate
		,LogDesc
		,isSummarized
		,JobType
		,StartDate
		,EndDate
		,IsForceUpdate
	FROM #db053_ImportQueue q
	WHERE q.QueueID IN (
			SELECT QueueID
			FROM @runningQueueId
			)
			AND NOT EXISTS (SELECT 1 FROM bodb_PlaytechCS.dbo.Product3rd_ImportQueue q_db052 WITH(NOLOCK) WHERE q.QueueID = q_db052.QueueID AND q_db052.ProductID = 31)

	SET IDENTITY_INSERT bodb_PlaytechCS.dbo.Product3rd_ImportQueue OFF
	---end
END

DROP TABLE #QueueIdList
DROP TABLE #db053_ImportQueue

GO