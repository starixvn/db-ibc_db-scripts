/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20211102@Percy
	DB: DBN88-bodb_N88
	Task: Regen data for BonusId column
	https://nexdev.net/issues/164141
*/
USE bodb_N88
GO

DECLARE @WinlostDate SMALLDATETIME = '2020-08-13' -- Bonus's released date
DECLARE @Msg VARCHAR(200)

WHILE @WinlostDate <= '2021-10-31'
BEGIN
	SET @Msg = 'Start Date: ' + CONVERT(VARCHAR(10), @WinlostDate, 120)
	RAISERROR(@Msg, 1, 0) WITH NOWAIT

	EXEC dbo.Task_N88_SumWinloss @WinlostDate = @WinlostDate

	WAITFOR DELAY '00:00:00.280'

	SET @WinlostDate = DATEADD(DAY, 1, @WinlostDate)
END