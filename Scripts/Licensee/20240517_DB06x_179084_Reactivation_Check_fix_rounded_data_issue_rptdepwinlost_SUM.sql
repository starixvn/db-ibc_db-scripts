/*<info serverAlias="DBRPT-bodb_Report" isFunction="0" isNested=""></info>*/

/*
	Created: 20240517@Evan
	DB: DBRPT-bodb_Report
	Task: Reactivation - Check & fix rounded data issue [Redmine: 179084]
	Run on DB061,DB062
*/
SET NOCOUNT ON

DECLARE @Msg VARCHAR (500),@rowCount BIGINT

SET @Msg =   'Starting...'
RAISERROR (@Msg , 0, 1) WITH NOWAIT

DROP TABLE IF EXISTS #AffectList
CREATE TABLE #AffectList ([custid] INT , [closingdate] SMALLDATETIME, [openingdate] SMALLDATETIME, DiffAmt MONEY);

;WITH cte_sumdata AS
(
	SELECT custid
		 , ROW_NUMBER() OVER (PARTITION BY custid ORDER BY winlostdate ASC) randid
		 , ISNULL(openingbalance, 0) openingbalance
		 , ISNULL(closingbalance, 0) closingbalance
		 , winlostdate
	FROM dbo.[rptDepwinlost_SUM] WITH (NOLOCK)
	WHERE winlostdate BETWEEN '2022-01-01' AND '2023-01-01'
)
INSERT INTO #AffectList([custid],[closingdate],[openingdate])
SELECT t1.custid
	 , MIN(t1.winlostdate) AS closingdate
	 , MAX(t2.winlostdate) AS openingdate
FROM cte_sumdata t1
	INNER JOIN cte_sumdata t2 ON t1.custid = t2.custid
		AND t1.randid = t2.randid - 1
WHERE t1.closingbalance <> t2.openingbalance
GROUP BY t1.custid

SET @rowCount = @@rowcount
SET @Msg =  'Affected row: ' + CAST(@rowCount AS VARCHAR(50)) + ' List recommend not matching OpeningBalance and ClosingBalance'
RAISERROR (@Msg , 0, 1) WITH NOWAIT

DECLARE @fdate SMALLDATETIME,@tdate SMALLDATETIME , @cdate SMALLDATETIME 
SELECT @fdate = MIN(closingdate), @tdate = MAX(openingdate) 
FROM #AffectList

SELECT @cdate  = @fdate

