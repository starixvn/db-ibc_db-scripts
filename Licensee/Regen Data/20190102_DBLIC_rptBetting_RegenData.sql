use bodb_LicenseeReport
go

/*
	Created: 20190102@Percy
	DB: DBLIC.bodb_LicenseeReport
	Task: Regen data manually due to wrong update BA tickets
*/

exec dbo.Task_PrepareStaging @DateFrom = '2019-12-20', @DateTo = '2020-01-01'
go

exec dbo.GEN_rptBetting @date = '2019-12-20', @date2 = '2020-01-01'
go

declare @winlostdate smalldatetime = '2019-12-20'
while @winlostdate <= '2020-01-01'
begin
	exec dbo.GEN_rptBetting_BA @date = @winlostdate, @date2 = @winlostdate

	select @winlostdate = dateadd(day, 1, @winlostdate)
end
go

declare @winlostdate smalldatetime = '2019-12-20'
while @winlostdate <= '2020-01-01'
begin
	exec dbo.GEN_rptBettingByProduct @date = @winlostdate, @date2 = @winlostdate, @DataSource = 'rpt_Betting'

	select @winlostdate = dateadd(day, 1, @winlostdate)
end
go