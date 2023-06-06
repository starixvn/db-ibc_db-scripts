/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20211213@Kos
	DB: DBLIC-bodb_LicenseeReport
	Task: Correct data table rptCasinoTurnover (Inteagrate SG promotion prize (miss sp Task_DailyRptCasinoTurnover_Bettrans14) [Redmine: #183497])
*/

USE bodb_LicenseeReport
GO

DECLARE @rptCasinoTurnover_expected TABLE (
	WinlostDate	DATE
	,CustId		INT
	,Recommend	INT
	,ProductId	INT
	,StatusId	TINYINT
	,Currency	INT
	,BetCount	INT
	,Turnover	MONEY
	,Winlost	MONEY
	,ValidBetAmount	MONEY
	,TicketType		TINYINT
)

DECLARE @rptCasinoTurnover_Current TABLE (
	WinlostDate	DATE
	,CustId		INT
	,Recommend	INT
	,ProductId	INT
	,StatusId	TINYINT
	,Currency	INT
	,BetCount	INT
	,Turnover	MONEY
	,Winlost	MONEY
	,ValidBetAmount	MONEY
	,TicketType		TINYINT
)
DECLARE @WinLostDate SMALLDATETIME = '20230410', 
		@CustId INT = 33796999, 
		@ProductId INT = 36 -- SG

INSERT INTO @rptCasinoTurnover_Current ([WinlostDate], [CustId], [Recommend], [ProductId], [StatusId], [Currency], [BetCount], [Turnover], [Winlost], [ValidBetAmount], [TicketType])
SELECT [WinlostDate], [CustId], [Recommend], [ProductId], [StatusId], [Currency], [BetCount], [Turnover], [Winlost], [ValidBetAmount], [TicketType] 
FROM rptCasinoTurnover WITH(NOLOCK)
WHERE CustId = @CustId 
	AND WinlostDate = @WinLostDate 
	--AND ProductId = @ProductId

DECLARE @SportBetTypeMatrix TABLE (ProductId TINYINT, BetType SMALLINT, RefTable TINYINT)

INSERT INTO @SportBetTypeMatrix
SELECT DISTINCT
	ProductId,
	BetType,
	RefTable
FROM bodb02.dbo.SportBettypeMatrix WITH (NOLOCK)
WHERE RefTable IN (1, 2) AND ProductID NOT IN (11, 17)

INSERT INTO @rptCasinoTurnover_expected ([WinlostDate], [CustId], [Recommend], [ProductId], [StatusId], [Currency], [BetCount], [Turnover], [Winlost], [ValidBetAmount], [TicketType])
SELECT
	b.winlostdate ,
	b.custid,
	b.recommend,
	p3rd.Productid,
	b.statusID,
	b.currency,
	COUNT(b.transid) AS BetCount,
	SUM(b.stake) AS Turnover,
	SUM(b.winlost - b.actual_stake) AS WinLost,
	SUM(b.BetStake) AS ValidBetAmount,
	CASE
		WHEN b.productId = 150 AND sbt.ProductID = 42 THEN 1	-- Saba.club Free Bets
		WHEN b.productId = 173 AND sbt.ProductID = 66 THEN 1	-- Vgaming Free Bets
		WHEN sbt.bettype IN (4300, 4299, 4298, 4297, 1698, 1699, 3150, 3898, 3899, 1906, 4598, 4599, 4600) THEN 1
		ELSE 0
	END AS TicketType
FROM
	DBARC.bodb_Archive.dbo.bettransRnG_bk AS b WITH (NOLOCK)
	INNER JOIN @SportBetTypeMatrix AS sbt ON sbt.BetType = b.gameID
	INNER JOIN bodb02.dbo.Products AS p WITH (NOLOCK) ON p.ProductID = sbt.ProductId
	INNER JOIN bodb_licensee.dbo.Product3rd AS p3rd WITH (NOLOCK) ON p3rd.ProductPrefix = p.ProductPrefix
WHERE
	b.WinlostDate = @WinLostDate
	AND b.custid = @CustId
	AND b.statusID IN (111, 112, 113)
	AND sbt.RefTable = 1
	--AND p.ProductID = @ProductId
GROUP BY b.winlostdate ,
	b.custid,
	b.recommend,
	p3rd.ProductID,
	b.statusID,
	b.currency,
	CASE
		WHEN b.productId = 150 AND sbt.ProductID = 42 THEN 1	-- Saba.club Free Bets
		WHEN b.productId = 173 AND sbt.ProductID = 66 THEN 1	-- Vgaming Free Bets
		WHEN sbt.bettype IN (4300, 4299, 4298, 4297, 1698, 1699, 3150, 3898, 3899, 1906, 4598, 4599, 4600) THEN 1
		ELSE 0
	END

--MERGE dbo.rptCasinoTurnover a
MERGE @rptCasinoTurnover_Current a
USING @rptCasinoTurnover_expected b ON
a.custid=b.custid
AND a.ProductId=b.ProductId
AND a.winlostdate=b.winlostdate
AND a.recommend=b.recommend
AND a.statusID=b.statusID
AND a.currency=b.currency
AND a.TicketType=b.TicketType
WHEN MATCHED THEN
	UPDATE SET	a.BetCount = b.BetCount,
				a.Turnover = b.Turnover,
				a.Winlost = b.Winlost,
				a.ValidBetAmount = b.ValidBetAmount
WHEN NOT MATCHED THEN
	INSERT ([WinlostDate], [CustId], [Recommend], [ProductId], [StatusId], [Currency], [BetCount], [Turnover], [Winlost], [ValidBetAmount], [TicketType])
 
	VALUES (b.[WinlostDate], b.[CustId], b.[Recommend], b.[ProductId], b.[StatusId], b.[Currency], b.[BetCount], b.[Turnover], b.[Winlost], b.[ValidBetAmount], b.[TicketType])
OUTPUT
   $action,
   inserted.*,
   deleted.*;

SELECT * FROM @rptCasinoTurnover_Current
SELECT * FROM @rptCasinoTurnover_expected

--SELECT * FROM sys.servers where data_source='10.18.200.56'
--SELECT * FROM sys.servers where name='DBARC'
----10.40.40.100
