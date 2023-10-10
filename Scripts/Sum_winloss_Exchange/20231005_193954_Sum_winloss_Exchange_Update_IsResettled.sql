/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20231005@Evan
	DB: DBLIC-bodb_3rdProduct
	Task: Update IsResettled on Sum_winloss_Exchange [RedmineID: #193954]
*/
USE bodb_3rdProduct
GO

DROP TABLE IF EXISTS  #tmpSum_winloss_Exchange_Detail 
DROP TABLE IF EXISTS  #tmpxml 
DROP TABLE IF EXISTS  #tmpData 
DROP TABLE IF EXISTS  #tmpQueue 

DECLARE @CutOffDate SMALLDATETIME = '2023-09-01'

CREATE TABLE #tmpQueue
(
	QueueID			BIGINT
)
CREATE TABLE #tmpxml
(
	RowId			INT IDENTITY(1,1),
	XmlData			XML
)
INSERT INTO #tmpQueue (QueueID)
SELECT piq.QueueID
FROM bodb_PlaytechCS.dbo.Product3rd_ImportQueue piq WITH(NOLOCK) 
WHERE piq.JobType = 3 AND piq.ProductID = 31 
	AND piq.CheckInTime >= @CutOffDate
	
INSERT INTO #tmpxml (XmlData)
SELECT piq.XmlData
FROM bodb_PlaytechCS.dbo.Product3rd_ImportQueue piq WITH (NOLOCK)
	INNER JOIN #tmpQueue q ON piq.QueueID = q.QueueID

	
DECLARE @RowId INT = 1;
DECLARE @XmlData XML
DECLARE @BatchSize INT = 2000

CREATE TABLE #tmpData
(
	userId			VARCHAR(16),
	eventID			INT,
	marketID		VARCHAR(50),
	settledDate		DATETIME ,
	custID			VARCHAR(16), 
)
-- transaction detail for Resettled Summary Job (JobType = 3)
CREATE TABLE #tmpSum_winloss_Exchange_Detail
(
	RowId			INT IDENTITY(1,1),
	userId			VARCHAR(16),
	eventID			INT,
	marketID		VARCHAR(50),
	settledDate		DATETIME ,
	custID			VARCHAR(16), 
	isfinished		BIT DEFAULT(0) 
)
WHILE (1 = 1)
BEGIN
	SELECT @XmlData = t.XmlData  FROM #tmpxml t  WHERE RowId = @RowId
	
	IF @@ROWCOUNT = 0
		BREAK
		
	INSERT INTO #tmpData
	(
		userId,
		eventID,
		marketID,
		settledDate,
		custID
	)
	SELECT
		t.c.value('@userId', 'VARCHAR(16)') AS userId,
		t.c.value('@eventId', 'INT') AS eventId,
		t.c.value('@marketId', 'VARCHAR(50)') AS marketId,
		NULLIF(t.c.value('@settledDate', 'DATETIME'), '') AS settledDate,
		REPLACE(REPLACE(REPLACE(t.c.value('@userId', 'VARCHAR(16)'), 'poc', ''), 'sit', ''), 'uat', '') AS custID
	FROM @XmlData.nodes('TransList/Transaction') t (c)
		OUTER APPLY t.c.nodes('TransactionDetail') t1 (c1)

	SET @RowId = @RowId + 1
	
END

DELETE #tmpData
WHERE ISNUMERIC(custId + '.e0') = 0

INSERT INTO #tmpSum_winloss_Exchange_Detail (userId, eventID, marketID, settledDate, custID)
SELECT DISTINCT d.userId
			  , d.eventID
			  , d.marketID
			  , d.settledDate
			  , d.custID
FROM #tmpData d

WHILE EXISTS (SELECT TOP 1 1 FROM #tmpSum_winloss_Exchange_Detail)
BEGIN
	UPDATE TOP (@BatchSize) a
	SET a.isfinished = 1
	FROM #tmpSum_winloss_Exchange_Detail a

	UPDATE a WITH(ROWLOCK)
	SET a.IsResettled = 1
	FROM dbo.Sum_winloss_Exchange a
		INNER JOIN #tmpSum_winloss_Exchange_Detail b ON a.userId = b.userId
			AND a.eventID = b.eventID
			AND a.marketID = b.marketID
			AND a.settledDate = b.settledDate
	WHERE b.isfinished = 1 AND a.resettledDate >= @CutOffDate	

	DELETE #tmpSum_winloss_Exchange_Detail WHERE isfinished = 1

	WAITFOR DELAY '00:00:00.280'
END