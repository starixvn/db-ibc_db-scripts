/*<info serverAlias="DBN88-bodb_N88"></info>*/

/*
	Created: 20210413@Percy
	DB: DBN88-bodb_N88
	Task: B2C - Regen winloss data for Feb & Mar 2021
	https://nexdev.net/issues/153403

*/
use bodb_N88
go

declare @WinlostDate smalldatetime = '2021-02-01'
declare @msg varchar(100)

while @WinlostDate <= '2021-03-31'
begin
	set @msg = 'start date: ' + convert(varchar(10), @WinlostDate, 120)
	raiserror (@msg, 0, 1) with nowait

	exec dbo.Task_N88_SumWinloss @WinlostDate

	set @WinlostDate = dateadd(day, 1, @WinlostDate)

	waitfor delay '00:00:00.280'
end