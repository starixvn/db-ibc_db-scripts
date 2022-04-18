/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220322@Percy
	DB: DBRPT-bodb_Report
	Task: Regen data on rptDepWinlost
		- Step 4: Regen data for _UAT table
*/
use bodb_Report
go

declare @MBU table (BalanceUpDay smalldatetime, MoveBetsDay smalldatetime)
insert into @MBU (BalanceUpDay, MoveBetsDay)
exec bodb02.dbo.Age_SelBalanceUpDay

declare @BalanceUpDay smalldatetime, @MoveBetsDay smalldatetime
select  @BalanceUpDay = BalanceUpDay, @MoveBetsDay = MoveBetsDay from @MBU

declare @WinlostDate smalldatetime, @i int, @n int, @msg varchar(200)
select  @WinlostDate = min(init_winlostdate) from dbo.rptDepCust_UAT with (nolock)
select  @i = 1, @n = datediff(day, @WinlostDate, @MoveBetsDay) + 1

while @WinlostDate <= @MoveBetsDay
begin
	select @msg = '==> Start ' + convert(varchar(10), @i) + ' / ' + convert(varchar(10), @n) + ' with Date: ' + convert(varchar(10), @WinlostDate, 120)
	print (@msg)
		
	if @WinlostDate < @BalanceUpDay
		exec bodb02.dbo.Task_rptDepwinlost_bk_xtest @WinlostDate = @WinlostDate
	else
		exec bodb02.dbo.Task_rptDepwinlost_14_xtest @WinlostDate = @WinlostDate
		
	set @WinlostDate = dateadd(day, 1, @WinlostDate)
	set @i = @i + 1

	waitfor delay '00:00:00.280'
end
