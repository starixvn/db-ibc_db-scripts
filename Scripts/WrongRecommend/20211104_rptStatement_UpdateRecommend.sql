/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20211104@Percy
	DB: DBRPT-bodb_Report
	Task: Manually correct recommend
*/
USE bodb_Report
GO

-- rptStatement
DECLARE @WinlostDate SMALLDATETIME = '2021-10-27'
WHILE @WinlostDate <= '2021-10-31' -- current MB
BEGIN
	EXEC dbo.Task_rptStatement_14
		@WinlostDate = @WinlostDate
		,@CustIds = '56714005,56948091,56979121,57047362' -- 1 custid for 1 recommend

	SET @WinlostDate = DATEADD(DAY, 1, @WinlostDate)
END
GO

-- rptTotalBalance_Active
-- Step 1: Update data on 2021-10-31 (Saturday = current MB)
DECLARE @rptStatement TABLE (CustId INT, OpeningBalance MONEY, OpeningTotalBalance MONEY)

INSERT INTO @rptStatement (CustId, OpeningBalance, OpeningTotalBalance)
SELECT CustId, OpeningBalance, OpeningTotalBalance
FROM dbo.rptStatement WITH (NOLOCK)
WHERE WinlostDate = '2021-10-31' -- current MB
	AND CustId IN (56713984, 56713996, 56948071, 56948082) -- recommend

UPDATE a WITH (ROWLOCK)
SET a.OpeningBalance = r.OpeningBalance, a.OpeningTotalBalance = r.OpeningTotalBalance
FROM dbo.rptTotalBalance_Active a
	INNER JOIN @rptStatement r ON a.CustId = r.CustId
WHERE a.WinlostDate = '2021-10-31' -- current MB
	AND a.CustId IN (56713984, 56713996, 56948071, 56948082) -- recommend

-- Step 2: Update data from 2021-11-01 to 2021-11-04 (today)
DECLARE @WinlostDate SMALLDATETIME = '2021-11-01'
WHILE @WinlostDate <= '2021-11-04'
BEGIN
	EXEC dbo.Task_DailyRptTotalBalance_Active @WinlostDate = @WinlostDate

	SET @WinlostDate = DATEADD(DAY, 1, @WinlostDate)
END
GO
