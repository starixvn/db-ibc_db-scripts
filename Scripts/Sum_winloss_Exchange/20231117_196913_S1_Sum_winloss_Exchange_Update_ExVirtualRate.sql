/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20231117@Evan
	DB: DBLIC-bodb_3rdProduct
	Task: Step 1: Update ExVirtualRate on Sum_winloss_Exchange [RedmineID: #196913]
	

*/

USE bodb_3rdProduct
GO

DROP TABLE IF EXISTS  #tmpSum_winloss_Exchange

DECLARE @CutOffDate SMALLDATETIME = '2023-11-01'
	
DECLARE @BatchSize INT = 2000
 
CREATE TABLE #tmpSum_winloss_Exchange
(
	userId			VARCHAR(16),
	eventID			INT,
	marketID		VARCHAR(50),
	settledDate		DATETIME ,
	custID			VARCHAR(16), 
	site			VARCHAR(10), 
	ExVirtualRate	FLOAT, 
	isfinished		BIT DEFAULT(0) 
)
INSERT INTO #tmpSum_winloss_Exchange (userId, eventID, marketID, settledDate, custID, site, ExVirtualRate)
SELECT DISTINCT d.userId
			  , d.eventID
			  , d.marketID
			  , d.settledDate
			  , d.custID
			  , c.site
			  , e.ExVirtualRate
FROM dbo.Sum_winloss_Exchange d WITH (NOLOCK)
	INNER JOIN bodb02.dbo.Customer c WITH (NOLOCK) ON d.custId = c.custid
	INNER JOIN bodb02.dbo.Exchange e WITH (NOLOCK) ON e.ExchangeId = c.currency
WHERE d.settledDate >= @CutOffDate

WHILE EXISTS (SELECT TOP 1 1 FROM #tmpSum_winloss_Exchange)
BEGIN
	UPDATE TOP (@BatchSize) a
	SET a.isfinished = 1
	FROM #tmpSum_winloss_Exchange a

	UPDATE a WITH(ROWLOCK)
	SET a.ExVirtualRate = IIF(b.site = '12Bet',b.ExVirtualRate,1)
	FROM dbo.Sum_winloss_Exchange a
		INNER JOIN #tmpSum_winloss_Exchange b ON a.userId = b.userId
			AND a.eventID = b.eventID
			AND a.marketID = b.marketID
			AND a.settledDate = b.settledDate
	WHERE b.isfinished = 1 

	DELETE #tmpSum_winloss_Exchange WHERE isfinished = 1

	WAITFOR DELAY '00:00:00.280'
END
GO
