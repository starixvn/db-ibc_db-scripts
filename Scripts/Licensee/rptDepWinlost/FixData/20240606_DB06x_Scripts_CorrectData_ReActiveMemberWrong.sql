
/*<info serverAlias="DBRPT-bodb_Report" isFunction="0" isNested=""></info>*/

/*
	Created: 20240606@Evan
	DB: DBRPT-bodb_Report
	Task: Reactivation - Check & fix rounded data issue [Redmine: 179084]
	Run on DB061, DB062
*/

SET NOCOUNT ON
DECLARE @Msg VARCHAR (500),@rowCount BIGINT;
SET @Msg =   'Start checking ...';
RAISERROR (@Msg , 0, 1) WITH NOWAIT;

DECLARE @MBBU TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
INSERT INTO @MBBU (BalanceUpDay, MoveBetsDay)
EXEC bodb02.dbo.Age_SelBalanceUpDay
    
DECLARE @BalanceUpDate SMALLDATETIME
SELECT  @BalanceUpDate = BalanceUpDay FROM @MBBU
DECLARE @Checkdate SMALLDATETIME = @BalanceUpDate
 ---------- Declare temp table
DROP TABLE IF EXISTS #rptDepWinlost_Main
DROP TABLE IF EXISTS #Transfer
DROP TABLE IF EXISTS #rptTradeCustWinlost
CREATE TABLE #rptDepWinlost_Main (CustId INT PRIMARY KEY, OpeningBalance MONEY)
CREATE TABLE #Transfer (CustId INT PRIMARY KEY, OpeningBalance MONEY)
CREATE TABLE #rptTradeCustWinlost (CustId INT PRIMARY KEY, Winloss MONEY)

INSERT INTO #rptTradeCustWinlost (CustId, Winloss)
SELECT CustID, SUM(Winloss) AS Winloss
FROM bodb_Report.dbo.rptTradeCustWinlost ta WITH (NOLOCK)
WHERE NOT EXISTS (SELECT TOP 1 1 FROM bodb02.dbo.Dep_Customer_Archived da WITH(NOLOCK) WHERE ta.CustID = da.CustID)
GROUP BY CustID

----- Check data
INSERT INTO #rptDepWinlost_Main (CustId, OpeningBalance)
SELECT m.CustID, m.OpeningBalance
FROM bodb_Report.dbo.rptDepWinlost_Main m WITH (NOLOCK)
WHERE m.Winlostdate = @Checkdate AND m.currency <> 20
    AND NOT EXISTS (SELECT TOP 1 1 FROM bodb02.dbo.Dep_Customer_Archived da WITH(NOLOCK) WHERE m.CustID = da.CustID)

INSERT INTO #Transfer (CustId, OpeningBalance)
SELECT CustId, SUM(OpeningBalance)
FROM (
    SELECT b.CustID, SUM(b.winlost - b.actual_stake) AS OpeningBalance
    FROM bodb02.dbo.Transfer b WITH (NOLOCK)
    WHERE bettype = 20000
        AND b.WinlostDate = @Checkdate
        AND NOT EXISTS (SELECT TOP 1 1 FROM bodb02.dbo.Dep_Customer_Archived da WITH(NOLOCK) WHERE b.CustID = da.CustID)
    GROUP BY CustID
) t
GROUP BY CustId

DECLARE @DiffBalanceCust_Tmp TABLE (
	  custid INT,
      DiffAmt MONEY,
      DiffDate SMALLDATETIME
)

INSERT INTO @DiffBalanceCust_Tmp (CustID , DiffAmt)
SELECT r.CustID
     , (ISNULL(t.OpeningBalance, 0) - (r.OpeningBalance + ISNULL(c.Winloss, 0))) AS DiffAmt
FROM #rptDepWinlost_Main r
    LEFT JOIN #Transfer t ON r.CustId = t.CustId
    LEFT JOIN #rptTradeCustWinlost c ON r.CustID = c.CustID
WHERE (t.CustId IS NOT NULL)
    AND (ISNULL(t.OpeningBalance, 0) - (r.OpeningBalance + ISNULL(c.Winloss, 0))) <> 0
    
SET @rowCount = @@rowcount;
SELECT @rowCount

DECLARE @CustomerIDs VARCHAR(MAX) =''
SELECT TOP 100 @CustomerIDs = COALESCE(@CustomerIDs + ',', '') + CONVERT(VARCHAR(10), CustID) FROM @DiffBalanceCust_Tmp

