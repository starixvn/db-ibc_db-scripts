/*<info serverAlias="DBRPT-bodb_Report" isFunction="0" isNested=""></info>*/

/*
	Created: 20221020@Evan
	DB: DBRPT-bodb_Report
	Task: Reactivation - Check & fix rounded data issue [Redmine: 179084]

*/

SET NOCOUNT ON

-- Get movebet, current & Yesterday 
DECLARE @CurrentDate DATE, @Yesterday DATE
SELECT  @CurrentDate = CONVERT(DATE, CURRENT_TIMESTAMP, 112), @Yesterday = DATEADD(DAY, -1, @CurrentDate)

DECLARE @MBBU TABLE (BalanceUpDay SMALLDATETIME, MoveBetsDay SMALLDATETIME)
INSERT INTO @MBBU (BalanceUpDay, MoveBetsDay)
EXEC bodb02.dbo.Age_SelBalanceUpDay
	
DECLARE @MoveBetsDay SMALLDATETIME
SELECT  @MoveBetsDay = MoveBetsDay FROM @MBBU

-- Check data get list Custid with diff balance table sum depwl & bettrans...  
CREATE TABLE #rptDepWinlost_Main (CustId INT PRIMARY KEY, OpeningBalance MONEY)
INSERT INTO #rptDepWinlost_Main (CustId, OpeningBalance)
SELECT m.CustID, m.OpeningBalance
FROM dbo.rptDepWinlost_Main m WITH (NOLOCK)
WHERE m.Winlostdate = @Yesterday AND m.currency <> 20
	AND NOT EXISTS (SELECT TOP 1 1 FROM bodb02.dbo.Dep_Customer_Archived da WITH(NOLOCK) WHERE m.CustID = da.CustID)

CREATE TABLE #rptTradeCustWinlost (CustId INT PRIMARY KEY, Winloss MONEY)
INSERT INTO #rptTradeCustWinlost (CustId, Winloss)
SELECT CustID, SUM(Winloss) AS Winloss
FROM dbo.rptTradeCustWinlost ta WITH (NOLOCK)
WHERE NOT EXISTS (SELECT TOP 1 1 FROM bodb02.dbo.Dep_Customer_Archived da WITH(NOLOCK) WHERE ta.CustID = da.CustID)
GROUP BY CustID

CREATE TABLE #bettrans (CustId INT PRIMARY KEY, OpeningBalance MONEY, Winlostdate SMALLDATETIME)
INSERT INTO #bettrans (CustId, OpeningBalance)
SELECT CustID, SUM(b.winlost - b.actual_stake + b.playercomm) AS Winloss
FROM bodb02.dbo.bettrans b WITH(NOLOCK) 					
WHERE b.winlostdate < @Yesterday AND winlostdate > @MoveBetsDay
	AND bettype NOT IN (903, 913, 914)
	AND NOT EXISTS (SELECT TOP 1 1 FROM bodb02.dbo.Dep_Customer_Archived da WITH(NOLOCK) WHERE b.CustID = da.CustID)
GROUP BY b.custid

CREATE TABLE #Transfer (CustId INT PRIMARY KEY, OpeningBalance MONEY)
INSERT INTO #Transfer (CustId, OpeningBalance)
SELECT CustId, SUM(OpeningBalance)
FROM (
	SELECT b.CustID, SUM(b.winlost - b.actual_stake) AS OpeningBalance
	FROM bodb02.dbo.Transfer b WITH (NOLOCK)
	WHERE bettype >= 20000
		AND b.WinlostDate <= @CurrentDate
	    AND NOT EXISTS (SELECT TOP 1 1 FROM bodb02.dbo.Dep_Customer_Archived da WITH(NOLOCK) WHERE b.CustID = da.CustID)
		AND 1 = CASE 
					WHEN b.Bettype = 23203 AND b.WinlostDate <= @CurrentDate THEN 1 
					WHEN b.Bettype <> 23203 AND b.WinlostDate < @Yesterday THEN 1 
					ELSE 0 
				END
	GROUP BY CustID
	UNION ALL
	SELECT b.CustID, SUM(b.winlost - b.actual_stake + b.PlayerComm) AS OpeningBalance
	FROM #rptDepWinlost_Main r
		INNER LOOP JOIN bodb02.dbo.Transfer b WITH (NOLOCK) ON r.CustId = b.CustId -- force index seek on CustId
	WHERE bettype = 19999
		AND b.WinlostDate <= @MoveBetsDay
	GROUP BY b.CustID
) t
GROUP BY CustId

CREATE TABLE #Result (CustID INT, OpeningBalance_DepWL MONEY, OpeningBalance_Bettrans MONEY)

INSERT INTO #Result (CustID, OpeningBalance_DepWL, OpeningBalance_Bettrans)
SELECT r.CustID, r.OpeningBalance, ISNULL(b.OpeningBalance, 0) + ISNULL(t.OpeningBalance, 0) - ISNULL(c.Winloss, 0)
FROM #rptDepWinlost_Main r
	LEFT JOIN #bettrans b ON r.CustId = b.CustId
	LEFT JOIN #Transfer t ON r.CustId = t.CustId
	LEFT JOIN #rptTradeCustWinlost c ON r.CustID = c.CustID
WHERE (b.CustId IS NOT NULL OR t.CustId IS NOT NULL) 
	AND (r.OpeningBalance <> ISNULL(b.OpeningBalance, 0) + ISNULL(t.OpeningBalance, 0) - ISNULL(c.Winloss, 0))


