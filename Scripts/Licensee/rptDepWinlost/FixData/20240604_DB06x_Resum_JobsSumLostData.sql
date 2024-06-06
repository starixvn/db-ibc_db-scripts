/*<info serverAlias="DBRPT-bodb_Report" isFunction="0" isNested=""></info>*/

/*
    Created: 20240604@Evan
    DB: DBRPT-bodb_Report
    Task: Reactivation - Check & fix rounded data issue [Redmine: 179084]
    Run on DB061,DB062
*/  
    
SET NOCOUNT ON;

DECLARE @Msg VARCHAR (500),@rowCount BIGINT;
SET @Msg =   'Starting...';
RAISERROR (@Msg , 0, 1) WITH NOWAIT;

DROP TABLE IF EXISTS #AffectList;
CREATE TABLE #AffectList ([recommend] INT , [fromDate] SMALLDATETIME);

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
INSERT INTO #AffectList([recommend],[fromDate])
SELECT t1.custid
        , MAX(t2.winlostdate) AS openingdate
FROM cte_sumdata t1
    INNER JOIN cte_sumdata t2 ON t1.custid = t2.custid
        AND t1.randid = t2.randid - 1
WHERE t1.closingbalance <> t2.openingbalance
GROUP BY t1.custid;

SET @rowCount = @@rowcount;
SET @Msg =  'Affected row: ' + CAST(@rowCount AS VARCHAR(50)) + ' List recommend not matching OpeningBalance and ClosingBalance';
RAISERROR (@Msg , 0, 1) WITH NOWAIT;

