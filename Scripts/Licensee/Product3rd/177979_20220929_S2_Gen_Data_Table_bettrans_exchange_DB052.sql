/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20220919@Sol
	DB: DBLIC-bodb_3rdProduct
	Task: insert data from xml col in table Product3rd_ImportQueue to bettrans_exchange - [Redmine: #177979]
*/

--## RUN IN DB052 ONLY ##--

USE bodb_3rdProduct

GO 

DECLARE 
	@fromQueueId INT = 825911
	,@toQueueId INT = 831732
	,@queueId BIGINT = 0
	,@productId INT = 31 -- exchange product
	,@errCode INT = 0
	,@errMsg NVARCHAR(2000) = ''

---variable table to contain processing queue ID
DECLARE @runningQueueId TABLE (QueueID BIGINT)

---temp table to loop through
CREATE TABLE #QueueIdList (QueueID BIGINT)

---get queueid list to loop
INSERT INTO #QueueIdList (QueueID)
SELECT QueueID
FROM bodb_PlaytechCS.dbo.Product3rd_ImportQueue q WITH (NOLOCK)
WHERE q.QueueID BETWEEN @fromQueueId AND @toQueueId AND q.ProductID = @productId
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

	DELETE TOP (1) -- run one by one queueid
	FROM #QueueIdList
	OUTPUT deleted.QueueID
	INTO @runningQueueId(QueueID)

	--get queue id 
	SELECT TOP 1 @queueId = queueid
	FROM @runningQueueId

	---run sp to read data from bodb_PlaytechCS.dbo.Product3rd_ImportQueue
	exec bodb_3rdProduct.[dbo].[Task_Product3rd_ImportQueue_ProcessData]
		@QueueIDInput = @queueId,
		@ProductID = @productId,
		@ErrCode = @errCode OUTPUT,
		@ErrMsg	= @errMsg OUTPUT

	SELECT @queueId, @productId

	IF (@errCode <> 0 OR @errMsg <> '')
	BEGIN
		SELECT @errCode,@errMsg

		--break and stop the process
		BREAK
	END
END

DROP TABLE #QueueIdList
GO