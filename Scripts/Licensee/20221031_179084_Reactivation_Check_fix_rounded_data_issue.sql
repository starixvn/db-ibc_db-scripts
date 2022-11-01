/*<info serverAlias="DBRPT-bodb_Report" isFunction="0" isNested=""></info>*/

/*
	Created: 20221020@Evan
	DB: DBRPT-bodb_Report
	Task: Correct data [Redmine: 179084]

*/
USE bodb_Report;

-- Get opening balance of customer from rptDepWinlost_Main & bettrans
DECLARE @CurrentDate DATE, @Yesterday DATE
SELECT  @CurrentDate = CONVERT(DATE, CURRENT_TIMESTAMP, 112), @Yesterday = DATEADD(DAY, -1, @CurrentDate)

DECLARE @MBBU TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
INSERT INTO @MBBU (BalanceUpDay, MoveBetsDay)
EXEC bodb02.dbo.Age_SelBalanceUpDay
	
DECLARE @MoveBetsDay SMALLDATETIME
SELECT  @MoveBetsDay = MoveBetsDay FROM @MBBU

CREATE TABLE #rptDepWinlost_Main (Custid INT PRIMARY KEY, OpeningBalance MONEY)
CREATE TABLE #rptTradeCustWinlost (Custid INT PRIMARY KEY, Winloss MONEY)
CREATE TABLE #bettrans (Custid INT PRIMARY KEY, OpeningBalance MONEY)
CREATE TABLE #Transfer (Custid INT PRIMARY KEY, OpeningBalance MONEY)
CREATE TABLE #Result (Custid INT, OpeningBalance_DepWL MONEY, OpeningBalance_Bettrans MONEY, Winlostdate SMALLDATETIME)

INSERT INTO #rptTradeCustWinlost (Custid, Winloss)
SELECT ta.Custid, SUM(Winloss) AS Winloss
FROM dbo.rptTradeCustWinlost ta WITH (NOLOCK)
WHERE	NOT EXISTS (SELECT TOP 1 1 FROM bodb02.dbo.Dep_Customer_Archived da WITH(NOLOCK) WHERE ta.Custid = da.Custid)
GROUP BY ta.Custid

DECLARE @tmpDate DATE;
SELECT @tmpDate = DATEADD(D,1,@MoveBetsDay)

DECLARE @tbCustId TABLE (
	Custid INT
)
INSERT INTO @tbCustId
VALUES
	-- Real acc
(5113158),(5983055),(7727737),(7753579),(8262414),(8452564),(10358587),(10678569),(11578703),(12339906),(12959505),(13461537),(13556418),(13617655),(13832761),(14140503),(14180997),(14628547),(14628578),(14668828),(14993214),(15389223),(15495936),(15687461),(16198529),(16853913),(16871593),(16894426),(17039104),(17257001),(17418621),(17504276),(17768577),(17964241),(18783464),(18847848),(18909226),(19405550),(19477568),(19525849),(19568176),(19590608),(19812290),(20261183),(20452995),(21411908),(21461318),(21547578),(21670020),(21774715),(22012799),(22743887),(22778294),(22895100),(23255953),(23420407),(23472584),(23547606),(23674363),(24135618),(24153216),(24153243),(24181378),(24359255),(24385823),(25122787),(25226551),(25264757),(25294784),(25375103),(25382200),(25544405),(25673291),(25779577),(25840166),(25860227),(25861685),(25985823),(26017799),(26285306),(26334429),(26696663),(27066012),(27140126),(27223323),(27300247),(27571132),(27689457),(27829283),(27867092),(27870985),(27890017),(27922577),(27956151),(28004297),(28116170),(28140978),(28436305),(28483860),(28576359),(29470218),(29491774),(29517061),(29771277),(29856943),(30304068),(30689146),(30696109),(30866576),(31762891),(31843779),(32094121),(32322977),(32371305),(32460193),(32551721),(32603470),(32788377),(32838608),(32941117),(32976675),(33117485),(33318885),(37366164),(38054818),(40153457),(43852036),(44955990),(45626336),
	-- Dummy acc
	(65688165),(32657300),(2748100),(2748140),(56506786),(16379951),(43054420),(41799217),(41799123),(45840936),(40586147),(26854657),(45805815),(55254117),(43454885),(59073953),(41252470),(28926988)
	 
