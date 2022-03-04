/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220210@Percy
	DB: DBN88-bodb_N88
	Task: N88_SumWinloss - Manually regen data Jan 2022
*/

USE bodb_N88
GO

DECLARE @WinlostDate SMALLDATETIME = '2022-01-01'

WHILE @WinlostDate <= '2022-01-31'
BEGIN
	EXEC dbo.Task_N88_SumWinloss @WinlostDate = @WinlostDate

	SET @WinlostDate = DATEADD(DAY, 1, @WinlostDate)
END