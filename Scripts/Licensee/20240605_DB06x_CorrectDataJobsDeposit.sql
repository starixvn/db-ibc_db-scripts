/*<info serverAlias="DBRPT-bodb_Report" isFunction="0" isNested=""></info>*/

/*
    Created: 20240604@Evan
    DB: DBRPT-bodb_Report
    Task: Reactivation - Check & fix rounded data issue [Redmine: 179084]
    Run on DB061,DB062
*/  

DROP TABLE IF EXISTS #DiffData

CREATE TABLE #DiffData (
	  CustId INT
	, recommend INT
	, Diff_Deposit MONEY
	, Diff_Withdrawal MONEY
	, WinlostDate SMALLDATETIME -- Date of detection diff data
	, Isfinished BIT DEFAULT (0)
)

INSERT INTO #DiffData (CustId, WinlostDate)
VALUES (45805815, '2022-09-22 00:00:00'),
(59073953, '2022-09-22 00:00:00'),
(45840936, '2022-09-22 00:00:00'),
(26854657, '2022-09-22 00:00:00'),
(32657300, '2022-09-22 00:00:00'),
(56506786, '2022-09-22 00:00:00'),
(28926988, '2022-09-22 00:00:00'),
(40586147, '2022-09-22 00:00:00'),
(65688165, '2022-09-22 00:00:00'),
(41799217, '2022-09-22 00:00:00'),
(55254117, '2022-09-22 00:00:00'),
(43054420, '2022-09-22 00:00:00'),
(43454885, '2022-09-22 00:00:00'),
(41252470, '2022-09-22 00:00:00'),
(41799123, '2022-09-22 00:00:00'),
(16379951, '2022-09-22 00:00:00')

UPDATE a
SET a.recommend = b.recommend
FROM #DiffData a
	INNER JOIN bodb02..custInfo b (NOLOCK) ON a.custid = b.custid

;
WITH cte_correct AS
(
	SELECT a.Custid
		 , a.WinlostDate
		 , c1.Deposit Deposit
		 , c1.Withdrawal Withdrawal
		 , c1.Deposit - a.Deposit Diff_Deposit
		 , c1.Withdrawal - a.Withdrawal Diff_Withdrawal
	FROM bodb_Report..rptDepWinlost_bk a WITH (NOLOCK)
		INNER JOIN #DiffData b ON a.custid = b.custid
			AND a.winlostdate = b.WinlostDate
		CROSS APPLY (
			SELECT -ISNULL(SUM(CASE
					   WHEN t.Bettype = 22001 THEN Debit - Credit
					   ELSE 0
				   END), 0) Deposit,
				   -ISNULL(-SUM(CASE
					   WHEN t.Bettype IN (22002, 22003) THEN Debit - Credit
					   ELSE 0
				   END), 0) Withdrawal
			FROM bodb_Archive.dbo.transfer_bk t WITH (NOLOCK)
			WHERE t.custid = b.custid
				AND t.winlostdate = b.WinlostDate
		) c1
)
UPDATE a 
SET a.Diff_Deposit = b.Diff_Deposit, a.Diff_Withdrawal = b.Diff_Withdrawal
FROM #DiffData a INNER JOIN cte_correct b ON b.Custid = a.Custid AND a.WinlostDate = b.WinlostDate

UPDATE a 
SET a.Deposit = a.Deposit + Diff_Deposit
	, a.Withdrawal = a.Withdrawal + Diff_Withdrawal
FROM dbo.rptDepWinlost_bk a WITH(ROWLOCK)
	INNER JOIN #DiffData b ON  b.Custid = a.Custid AND a.WinlostDate = b.WinlostDate
	
UPDATE a 
SET a.Deposit = a.Deposit + Diff_Deposit
	, a.Withdrawal = a.Withdrawal + Diff_Withdrawal
FROM dbo.rptDepwinlost_SUM a WITH(ROWLOCK)
	INNER JOIN #DiffData b ON  b.recommend = a.recommend AND a.WinlostDate = b.WinlostDate

    
    
    
    