/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20221101@Danny
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement [RedmineID: #169560]
*/
USE bodb_Report

-- Create SP first

CREATE PROCEDURE [dbo].[SSIS_Statement_Accum_byCust_Export_bk]
    @FromDate   SMALLDATETIME
    ,@ToDate    SMALLDATETIME
AS
/*
    Created:    20221107@Danny
    Task:       SSIS Archiving Data - Statement_Accum - bk range
    Database:   DBACC-bodb02

    Revisions:
        - 20221107@Danny: Initialize SP [RedmineID: #169560]
 */
BEGIN
    SET NOCOUNT ON

	DECLARE @tempCust TABLE (custID INT, Diff_from DATETIME)
	INSERT INTO @tempCust (custID)
	SELECT custID from dbo.STATEMENT_ACCUM_WRONGBALANCE_UAT with(nolock) 
	WHERE Diff_From >= '2019-01-01' and IsFixed IS NULL

	CREATE TABLE #Statement_Accum(
	[CustId] [int] NOT NULL,
	[AccDate] [datetime] NOT NULL,
	[TotalAmt] [money] NULL,
	 CONSTRAINT [PK_Statement_Accum] PRIMARY KEY CLUSTERED 
	(
		[AccDate] ASC,
		[CustId] ASC
	)
	)

    DECLARE @tmp_winlostdate    SMALLDATETIME,
            @BalanceUpDay       SMALLDATETIME,
            @fdate      DATETIME,
            @tdate      DATETIME,
            @accdate    DATETIME

    DECLARE @MBU TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
    
    INSERT INTO @MBU (BalanceUpDay, MoveBetsDay)
    EXEC bodb02.dbo.Age_SelBalanceUpDay

    SELECT @BalanceUpDay = BalanceUpDay FROM @MBU
    
    SELECT @fdate = @FromDate, @tdate = DATEADD(DAY, 1, @ToDate), @accdate = DATEADD(DAY, 1, @ToDate)

    -- Get data from bettrans
    CREATE TABLE #__bettrans 
    (
        custid INT, recommend INT, mrecommend INT, srecommend INT,
        actual_stake MONEY, winlost MONEY, awinlost MONEY, mwinlost MONEY, swinlost MONEY,
        playercomm MONEY, comm MONEY, acomm MONEY, scomm MONEY
    )

    INSERT INTO #__bettrans (custid, recommend, mrecommend, srecommend, actual_stake, winlost, awinlost, mwinlost, swinlost, playercomm, comm, acomm, scomm)
    SELECT custid, recommend, mrecommend, srecommend, SUM(actual_stake), SUM(winlost), SUM(awinlost), SUM(mwinlost), SUM(swinlost), SUM(playercomm), SUM(comm), SUM(acomm), SUM(scomm)
    FROM bodb_Archive.dbo.bettrans_bk WITH (NOLOCK)
    WHERE winlostdate BETWEEN @FromDate AND @ToDate
    GROUP BY custid, recommend, mrecommend, srecommend

    -- Get data from transfer
    CREATE TABLE #__transfer (custid INT, amount MONEY)

    SET @tmp_winlostdate = DATEADD(DAY, -14, @FromDate)
    
    WHILE @tmp_winlostdate <= @ToDate
    BEGIN
        IF @tmp_winlostdate >= @BalanceUpDay
            INSERT INTO #__transfer (custid, amount)
            SELECT custid, SUM(Winlost - Actual_Stake) AS amount
            FROM bodb02.dbo.Transfer WITH (NOLOCK)
            WHERE TransDate >= @fdate AND TransDate < @tdate AND bettype > 20000
                AND winlostdate = @tmp_winlostdate
            GROUP BY custid
        ELSE
            INSERT INTO #__transfer (custid, amount)
            SELECT custid, SUM(Credit - Debit) AS amount
            FROM bodb_Archive.dbo.Transfer_bk WITH (NOLOCK)
            WHERE TransDate >= @fdate AND TransDate < @tdate AND bettype > 20000
                AND winlostdate = @tmp_winlostdate
            GROUP BY custid

        SELECT @tmp_winlostdate = DATEADD(DAY, 1, @tmp_winlostdate)
    END

    INSERT INTO #Statement_Accum (CustId,AccDate,TotalAmt)
    SELECT CustId, @accdate AS AccDate, SUM(totalamt) AS TotalAmt
    FROM (
        -- Opening Accumulated Amount
        SELECT custid, totalamt
        FROM bodb_Report.dbo.Statement_Accum WITH (NOLOCK)
        WHERE accdate = @fromdate

        -- Transfer tickets
        UNION ALL
        SELECT custid, SUM(amount) AS totalamt
        FROM #__transfer
        GROUP BY custid

        -- Prize tickets
        UNION ALL
        SELECT custid, SUM(WinAmount) AS totalamt
        FROM bodb02.dbo.PayoutTrans WITH (NOLOCK)
        WHERE winlostdate BETWEEN @FromDate AND @ToDate
            AND PayoutStatusId IN (4, 5) -- 'Completed', 'Expired'      
        GROUP BY custid

        -- Bet tickets
        UNION ALL
        SELECT t.custid, SUM(t.totalamt) AS totalamt
        FROM #__bettrans b
            CROSS APPLY (
                SELECT b.custid, b.winlost - b.actual_stake + b.playercomm AS totalamt
                UNION ALL SELECT b.recommend, b.awinlost + b.comm - b.playercomm
                UNION ALL SELECT b.mrecommend, b.mwinlost + b.acomm - b.comm
                UNION ALL SELECT b.srecommend, b.swinlost + b.scomm - b.acomm
            ) t
        GROUP BY t.custid
    ) b
	WHERE b.CustId IN (SELECT x.CustID FROM @tempCust x)
    GROUP BY custid
    HAVING SUM(totalamt) <> 0

	MERGE dbo.Statement_Accum AS t
	USING #Statement_Accum u  ON t.AccDate = u.AccDate AND t.CustId = u.CustId
	WHEN MATCHED THEN UPDATE
		SET TotalAmt = u.totalAmt
	WHEN NOT MATCHED THEN
		INSERT(CustID, AccDate, TotalAmt)
		VALUES(u.CustId, u.AccDate, u.TotalAmt);

    DROP TABLE #__bettrans
    DROP TABLE #__transfer
	DROP TABLE #Statement_Accum
END


-- Regen
-- Start: 2022-04-08
-- End:   2022-10-28

DECLARE @BUDates TABLE (BUDate DATETIME, ID INT Identity (1,1))
INSERT INTO @BUDates(BUDate)
SELECT AccDate FROM dbo.Statement WITH(NOLOCK)
WHERE CustID = 3 AND accdate > '2022-04-01' AND transtype = 'BAL'
UNION SELECT '2022-10-28' AS AccDate
ORDER BY AccDate ASC

DECLARE @i INT = 1

DECLARE @Begin_bal DATETIME, @End_bal DATETIME
WHILE EXISTS (SELECT TOp 1 1 FROM @BUDates WHERE ID = @i)
BEGIN
	SELECT @Begin_bal =  DATEADD(DAY, -7, BUDate), @End_bal = DATEADD(DAY, -1, BUDate) FROM @BUDates WHERE ID = @i
	EXEC SSIS_Statement_Accum_byCust_Export_bk  @FromDate = @Begin_bal, @ToDate = @End_bal

	SELECT @i = @i + 1
END

