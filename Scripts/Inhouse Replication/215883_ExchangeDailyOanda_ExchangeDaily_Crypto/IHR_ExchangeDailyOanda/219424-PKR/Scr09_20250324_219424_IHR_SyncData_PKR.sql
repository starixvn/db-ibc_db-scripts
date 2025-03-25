/*<info serverAlias="DBCUST-CustDB" executers="" isFunction="0" isNested="0"></info>*/
/*
	Created: 20250324@Tacy	
	Task: In-House - Disable DR [RedmineID: #219424]
	DB: DBCUST-CustDB

*/
USE CustDB
GO

DECLARE @cnt INT, @__msg NVARCHAR(200) 

CREATE TABLE #tmpExchangeDailyOanda (
	[ExchangeDate] [smalldatetime] NOT NULL,
	[ExchangeId] [int] NOT NULL,
	PRIMARY KEY CLUSTERED ([ExchangeDate], [ExchangeId])
)

CREATE TABLE #tmpExchangeDailyOanda_batch (
	[ExchangeDate] [smalldatetime] NOT NULL,
	[ExchangeId] [int] NOT NULL,
	PRIMARY KEY CLUSTERED ([ExchangeDate], [ExchangeId])
)

INSERT INTO #tmpExchangeDailyOanda (ExchangeDate, ExchangeId)
SELECT [ExchangeDate], [ExchangeId]
FROM ExchangeDailyOanda WITH (NOLOCK)
WHERE ExchangeDate>'2025-03-19'

--------------------------------------------------
SELECT @cnt=COUNT(1) FROM #tmpExchangeDailyOanda
SET @__msg = 'The total of row will be synced: %d.'
RAISERROR (@__msg, 0, 1, @cnt) WITH NOWAIT
--------------------------------------------------

WHILE EXISTS (SELECT TOP 1 1 FROM #tmpExchangeDailyOanda)
BEGIN
	TRUNCATE TABLE #tmpExchangeDailyOanda_batch

	DELETE TOP (1000) t
		OUTPUT deleted.ExchangeDate, deleted.ExchangeId
		INTO #tmpExchangeDailyOanda_batch(ExchangeDate, ExchangeId)
	FROM #tmpExchangeDailyOanda t

	UPDATE ex
	SET ex.RepUpdateTime=dbo.f_GetDateTime2()
	FROM ExchangeDailyOanda ex WITH (NOLOCK)
	INNER JOIN #tmpExchangeDailyOanda_batch b 
			ON b.ExchangeDate=ex.ExchangeDate
			AND b.ExchangeId=ex.ExchangeId
	
	WAITFOR DELAY '00:00:0.280'
END
GO