WHILE (@cdate < @tdate)
BEGIN

	;WITH cte_rptDepWinlost_bk AS
	(
		SELECT
			winlostdate
			,currency
			,recommend
			,srecommend	
			,SUM(ISNULL(OpeningBalance,0)) AS OpeningBalance
			,SUM(ISNULL(Deposit,0)) AS Deposit
			,SUM(ISNULL(Withdrawal,0)) AS Withdrawal
			,SUM(ISNULL(Aff2MemTransfer,0)) AS Aff2MemTransfer
			,SUM(ISNULL(Bonus,0)) AS Bonus
			,SUM(ISNULL(Adjustment,0)) AS Adjustment
			,SUM(ISNULL(Turnover,0)) AS Turnover
			,SUM(ISNULL(Outstanding,0)) AS Outstanding
			,SUM(ISNULL(Winloss,0)) AS Winloss
			,SUM(ISNULL(ClosingBalance,0)) AS ClosingBalance
			,SUM(ISNULL(actualrate,0)) AS actualrate
			,SUM(ISNULL(Transfer3rd,0)) AS Transfer3rd
			,SUM(ISNULL(DrawGame,0)) AS DrawGame
			,SUM(ISNULL(Turnover_BA,0)) AS Turnover_BA
			,SUM(ISNULL(Comm_BA,0)) AS Comm_BA
			,SUM(ISNULL(AmountDueTo_BA,0)) AS AmountDueTo_BA
			,SUM(ISNULL(playercomm,0)) AS playercomm
			,SUM(ISNULL(Transfer3rdOthers,0)) AS Transfer3rdOthers
			,SUM(ISNULL(Promotion,0)) AS Promotion
			,SUM(ISNULL(RawDrawGame,0)) AS RawDrawGame
			,SUM(ISNULL(RawTurnover,0)) AS RawTurnover
		FROM rptDepWinlost_bk WITH(NOLOCK)
		WHERE winlostdate = @cdate AND recommend IN (SELECT al.custid FROM #AffectList al)
		GROUP BY winlostdate, recommend, currency, srecommend
	) 
	MERGE rptDepwinlost_SUM AS TARGET
	USING cte_rptDepWinlost_bk AS SOURCE
		ON TARGET.winlostdate = @cdate AND TARGET.recommend = SOURCE.recommend 
	WHEN MATCHED AND TARGET.recommend IN (SELECT al.custid FROM #AffectList al) THEN
	UPDATE SET  TARGET.ClosingBalance = SOURCE.ClosingBalance
				,TARGET.OpeningBalance =  SOURCE.OpeningBalance
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		winlostdate,custid,currency,recommend,srecommend,OpeningBalance,Deposit,Withdrawal,Aff2MemTransfer,Bonus,Adjustment,Turnover,Outstanding,
		Winloss,ClosingBalance,actualrate,Transfer3rd,DrawGame,Turnover_BA,Comm_BA,AmountDueTo_BA,playercomm,Transfer3rdOthers,Promotion,RawDrawGame,RawTurnover
	)
	VALUES(SOURCE.winlostdate,SOURCE.recommend,SOURCE.currency,SOURCE.recommend,SOURCE.srecommend,SOURCE.OpeningBalance,SOURCE.Deposit,SOURCE.Withdrawal,SOURCE.Aff2MemTransfer,SOURCE.Bonus,SOURCE.Adjustment,SOURCE.Turnover,SOURCE.Outstanding,SOURCE.
		Winloss,SOURCE.ClosingBalance,SOURCE.actualrate,SOURCE.Transfer3rd,SOURCE.DrawGame,SOURCE.Turnover_BA,SOURCE.Comm_BA,SOURCE.AmountDueTo_BA,SOURCE.playercomm,SOURCE.Transfer3rdOthers,SOURCE.Promotion,SOURCE.RawDrawGame,SOURCE.RawTurnover)
	;
    SELECT @rowCount = @@RowCount

	SET @Msg =  'Update/Insert data '+CONVERT(VARCHAR,@cdate,23)+' - Affected row: ' + CAST(@rowCount AS VARCHAR(50))
	RAISERROR (@Msg , 0, 1) WITH NOWAIT

	SET @cdate = DATEADD (DAY,1,@cdate)
	
END

--Update List recommend not matching table rptDepWinlost_bk

DROP TABLE IF EXISTS #ListAgentErr
CREATE TABLE #ListAgentErr ([Recommend] INT, IsCheck BIT DEFAULT(0));

SET @cdate = DATEADD(DAY,-1,@fdate)
;WITH cte_rptDepwinlost_SUM
	AS 
	(
		SELECT winlostdate,custid
			 , SUM(ClosingBalance) ClosingBalance
		FROM [rptDepwinlost_SUM] a (nolock)
		WHERE winlostdate  = @cdate
		GROUP BY winlostdate,custid
	), 
	cte_rptDepWinlost_bk 
	AS(
		SELECT  a.recommend,winlostdate
			 , SUM(ClosingBalance) ClosingBalance
		FROM rptDepWinlost_bk(nolock) a
		WHERE winlostdate = @cdate
		GROUP BY a.recommend,winlostdate
	),
	cte_Diff AS (
		SELECT b.recommend
		FROM cte_rptDepwinlost_SUM a 
			INNER JOIN cte_rptDepWinlost_bk b ON a.custid=b.recommend AND a.winlostdate=b.winlostdate
		WHERE a.ClosingBalance <> b.ClosingBalance
	)
INSERT INTO #ListAgentErr (Recommend)
SELECT recommend FROM cte_Diff

DROP TABLE IF EXISTS #tmpCorrect
DROP TABLE IF EXISTS #tmpCorrectSub
CREATE TABLE #tmpCorrect (
	  recommend INT
	, winlostdate SMALLDATETIME
	, OpeningBalance MONEY  
	, OpeningBalanceBK MONEY  
	, ClosingBalance MONEY  
	, ClosingBalanceBK MONEY  
	, Isfinished BIT
)
CREATE TABLE #tmpCorrectSub (
	  recommend INT
	, winlostdate SMALLDATETIME
	, OpeningBalance MONEY  
	, OpeningBalanceBK MONEY  
	, ClosingBalance MONEY  
	, ClosingBalanceBK MONEY  
)

