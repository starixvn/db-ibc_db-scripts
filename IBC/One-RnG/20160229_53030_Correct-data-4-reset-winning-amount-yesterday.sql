USE bodb02
GO
/*
	https://redmine.nexcel.vn/issues/53030
	- Correct data for reset winning amount

	Run on DBTXN
*/
DECLARE @sporttype SMALLINT
	, @bettype SMALLINT

SELECT @sporttype = 208, @bettype = 2101

CREATE TABLE #WeeklyResetCustomer(custid INT, srecommend INT)

INSERT INTO #WeeklyResetCustomer(custid, srecommend)
	SELECT c.custid, srecommend
	FROM CustDB.dbo.custinfo c WITH (NOLOCK)
		INNER JOIN DBCUST.CustDB.dbo.CustWinLimit cwl WITH (NOLOCK) 
			ON cwl.CustId = c.custid 
				AND cwl.sporttype = @sporttype
				AND cwl.bettype = @bettype
	WHERE c.roleid = 1 AND IsAutoReset = 0 --AND ((BetType = 1701 AND MaxWinlimit > 0) OR BetType = 2101)

DECLARE @Yesterday SMALLDATETIME
SET @Yesterday = DATEADD(dd, -1, CAST(GETDATE() AS DATE))

--delete yesterday balance for daily reset and unlimited balance
WHILE 1 = 1
BEGIN
	DELETE TOP (50000) bal
	FROM dbo.BalanceCreditGame bal WITH (ROWLOCK)
	WHERE NOT EXISTS (SELECT TOP 1 1 
						FROM #WeeklyResetCustomer t 
						WHERE bal.CustId = t.CustId	AND winlostdate BETWEEN '2016-01-27' AND @Yesterday AND bettype = @bettype)
	OPTION (MAXDOP 4)
		
	IF @@ROWCOUNT < 50000
		BREAK
			
	WAITFOR DELAY '00:00:00.280'
END

WHILE 1 = 1
BEGIN
	DELETE TOP (50000) bal
	FROM dbo.BalanceDebitGame bal WITH (ROWLOCK)
	WHERE NOT EXISTS (SELECT TOP 1 1 
						FROM #WeeklyResetCustomer t 
						WHERE bal.CustId = t.CustId	AND winlostdate BETWEEN '2016-01-27' AND @Yesterday AND bettype = @bettype)
	OPTION (MAXDOP 4)
		
	IF @@ROWCOUNT < 50000
		BREAK
			
	WAITFOR DELAY '00:00:00.280'
END

--remove credit account
DELETE t
FROM #WeeklyResetCustomer t
	LEFT JOIN CustDB.dbo.Dep_CustSuper s WITH(NOLOCK) ON t.srecommend = s.custid
WHERE s.custid IS NULL

IF NOT EXISTS (SELECT TOP 1 1 FROM #WeeklyResetCustomer)
BEGIN
	DROP TABLE #WeeklyResetCustomer
	RETURN
END

--remove deposit account
IF EXISTS (SELECT TOP 1 1 FROM dbo.BalanceCreditGame bal WITH(NOLOCK)
				INNER JOIN #WeeklyResetCustomer t 
					ON bal.CustId = t.custid 
						AND bal.bettype = @bettype 
						AND winlostdate BETWEEN '2016-01-27' AND @Yesterday
		)
BEGIN
	WHILE 1 = 1
	BEGIN
		DELETE TOP (50000) bal
		FROM dbo.BalanceCreditGame bal WITH (ROWLOCK)
			INNER JOIN #WeeklyResetCustomer t 
				ON bal.CustId = t.custid 
					AND bal.bettype = @bettype 
					AND winlostdate BETWEEN '2016-01-27' AND @Yesterday
		
		IF @@ROWCOUNT < 50000
			BREAK
			
		WAITFOR DELAY '00:00:00.280'
	END
END

IF EXISTS (SELECT TOP 1 1 FROM dbo.BalanceDebitGame bal WITH(NOLOCK)
				INNER JOIN #WeeklyResetCustomer t 
					ON bal.CustId = t.custid 
						AND bal.bettype = @bettype 
						AND winlostdate BETWEEN '2016-01-27' AND @Yesterday
		)
BEGIN
	WHILE 1 = 1
	BEGIN
		DELETE TOP (50000) bal
		FROM dbo.BalanceDebitGame bal WITH (ROWLOCK)
			INNER JOIN #WeeklyResetCustomer t 
				ON bal.CustId = t.custid 
					AND bal.bettype = @bettype 
					AND winlostdate BETWEEN '2016-01-27' AND @Yesterday
		
		IF @@ROWCOUNT < 50000
			BREAK
			
		WAITFOR DELAY '00:00:00.280'
	END
END	

DROP TABLE #WeeklyResetCustomer

GO