WHILE @tmpDate <= @CurrentDate
BEGIN
	TRUNCATE TABLE #rptDepWinlost_Main
	TRUNCATE TABLE #bettrans
	TRUNCATE TABLE #Transfer

	SELECT @Yesterday = DATEADD(DAY, -1, @tmpDate)

	INSERT INTO #rptDepWinlost_Main (Custid, OpeningBalance)
	SELECT m.Custid, m.OpeningBalance
	FROM dbo.rptDepWinlost_Main m WITH (NOLOCK)
	WHERE m.Winlostdate = @Yesterday AND m.currency <> 20
		AND NOT EXISTS (SELECT TOP 1 1 FROM bodb02.dbo.Dep_Customer_Archived da WITH(NOLOCK) WHERE m.Custid = da.Custid)
		AND m.custid IN (SELECT Custid FROM  @tbCustId)
	INSERT INTO #bettrans (Custid, OpeningBalance)
	SELECT b.Custid, SUM(b.winlost - b.actual_stake + b.playercomm) AS Winloss
	FROM bodb02.dbo.bettrans b WITH(NOLOCK) 	
	WHERE b.winlostdate < @Yesterday AND winlostdate > @MoveBetsDay
		AND bettype NOT IN (903, 913, 914)
		AND NOT EXISTS (SELECT TOP 1 1 FROM bodb02.dbo.Dep_Customer_Archived da WITH(NOLOCK) WHERE b.Custid = da.Custid)
		AND b.Custid IN (SELECT Custid FROM  @tbCustId)
	GROUP BY b.Custid

	INSERT INTO #Transfer (Custid, OpeningBalance)
	SELECT Custid, SUM(OpeningBalance)
	FROM (
		SELECT b.Custid, SUM(b.winlost - b.actual_stake) AS OpeningBalance
		FROM bodb02.dbo.Transfer b WITH (NOLOCK)
		WHERE bettype >= 20000
			AND b.WinlostDate <= @tmpDate
			AND NOT EXISTS (SELECT TOP 1 1 FROM bodb02.dbo.Dep_Customer_Archived da WITH(NOLOCK) WHERE b.Custid = da.Custid)
			AND b.Custid IN (SELECT Custid FROM  @tbCustId)
			AND 1 = CASE 
						WHEN b.Bettype = 23203 AND b.WinlostDate <= @tmpDate THEN 1 
						WHEN b.Bettype <> 23203 AND b.WinlostDate < @Yesterday THEN 1 
						ELSE 0 
					END
		GROUP BY b.Custid
		UNION ALL
		SELECT b.Custid, SUM(b.winlost - b.actual_stake + b.PlayerComm) AS OpeningBalance
		FROM #rptDepWinlost_Main r
			INNER LOOP JOIN bodb02.dbo.Transfer b WITH (NOLOCK) ON r.Custid = b.Custid -- force index seek on Custid
		WHERE bettype = 19999
			AND b.WinlostDate <= @MoveBetsDay
		GROUP BY b.Custid
	) t
	GROUP BY Custid

	INSERT INTO #Result (Custid, OpeningBalance_DepWL, OpeningBalance_Bettrans, Winlostdate)
	SELECT	r.Custid, r.OpeningBalance, 
			ISNULL(b.OpeningBalance, 0) + ISNULL(t.OpeningBalance, 0) - ISNULL(c.Winloss, 0),
			@tmpDate
	FROM #rptDepWinlost_Main r
		LEFT JOIN #bettrans b ON r.Custid = b.Custid
		LEFT JOIN #Transfer t ON r.Custid = t.Custid
		LEFT JOIN #rptTradeCustWinlost c ON r.Custid = c.Custid
	WHERE (b.Custid IS NOT NULL OR t.Custid IS NOT NULL)
		AND (r.OpeningBalance <> ISNULL(b.OpeningBalance, 0) + ISNULL(t.OpeningBalance, 0) - ISNULL(c.Winloss, 0))

	SELECT @tmpDate = DATEADD(d,1,@tmpDate);
END

SELECT * 
INTO #Result1
FROM 
(
	SELECT	Custid, 
			LEAD(r.OpeningBalance_DepWL,1,0)  OVER (PARTITION BY Custid ORDER BY Winlostdate ASC) ClosingBalance_DepWL,
			LEAD(r.OpeningBalance_Bettrans,1,0)  OVER (PARTITION BY Custid ORDER BY Winlostdate ASC) ClosingBalance_Bettrans,
			WinlostDate
	FROM #Result r
) a

CREATE TABLE #temp(
		Custid INT,
		WinlostDate SMALLDATETIME,
		ClosingBalance MONEY,
		ClosingBalanceDiff MONEY,
		DiffAmt MONEY,
		Next_WinlostDate SMALLDATETIME  ,
		OpeningBalanceCorrect MONEY 
		CONSTRAINT PK_custid_date PRIMARY KEY (
			Custid
			,WinlostDate
			,Next_WinlostDate
			));

INSERT INTO #temp (Custid, WinlostDate, ClosingBalance,ClosingBalanceDiff, DiffAmt, Next_WinlostDate,OpeningBalanceCorrect)
SELECT	a.Custid, WinlostDate, ClosingBalance,ClosingBalanceDiff, DiffAmt,
		LEAD(WinlostDate,1,0)  OVER (PARTITION BY a.Custid ORDER BY WinlostDate ASC) Next_WinlostDate	,
		LAG(ClosingBalanceDiff)  OVER (PARTITION BY a.Custid ORDER BY WinlostDate ASC) OpeningBalanceCorrect	
