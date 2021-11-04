/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20211104@Percy
	DB: DBRPT-bodb_Report
	Task: Manually correct recommend
*/
USE bodb_Report
GO

-- rptDepWinlost_Main
UPDATE r WITH (ROWLOCK)
SET r.recommend = c.recommend
FROM dbo.rptDepWinlost_Main r
	INNER JOIN bodb02.dbo.Customer c WITH (NOLOCK) ON r.CustId = c.CustId
WHERE r.WinlostDate >= '2021-10-27'
	AND r.recommend IN (56713984, 56713996, 56948071, 56948082)
GO

-- rptDepWinlost_SUM/rptDepWinlostByProduct_SUM
DECLARE @date SMALLDATETIME = '2021-10-27'
WHILE @date <= '2021-11-04'
BEGIN
	EXEC dbo.Task_DepWinlostSUM @date = @date

	SET @date = DATEADD(DAY, 1, @date)
END
GO