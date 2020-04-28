USE bodb02
GO

/*
	Created: 20200427@Percy
	DB: DBACC.bodb02
	Task: rptWinlost - Correct data on bettrans14 range (from 17 to 19 Apr)
*/

BEGIN
	DECLARE @FromDate SMALLDATETIME, @ToDate SMALLDATETIME
	SELECT  @FromDate = '2020-04-17', @ToDate = '2020-04-19'

	DECLARE @winlostdate SMALLDATETIME, @ErrMsg VARCHAR(200)
	SELECT  @winlostdate = @FromDate

	WHILE @winlostdate <= @ToDate
	BEGIN
		SELECT @ErrMsg = 'winlostdate = ' + CONVERT(VARCHAR(10), @winlostdate, 120)
		RAISERROR(@ErrMsg, 0, 1) WITH NOWAIT

		EXEC dbo.Task_rptWinLost_UpdateTable @winlostdate = @winlostdate

		SELECT @winlostdate = DATEADD(DAY, 1, @winlostdate)

		WAITFOR DELAY '00:00:00.280'
	END
END