SET @Msg =  'Opening balances of ' + CAST(@rowCount AS VARCHAR(50)) 
			+ ' customer(s) are different compared with bettrans on: ' + CONVERT(VARCHAR(20), @Checkdate)
			+ CHAR(10) + CHAR(13) -- Line break
			+ 'List of customers: ' + @CustomerIDs							
			+ CHAR(13) -- Line break
RAISERROR (@Msg , 0, 1) WITH NOWAIT;

----- Get first date make data diff
UPDATE a 
SET DiffDate = b.WinlostDate
FROM @DiffBalanceCust_Tmp a
	CROSS APPLY (
		SELECT TOP 1 b.WinlostDate
		FROM bodb_Report.dbo.rptStatement_Old b (NOLOCK)
			INNER JOIN bodb_Report.dbo.rptDepWinlost_bk c (NOLOCK) ON c.custid = b.custid
				AND c.WinlostDate = b.WinlostDate
		WHERE a.custid = b.custid
			AND b.ClosingBalance <> c.ClosingBalance
		ORDER BY b.WinlostDate
	) b

DECLARE @ArchiveCust TABLE (Custid INT, ClearDate SMALLDATETIME, ReinitDate SMALLDATETIME, DiffAmt MONEY, ClearAmt MONEY, ReinitAmt MONEY)
;
WITH cte_tmp AS
(
	SELECT a.custid
		 , CONVERT(DATE, accdate) accdate
		 , totalamt
		 , ROW_NUMBER() OVER (PARTITION BY a.custid ORDER BY accdate) RowId
	FROM dbo.Statement a WITH(NOLOCK) INNER JOIN @DiffBalanceCust_Tmp b ON a.custid = b.custid
	WHERE transtype = 'DTRAARC'
)
INSERT INTO @ArchiveCust (Custid, ClearDate, ReinitDate, DiffAmt, ClearAmt, ReinitAmt)
SELECT a.custid
	 , a.accdate AS ClearDate
     , b.accdate AS ReinitDate
	 , a.totalamt + b.totalamt Diff
     , a.totalamt AS ClearAmt
     , b.totalamt AS ReinitAmt
FROM cte_tmp a
	INNER JOIN cte_tmp b ON a.custid = b.custid
		AND a.RowId = b.RowId - 1
WHERE a.totalamt + b.totalamt <> 0

DECLARE @DiffBalanceCust TABLE (
	  custid INT,
	  recommend INT,
      DiffAmt MONEY,
      DiffDate SMALLDATETIME,
	  IsCheckCustid BIT  DEFAULT(0),
	  IsCheckRecommend BIT  DEFAULT(0)
)
INSERT INTO @DiffBalanceCust (custid,DiffAmt,DiffDate)
SELECT a.custid,a.DiffAmt,b.ReinitDate 
FROM @DiffBalanceCust_Tmp a 
  INNER JOIN @ArchiveCust b ON a.Custid = b.Custid AND a.DiffDate = b.ClearDate AND a.DiffAmt = b.DiffAmt
SET @rowCount = @@rowcount;

SELECT TOP 100 @CustomerIDs = COALESCE(@CustomerIDs + ',', '') + CONVERT(VARCHAR(10), CustID) FROM @DiffBalanceCust
SET @Msg =  'Affected row: ' + CAST(@rowCount AS VARCHAR(50)) 
			+ ' - List customer(s) different compared with bettrans because of wrong number when reactive member'
			+ CHAR(10) + CHAR(13) -- Line break
			+ 'List of customers: ' + @CustomerIDs							
			+ CHAR(13) -- Line break
RAISERROR (@Msg , 0, 1) WITH NOWAIT;

UPDATE a
SET a.recommend = b.recommend
FROM @DiffBalanceCust a
	INNER JOIN bodb02..custInfo b (NOLOCK) ON a.custid = b.custid

