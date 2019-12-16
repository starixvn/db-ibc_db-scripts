USE bodb_report
GO

/*
	Created: 20191216@Percy
	DB: DBRPT.bodb_Report
	Task: Delete data on rptStatement from Old BU to New BU -1
*/

DECLARE @BalanceUpDay DATETIME, @TempDate DATETIME, @count INT
SELECT  @BalanceUpDay = '2019-12-06' -- EXECUTE	bodb02.dbo.Age_SelBalanceUpDay

SELECT	@count = -7
WHILE	@count < 0
BEGIN
	SELECT	@TempDate = DATEADD(DAY, @Count, @BalanceUpDay) -- delete data from New BUDate - 7 to New BUDate - 1
	EXECUTE	dbo.Task_archive_rptStatement_Delete @TempDate;
	SELECT	@count = @count + 1;
END