-- Get winlostdate when diff balance happen
CREATE TABLE #UpdListCust (CustID INT, Winlostdate	SMALLDATETIME, DiffAmt MONEY)

;WITH cte_Cust AS (
	SELECT MIN(a.winlostdate) Winlostdate , a.Custid
	FROM dbo.rptDepWinlost_BK a WITH(NOLOCK)
		INNER JOIN dbo.rptStatement_Old b WITH(NOLOCK) ON a.Custid = b.Custid AND a.WinlostDate = b.winlostdate
	WHERE a.ClosingBalance <> b.ClosingBalance 
		AND EXISTS (SELECT TOP 1 1 FROM #Result r WHERE r.CustID = b.Custid)
	GROUP BY a.Custid
)
INSERT INTO #UpdListCust (CustID, Winlostdate, DiffAmt)
SELECT Custid, Winlostdate, 0
FROM cte_Cust

;WITH cte_Cust AS (
	SELECT MIN(a.winlostdate) Winlostdate , a.Custid
	FROM dbo.rptDepWinlost a WITH(NOLOCK)
		INNER JOIN dbo.rptStatement b WITH(NOLOCK) ON a.Custid = b.Custid AND a.WinlostDate = b.winlostdate
	WHERE a.ClosingBalance <> b.ClosingBalance 
		AND EXISTS (SELECT TOP 1 1 FROM #Result r WHERE r.CustID = b.Custid)
	GROUP BY a.Custid
)
INSERT INTO #UpdListCust (CustID, Winlostdate, DiffAmt)
SELECT a.Custid, a.Winlostdate, 0
FROM cte_Cust a LEFT JOIN #UpdListCust b ON a.CustID = b.CustID
WHERE b.CustID IS NULL

UPDATE a 
SET a.DiffAmt = OpeningBalance_Bettrans - OpeningBalance_DepWL
FROM #UpdListCust a 
	INNER JOIN #Result b ON a.CustID = b.CustID

CREATE TABLE #rptDepWinlost_BK (
	Custid	INT,
	Winlostdate	SMALLDATETIME,
	DiffAmt MONEY,
	Isfinished BIT
)
CREATE TABLE #rptDepWinlost_BK_Sub (
	Custid	INT,
	Winlostdate	SMALLDATETIME,
	DiffAmt MONEY
)
INSERT INTO #rptDepWinlost_BK (winlostdate,custid,DiffAmt)
SELECT a.winlostdate, a.custid, b.DiffAmt
FROM dbo.rptDepWinlost_BK a WITH(ROWLOCK) 
		INNER JOIN #UpdListCust b ON a.custid = b.CustID AND a.winlostdate >= b.Winlostdate  

-- UPDATE: correct balance table depWL
-- Part 1 - rptDepWinlost_BK
WHILE (1 = 1)
BEGIN

	UPDATE TOP (1000) a
	SET a.Isfinished = 1 
	OUTPUT deleted.CustID, deleted.Winlostdate, deleted.DiffAmt INTO #rptDepWinlost_BK_Sub(custid,winlostdate,DiffAmt)
	FROM #rptDepWinlost_BK a
	WHERE Isfinished IS NULL
			
	IF @@ROWCOUNT = 0
		BREAK
	
	UPDATE a 
	SET a.ClosingBalance = a.ClosingBalance + DiffAmt, 
		a.OpeningBalance = CASE WHEN a.winlostdate >= DATEADD(dd,1,b.Winlostdate) THEN a.OpeningBalance + DiffAmt ELSE a.OpeningBalance  END,
		a.Deposit = CASE WHEN a.winlostdate = b.Winlostdate THEN a.Deposit + DiffAmt ELSE a.Deposit END
	FROM dbo.rptDepWinlost_BK a WITH(ROWLOCK) 
		INNER JOIN #rptDepWinlost_BK_Sub b ON a.custid = b.CustID AND a.winlostdate >= b.Winlostdate 

	TRUNCATE TABLE #rptDepWinlost_BK_Sub

END

-- Part 2 - rptDepWinlost_Main

INSERT INTO #rptDepWinlost_BK (CustID, Winlostdate,DiffAmt)
SELECT a.CustID, a.Winlostdate , OpeningBalance_Bettrans - OpeningBalance_DepWL
FROM dbo.rptDepWinlost_Main a WITH(NOLOCK) 
	INNER JOIN #Result b ON a.CustID = b.CustID
WHERE Winlostdate <= @CurrentDate

WHILE (1 = 1)
BEGIN
	
	UPDATE TOP (1000) a
	SET a.Isfinished = 1 
	OUTPUT deleted.CustID, deleted.Winlostdate, deleted.DiffAmt INTO #rptDepWinlost_BK_Sub(custid,winlostdate,DiffAmt)
	FROM #rptDepWinlost_BK a
	WHERE Isfinished IS NULL

	IF @@ROWCOUNT = 0
		BREAK

	UPDATE a 
	SET a.OpeningBalance = a.OpeningBalance + DiffAmt
	FROM dbo.rptDepWinlost_Main a WITH (ROWLOCK)
		INNER JOIN #rptDepWinlost_BK_Sub b ON a.custid = b.CustID AND a.winlostdate = b.Winlostdate 

	TRUNCATE TABLE #rptDepWinlost_BK_Sub
	
END

 
DROP TABLE #bettrans
DROP TABLE #Result
DROP TABLE #rptDepWinlost_Main
DROP TABLE #rptTradeCustWinlost
DROP TABLE #Transfer
DROP TABLE #UpdListCust
DROP TABLE #rptDepWinlost_BK_Sub
DROP TABLE #rptDepWinlost_BK

GO
