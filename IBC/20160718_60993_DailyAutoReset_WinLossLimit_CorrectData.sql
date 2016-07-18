/*
	Created: Elodie
	Task: Voidbridge - "Daily Auto Reset" job only clears yesterday data instead of yesterday data backward [Redimine:60993]
	DB: DBTXN/bodb02
	Date: 20160718
*/ 

USE [bodb02]
GO

DECLARE @sporttype SMALLINT = -1
	, @bettype SMALLINT = 1101
	--, @bettype SMALLINT = 1701
	--, @bettype SMALLINT = 2101
	--, @bettype SMALLINT = 4001

SET NOCOUNT ON	
CREATE TABLE #WeeklyResetCustomer(custid INT, srecommend INT)

IF @bettype = 1101 --LiveCS
BEGIN
	INSERT INTO #WeeklyResetCustomer(custid, srecommend)
	SELECT custid, srecommend
	FROM CustDB.dbo.custinfo WITH (NOLOCK)
	WHERE roleid = 1 AND MaxWinLiveCasino > 0 AND isAutoResetLiveCasino = 0
END
ELSE IF @bettype IN (1701,2101) --GoldDeluxe & OneRNG
BEGIN
	INSERT INTO #WeeklyResetCustomer(custid, srecommend)
	SELECT c.custid, srecommend
	FROM CustDB.dbo.custinfo c WITH (NOLOCK)
		INNER JOIN DBCUST.CustDB.dbo.CustWinLimit cwl WITH (NOLOCK) ON cwl.CustId = c.custid AND cwl.sporttype = @sporttype AND cwl.bettype = @bettype
	WHERE c.roleid = 1 AND IsAutoReset = 0 AND ((BetType = 1701 AND MaxWinlimit > 0) OR BetType = 2101)
	
END
ELSE --others DCS products
BEGIN
	INSERT INTO #WeeklyResetCustomer(custid, srecommend)
	SELECT c.custid, srecommend
	FROM CustDB.dbo.custinfo c WITH (NOLOCK)
		INNER JOIN DBCUST.CustDB.dbo.CustWinLossLimit_Member cwl WITH (NOLOCK) ON cwl.CustId = c.custid AND cwl.sporttype = @sporttype AND cwl.bettype = @bettype
	WHERE c.roleid = 1 AND IsAutoReset = 0
	
END

DECLARE @Yesterday SMALLDATETIME
SET @Yesterday = DATEADD(dd, -1, CAST(GETDATE() AS DATE))

--delete yesterday balance for daily reset and unlimited balance
WHILE 1 = 1
BEGIN
	DELETE TOP (50000) bal
	FROM dbo.BalanceCreditGame bal WITH (ROWLOCK)
		LEFT JOIN #WeeklyResetCustomer t ON bal.CustId = t.CustId
	WHERE winlostdate <= @Yesterday AND bettype = @bettype
		 AND t.CustId IS NULL
	OPTION (MAXDOP 4)
		
	IF @@ROWCOUNT < 50000
		BREAK
			
	WAITFOR DELAY '00:00:00.280'
END

WHILE 1 = 1
BEGIN
	DELETE TOP (50000) bal
	FROM dbo.BalanceDebitGame bal WITH (ROWLOCK)
		LEFT JOIN #WeeklyResetCustomer t ON bal.CustId = t.CustId
	WHERE winlostdate <= @Yesterday AND bettype = @bettype
		 AND t.CustId IS NULL
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
				INNER JOIN #WeeklyResetCustomer t ON bal.CustId = t.custid AND bal.bettype = @bettype AND winlostdate = @Yesterday
		)
BEGIN
	WHILE 1 = 1
	BEGIN
		DELETE TOP (50000) bal
		FROM dbo.BalanceCreditGame bal WITH (ROWLOCK)
			INNER JOIN #WeeklyResetCustomer t ON bal.CustId = t.custid AND bal.bettype = @bettype AND winlostdate = @Yesterday
		
		IF @@ROWCOUNT < 50000
			BREAK
			
		WAITFOR DELAY '00:00:00.280'
	END
END

IF EXISTS (SELECT TOP 1 1 FROM dbo.BalanceDebitGame bal WITH(NOLOCK)
				INNER JOIN #WeeklyResetCustomer t ON bal.CustId = t.custid AND bal.bettype = @bettype AND winlostdate = @Yesterday
		)
BEGIN
	WHILE 1 = 1
	BEGIN
		DELETE TOP (50000) bal
		FROM dbo.BalanceDebitGame bal WITH (ROWLOCK)
			INNER JOIN #WeeklyResetCustomer t ON bal.CustId = t.custid AND bal.bettype = @bettype AND winlostdate = @Yesterday
		
		IF @@ROWCOUNT < 50000
			BREAK
			
		WAITFOR DELAY '00:00:00.280'
	END
END	

DROP TABLE #WeeklyResetCustomer