DECLARE @tbCustId_Lost TABLE (CustId INT, Recommend INT, [fromDate] SMALLDATETIME, [toDate] SMALLDATETIME, IsCheck BIT DEFAULT(0));
INSERT INTO @tbCustId_Lost (Recommend, CustId) VALUES (10580724, 23987033),(4359308, 10200813);
DELETE a FROM @tbCustId_Lost a WHERE a.Recommend NOT IN (SELECT recommend FROM #AffectList)

UPDATE a 
SET a.[fromDate] = b.fromDate
FROM @tbCustId_Lost a INNER JOIN #AffectList b ON b.recommend = a.Recommend 

;WITH cte_tmp AS (
SELECT dwb.custid,MIN(dwb.winlostdate) winlostdate
FROM dbo.rptDepWinlost_bk dwb WITH(NOLOCK) 
    INNER JOIN @tbCustId_Lost b ON dwb.custid = b.CustId AND dwb.winlostdate >= b.fromDate
GROUP BY  dwb.custid
)   
UPDATE  a
SET a.toDate =  ISNULL(b.winlostdate, GETDATE())
FROM @tbCustId_Lost a LEFT JOIN cte_tmp b ON a.CustId = b.custid


DECLARE @fdate SMALLDATETIME
        , @tdate SMALLDATETIME
        , @yesterdate SMALLDATETIME
        , @MaxArchiveDate SMALLDATETIME
        , @MaxSumDate SMALLDATETIME
        , @Custid INT
        , @recommend INT
        , @ClosingBalance MONEY;
    
SELECT @MaxArchiveDate = CONVERT(DATE,DATEADD(DAY,-15,CURRENT_TIMESTAMP),112); 
SELECT @MaxSumDate = CONVERT(DATE,DATEADD(DAY,-6,CURRENT_TIMESTAMP),112);

DECLARE @tbDate_Recommend TABLE (
        winlostdate SMALLDATETIME
);

WHILE EXISTS (SELECT 1 FROM @tbCustId_Lost WHERE IsCheck = 0)
BEGIN

    SELECT TOP 1 @Custid = CustId
                , @recommend = Recommend
                , @fdate = fromDate
                , @tdate = toDate
    FROM @tbCustId_Lost
    WHERE IsCheck = 0

    ;WITH cte_date AS
    (
        SELECT @fdate AS winlostdate
        UNION ALL
        SELECT DATEADD(DAY, 1, winlostdate) AS winlostdate
        FROM cte_date
        WHERE winlostdate < DATEADD(DAY,-1,@tdate)
    )
    INSERT INTO @tbDate_Recommend (winlostdate)
    SELECT winlostdate
    FROM cte_date
    OPTION (MAXRECURSION 0);

    SET @Msg =  'Re-gen custid: ' + CAST (@Custid AS VARCHAR(50));
    RAISERROR (@Msg , 0, 1) WITH NOWAIT;


    IF NOT EXISTS (select 1 from dbo.rptDepWinlost_bk (nolock) where winlostdate in (select winlostdate from @tbDate_Recommend) and custid = @Custid)
        BEGIN
            SET @yesterdate = DATEADD(DAY,-1,@fdate);
            
            INSERT INTO dbo.rptDepWinlost_bk (
                            winlostdate, custid, currency, OpeningBalance, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover, Outstanding, Winloss, 
                            ClosingBalance, recommend, mrecommend, srecommend, actualrate, Transfer3rd, DrawGame, Turnover_tdate, Turnover_BA, Comm_BA, 
                            AmountDueTo_BA, playercomm, Transfer3rdOthers, comm_bettrade, amountdueto_bettrade,Promotion,RawDrawGame,RawTurnover)
            SELECT b.winlostdate, custid, currency, OpeningBalance, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover, Outstanding, Winloss, 
                    ClosingBalance, recommend, mrecommend, srecommend, edo.ActualRate, Transfer3rd, DrawGame, NULL, Turnover_BA, Comm_BA, 
                    AmountDueTo_BA, playercomm, Transfer3rdOthers, comm_bettrade, amountdueto_bettrade,Promotion,ISNULL(RawDrawGame,0),ISNULL(RawTurnover,0)
            FROM dbo.rptDepWinlost_bk a WITH (NOLOCK)
                CROSS JOIN @tbDate_Recommend b
                INNER JOIN bodb02.dbo.ExchangeDailyOanda edo WITH(NOLOCK) ON edo.ExchangeDate = b.winlostdate AND edo.ExchangeId = a.currency
            WHERE a.winlostdate = @yesterdate AND custid = @Custid AND b.winlostdate <= @MaxArchiveDate;

            SET @rowCount = @@rowcount;
            SET @Msg =  '   Insert rptDepWinlost_bk - Affected row:: ' + CAST (@rowCount AS VARCHAR(50));
            RAISERROR (@Msg , 0, 1) WITH NOWAIT;

        END;

        IF @tdate <  @MaxArchiveDate
        BEGIN
            SET @yesterdate = DATEADD(DAY,-1,@tdate);
            SELECT @ClosingBalance = ClosingBalance FROM dbo.rptDepWinlost_bk a WITH (NOLOCK) WHERE a.custid = @Custid AND a.winlostdate = @yesterdate;

            UPDATE a
            SET a.OpeningBalance = @ClosingBalance
            FROM rptDepWinlost_bk a WITH (ROWLOCK)
            WHERE custid = @Custid
                AND winlostdate = @tdate

            UPDATE a
            SET a.OpeningBalance = a.OpeningBalance + @ClosingBalance,
                a.ClosingBalance = CASE WHEN winlostdate <= @yesterdate THEN a.ClosingBalance + @ClosingBalance ELSE a.ClosingBalance END
            FROM rptDepwinlost_SUM a WITH (ROWLOCK) 
            WHERE a.recommend = @recommend
                    AND a.winlostdate BETWEEN @fdate AND @tdate;

            SET @rowCount = @@rowcount;
            SET @Msg =  '   Update rptDepwinlost_SUM - Affected row:: ' + CAST (@rowCount AS VARCHAR(50));
            RAISERROR (@Msg , 0, 1) WITH NOWAIT;

        END;
        ELSE
        BEGIN
            

            INSERT INTO dbo.rptDepWinlost_Main (Winlostdate, CustID, OpeningBalance, actualrate, srecommend, mrecommend, recommend, currency)
            SELECT b.winlostdate, c.CustID, OpeningBalance, edo.ActualRate, c.srecommend, c.mrecommend, c.recommend, c.currency
            FROM rptDepWinlost_bk a WITH(NOLOCK)
                CROSS JOIN @tbDate_Recommend b
                INNER JOIN bodb02..custinfo c WITH(NOLOCK) ON a.custid = c.custid
                INNER JOIN bodb02.dbo.ExchangeDailyOanda edo WITH(NOLOCK) ON edo.ExchangeDate = b.winlostdate AND edo.ExchangeId = a.currency
            WHERE a.winlostdate = @yesterdate AND a.custid = @Custid AND b.winlostdate > @MaxArchiveDate

            SET @rowCount = @@rowcount;
            SET @Msg =  '   Insert rptDepWinlost_Main - Affected row:: ' + CAST (@rowCount AS VARCHAR(50));
            RAISERROR (@Msg , 0, 1) WITH NOWAIT;

            SELECT @ClosingBalance = ClosingBalance FROM dbo.rptDepWinlost_bk a WITH (NOLOCK) WHERE a.custid = @Custid AND a.winlostdate = @MaxArchiveDate;   

            UPDATE a
            SET a.OpeningBalance = a.OpeningBalance + @ClosingBalance,
                a.ClosingBalance = a.ClosingBalance + @ClosingBalance
            FROM rptDepwinlost_SUM a WITH (ROWLOCK) 
            WHERE a.recommend = @recommend
                    AND a.winlostdate BETWEEN @fdate AND @MaxSumDate;

            SET @rowCount = @@rowcount;
            SET @Msg =  '   Update rptDepwinlost_SUM - Affected row:: ' + CAST (@rowCount AS VARCHAR(50));
            RAISERROR (@Msg , 0, 1) WITH NOWAIT;

        END;

    UPDATE @tbCustId_Lost SET IsCheck = 1  WHERE CustId = @Custid;
    DELETE @tbDate_Recommend
END;