/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20210727@Percy
	DB: DBLIC-bodb_LicenseeReport
	Task: rptLicWinloss2 - Add column apositiontaking
	https://nexdev.net/issues/155593

	Step 3: Re-gen data on bettrans14
*/

use bodb_LicenseeReport
go

declare @MBBU table (BalanceUpDay smalldatetime, MoveBetsDay smalldatetime)
insert into @MBBU (BalanceUpDay, MoveBetsDay)
exec bodb02.dbo.Age_SelBalanceUpDay

declare @BalanceUpDay smalldatetime, @MoveBetsDay smalldatetime, @Msg varchar(200)
select  @BalanceUpDay = BalanceUpDay, @MoveBetsDay = MoveBetsDay from @MBBU

declare @winlostdate smalldatetime = @BalanceUpday

while @winlostdate <= @MoveBetsDay
begin
	exec dbo.Task_DailyRptLicWinloss2 @WinLostDate = @WinLostDate
	select @winlostdate = dateadd(day, 1, @winlostdate)

	waitfor delay '00:00:00.280'
end