FROM
(
	SELECT	a.Custid,a.WinlostDate,a.ClosingBalance, b.ClosingBalance AS ClosingBalanceDiff,
			b.ClosingBalance - a.ClosingBalance AS DiffAmt
	FROM dbo.rptDepWinlost a 
		INNER JOIN dbo.rptStatement b WITH(NOLOCK) 
			ON a.Custid = b.Custid AND a.WinlostDate = b.winlostdate
	WHERE a.ClosingBalance <> b.ClosingBalance
		AND a.custid IN (SELECT Custid FROM  @tbCustId)
	UNION ALL
	SELECT	a.Custid,a.WinlostDate,a.ClosingBalance,b.ClosingBalance AS ClosingBalanceDiff, b.ClosingBalance - a.ClosingBalance AS DiffAmt
	FROM dbo.rptDepWinlost_BK a WITH(NOLOCK)
	INNER JOIN dbo.rptStatement_Old b WITH(NOLOCK) 
		ON a.Custid = b.Custid AND a.WinlostDate = b.winlostdate
	WHERE a.ClosingBalance <> b.ClosingBalance
		AND a.winlostdate >= '20220922'
		AND a.custid IN (SELECT Custid FROM  @tbCustId)
	UNION ALL
	SELECT	a.Custid,a.WinlostDate,a.ClosingBalance,b.ClosingBalance AS ClosingBalanceDiff,b.ClosingBalance - a.ClosingBalance AS DiffAmt 
	FROM dbo.rptDepWinlost a 
		INNER JOIN dbo.rptStatement_Old b WITH(NOLOCK) 
			ON a.Custid = b.Custid AND a.WinlostDate = b.winlostdate
	WHERE a.ClosingBalance <> b.ClosingBalance
		AND a.winlostdate >= '20220922'	
		AND a.custid IN (SELECT Custid FROM  @tbCustId)
	UNION ALL
	SELECT a.Custid, a.Winlostdate, ClosingBalance_DepWL AS ClosingBalance, ClosingBalance_Bettrans AS ClosingBalanceDiff , ClosingBalance_Bettrans - ClosingBalance_DepWL  AS DiffAmt
	FROM dbo.rptDepWinlost a 
		INNER JOIN #Result1 b ON a.Custid = b.Custid AND a.WinlostDate = b.WinlostDate
	WHERE a.ClosingBalance <> b.ClosingBalance_Bettrans
) a

--	INNER JOIN bodb02.dbo.custInfo c WITH(NOLOCK) ON a.Custid = c.Custid
--WHERE 
--	c.mrecommend IN ( 
--						SELECT Custid 
--						FROM bodb02.dbo.custInfo WITH(NOLOCK) 
--						WHERE Username LIKE '%ACC%' 
--							AND Roleid=3 
--					)

UPDATE a 
SET a.ClosingBalance = b.ClosingBalanceDiff, 
	a.OpeningBalance = CASE WHEN b.OpeningBalanceCorrect IS NULL THEN a.OpeningBalance ELSE b.OpeningBalanceCorrect  END,
	a.Deposit = CASE WHEN DiffAmt > 0 AND b.OpeningBalanceCorrect IS NULL THEN a.Deposit + ABS(DiffAmt) ELSE a.Deposit END,
	a.Withdrawal = CASE WHEN DiffAmt < 0 AND b.OpeningBalanceCorrect IS NULL THEN a.Withdrawal + ABS(DiffAmt) ELSE  a.Withdrawal END
FROM dbo.rptDepWinlost_BK a WITH(ROWLOCK) 
	INNER JOIN #temp b ON a.Custid = b.Custid AND a.winlostdate = b.WinlostDate

UPDATE a 
SET a.OpeningBalance = b.ClosingBalanceDiff 
FROM dbo.rptDepWinlost_Main a WITH (NOLOCK)
	INNER JOIN #temp b ON a.Custid = b.Custid AND a.winlostdate = b.Next_WinlostDate
	 
UPDATE a 
SET a.Deposit = CASE WHEN DiffAmt > 0 AND b.OpeningBalanceCorrect IS NULL THEN a.Deposit + ABS(DiffAmt) ELSE a.Deposit END,
	a.Withdrawal = CASE WHEN DiffAmt < 0 AND b.OpeningBalanceCorrect IS NULL THEN a.Withdrawal + ABS(DiffAmt) ELSE  a.Withdrawal END
FROM dbo.rptDepWinlost_Trans a WITH(ROWLOCK) 
	INNER JOIN #temp b ON a.Custid = b.Custid AND a.winlostdate = b.WinlostDate


DROP TABLE #temp
DROP TABLE #Result
DROP TABLE #Result1
DROP TABLE #bettrans 
DROP TABLE #Transfer 
DROP TABLE #rptTradeCustWinlost 
DROP TABLE #rptDepWinlost_Main