-- UPDATE: correct balance table depWL
DECLARE @Custid INT, @Recommend INT, @Winlostdate SMALLDATETIME, @DiffAmt MONEY
WHILE (1 = 1)
BEGIN
	
	SELECT TOP 1 @Custid = CustId, @Winlostdate = DiffDate, @DiffAmt = DiffAmt  FROM @DiffBalanceCust WHERE IsCheckCustid = 0

	IF @@ROWCOUNT = 0
		GOTO UPDATE_rptdepwinlost_SUM;

	--  rptDepWinlost_BK
	UPDATE a 
	SET a.ClosingBalance = a.ClosingBalance + @DiffAmt,
		a.OpeningBalance = CASE WHEN a.winlostdate = @Winlostdate THEN a.OpeningBalance ELSE a.OpeningBalance + @DiffAmt END,
		a.Adjustment = CASE WHEN a.winlostdate = @Winlostdate THEN a.Adjustment + @DiffAmt ELSE a.Adjustment END
	FROM dbo.rptDepWinlost_bk a   WITH(ROWLOCK) 
	WHERE a.custid = @Custid AND a.winlostdate >= @Winlostdate

	SET @rowCount = @@rowcount;
	SET @Msg =  'Updated rptDepWinlost_bk ('+CAST (@Custid AS VARCHAR(50))+' - from '+CONVERT(VARCHAR(20), @Winlostdate)+' ) - Affected row: ' + CAST (@rowCount AS VARCHAR(50));
	RAISERROR (@Msg , 0, 1) WITH NOWAIT;

	--  rptDepWinlost_Main
	UPDATE a 
	SET a.OpeningBalance = a.OpeningBalance + @DiffAmt
	FROM rptDepWinlost_Main a
	WHERE a.CustID = @Custid 

	SET @rowCount = @@rowcount;
	SET @Msg =  'Updated rptDepWinlost_Main ('+CAST (@Custid AS VARCHAR(50))+' - from '+CONVERT(VARCHAR(20), @Winlostdate)+' ) - Affected row: ' + CAST (@rowCount AS VARCHAR(50));
	RAISERROR (@Msg , 0, 1) WITH NOWAIT;

	UPDATE @DiffBalanceCust SET IsCheckCustid = 1 WHERE CustId = @Custid

	UPDATE_rptdepwinlost_SUM:

	SELECT TOP 1 @Recommend= recommend, @Winlostdate = DiffDate, @DiffAmt = SUM(DiffAmt) FROM @DiffBalanceCust WHERE IsCheckRecommend = 0 GROUP BY recommend, DiffDate
	IF @@ROWCOUNT = 0
		BREAK
	 
	UPDATE b
	SET  b.ClosingBalance = b.ClosingBalance + @diffamt
		,b.OpeningBalance = CASE WHEN b.winlostdate = @Winlostdate THEN b.OpeningBalance ELSE b.OpeningBalance + @DiffAmt END
		,b.Adjustment = CASE WHEN b.winlostdate = @Winlostdate THEN b.Adjustment + @DiffAmt ELSE b.Adjustment END
	FROM rptdepwinlost_SUM b WITH(ROWLOCK)
	WHERE b.recommend = @Recommend AND b.winlostdate >= @Winlostdate

	SET @rowCount = @@rowcount;
	SET @Msg =  'Updated rptdepwinlost_SUM ('+CAST (@Recommend AS VARCHAR(50))+' - from '+CONVERT(VARCHAR(20), @Winlostdate)+' ) - Affected row: ' + CAST (@rowCount AS VARCHAR(50));
	RAISERROR (@Msg , 0, 1) WITH NOWAIT;

	UPDATE @DiffBalanceCust set IsCheckRecommend = 1 where Recommend = @Recommend AND  DiffDate = @Winlostdate 
END 

---- Update case custid = 122863182 (sabacoin ticket error)
UPDATE a
SET a.Outstanding = CASE WHEN a.winlostdate = b.DiffDate THEN a.Outstanding - b.DiffAmt ELSE a.Outstanding END
  , a.ClosingBalance = a.ClosingBalance + b.DiffAmt
  , a.OpeningBalance = CASE WHEN a.winlostdate = b.DiffDate THEN a.OpeningBalance ELSE a.OpeningBalance + b.DiffAmt END
FROM dbo.rptDepWinlost_bk a WITH (ROWLOCK)
	INNER JOIN @DiffBalanceCust_Tmp b ON a.custid = b.custid
		AND a.winlostdate >= b.DiffDate
WHERE a.custid = 122863182

UPDATE a
SET a.OpeningBalance = a.OpeningBalance + b.DiffAmt
FROM dbo.rptDepWinlost_Main a WITH (ROWLOCK)
	INNER JOIN @DiffBalanceCust_Tmp b ON a.custid = b.custid
		AND a.winlostdate >= b.DiffDate
WHERE a.custid = 122863182

UPDATE a
SET a.OpeningBalance = a.OpeningBalance + b.DiffAmt
FROM dbo.rptDepwinlost_SUM a WITH (ROWLOCK)
	INNER JOIN bodb02.dbo.custInfo i WITH(NOLOCK) ON a.recommend = i.recommend
	INNER JOIN @DiffBalanceCust_Tmp b ON i.custid =b.custid
		AND a.winlostdate >= b.DiffDate
WHERE a.custid = 122863182