-- Get list data different after '2022-01-01'
DECLARE @Recommend INT,@DiffAmt MONEY, @CutOffDate SMALLDATETIME
SELECT @CutOffDate = '20220101' 

WHILE EXISTS (SELECT 1 FROM #ListAgentErr WHERE IsCheck = 0 )
BEGIN
	SELECT TOP 1 @Recommend = Recommend FROM #ListAgentErr WHERE IsCheck = 0 

	INSERT INTO #tmpCorrect(recommend,winlostdate,ClosingBalance, ClosingBalanceBK,OpeningBalance,OpeningBalanceBK)
	SELECT b.recommend,b.winlostdate,b.ClosingBalance,ClosingBalance_bk,OpeningBalance,OpeningBalance_bk
	FROM rptDepwinlost_SUM b  WITH (NOLOCK) 
	INNER JOIN (
			SELECT a.recommend,a.winlostdate, SUM(a.ClosingBalance) ClosingBalance_bk, SUM(a.OpeningBalance) OpeningBalance_bk
			FROM rptDepWinlost_bk a WITH(NOLOCK) 
			GROUP BY a.recommend,a.winlostdate
		) b1 ON b.recommend = b1.recommend AND b.winlostdate = b1.winlostdate
	WHERE b.recommend = @Recommend 
		AND  b.winlostdate BETWEEN @CutOffDate AND @cdate
		AND (b1.ClosingBalance_bk <> b.ClosingBalance)

	SET @rowCount = @@rowcount
	SET @Msg = '@Recommend : ' +CONVERT(VARCHAR,@Recommend)+  ' - Affected row: ' + CAST(@rowCount AS VARCHAR(50))
	RAISERROR (@Msg , 0, 1) WITH NOWAIT

	UPDATE #ListAgentErr SET IsCheck = 1 WHERE Recommend = @Recommend
END

-- Update correct data 
WHILE (1 = 1)
BEGIN
	
	UPDATE TOP (2000) cs
		SET Isfinished = 1	
	OUTPUT DELETED.recommend , DELETED.winlostdate , DELETED.OpeningBalance , DELETED.OpeningBalanceBK , DELETED.ClosingBalance , DELETED.ClosingBalanceBK
	INTO #tmpCorrectSub (recommend , winlostdate , OpeningBalance , OpeningBalanceBK , ClosingBalance , ClosingBalanceBK)		
	FROM #tmpCorrect cs
	WHERE Isfinished IS NULL
	
	IF @@ROWCOUNT = 0
		BREAK
	
	UPDATE a 
	SET a.OpeningBalance = b.OpeningBalanceBK, a.ClosingBalance = b.ClosingBalanceBK
	FROM rptDepwinlost_SUM a 
	INNER JOIN #tmpCorrectSub b ON a.recommend = b.recommend AND a.winlostdate = b.winlostdate
		
	TRUNCATE TABLE #tmpCorrectSub
END

SET @Msg =   'Finished...'
RAISERROR (@Msg , 0, 1) WITH NOWAIT

DROP TABLE IF EXISTS #tmpCorrect
DROP TABLE IF EXISTS #tmpCorrectSub
DROP TABLE IF EXISTS #AffectList
DROP TABLE IF EXISTS #ListAgentErr