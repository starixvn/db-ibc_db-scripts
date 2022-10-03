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
	@rowPerBatch INT = 5
	,@fromQueueId INT = 825911,
	@toQueueId INT = 831732

DECLARE 
	@queryMatch NVARCHAR(MAX)
	,@execSql NVARCHAR(MAX)

---variable table to contain processing queue ID
DECLARE @runningQueueId TABLE (QueueID BIGINT)

---temp table to loop through
CREATE TABLE #QueueIdList (QueueID BIGINT)

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
    and queueid between 825911 and 831732'
SET @execSql = 'DB053.bodb02.dbo.sp_executesql @queryMatch'


---insert data into temp table to process queue
INSERT INTO #db053_ImportQueue
EXECUTE sys.sp_executesql @execSql ,N'@queryMatch NVARCHAR(MAX)',@queryMatch

---get queueid list to loop
INSERT INTO #QueueIdList (QueueID)
SELECT QueueID
FROM #db053_ImportQueue
ORDER BY QueueID

---loop and copy data to main table in db052
WHILE EXISTS (
		SELECT 1
		FROM #QueueIdList
		)
BEGIN
	--cleare all data and prepare to run
	DELETE
	FROM @runningQueueId

	DELETE TOP (@rowPerBatch)
	FROM #QueueIdList
	OUTPUT deleted.QueueID
	INTO @runningQueueId(QueueID)

	---insert data into Product3rd_ImportQueue table - db052
	INSERT INTO bodb_PlaytechCS.dbo.Product3rd_ImportQueue
	SELECT *
	FROM #db053_ImportQueue q
	WHERE q.QueueID IN (
			SELECT QueueID
			FROM @runningQueueId
			)
			AND NOT EXISTS (SELECT 1 FROM bodb_PlaytechCS.dbo.Product3rd_ImportQueue q_db052 WITH(NOLOCK) WHERE q.QueueID = q_db052.QueueID AND q_db052.ProductID = 31)
END

DROP TABLE #QueueIdList
DROP TABLE #db053_ImportQueue

GO