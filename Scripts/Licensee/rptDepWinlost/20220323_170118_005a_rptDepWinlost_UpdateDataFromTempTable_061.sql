/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220322@Percy
	DB: DBRPT-bodb_Report
	Task: Regen data on rptDepWinlost
		- Step 5a: Regen data to real table - 061
*/
-- run on DB061
use bodb_Report
go

declare @MBU table (BalanceUpDay smalldatetime, MoveBetsDay smalldatetime)
insert into @MBU (BalanceUpDay, MoveBetsDay)
exec bodb02.dbo.Age_SelBalanceUpDay

declare @BalanceUpDay smalldatetime, @MoveBetsDay smalldatetime
select  @BalanceUpDay = BalanceUpDay, @MoveBetsDay = MoveBetsDay from @MBU

declare @CustId int, @fromdate smalldatetime, @i int, @n int, @msg varchar(200)

declare @MinSumDate smalldatetime
select  @MinSumDate = min(winlostdate) from dbo.rptDepWinlost_Main with (nolock)

select @i = 1, @n = count(1) from dbo.rptDepCust_UAT with (nolock)

-- Regen data
set @i = 1
while @i <= @n
begin
	select @CustId = custid, @fromdate = regen_winlostdate from dbo.rptDepCust_UAT with (nolock) where id = @i

	select @msg = '==> Start ' + convert(varchar(10), @i) + ' / ' + convert(varchar(10), @n) + ' with Start Date: ' + convert(varchar(10), @fromdate, 120)
	print (@msg)
		
	-- range bk
		delete dbo.rptDepWinlost_bk with (rowlock) where custid = @CustId and winlostdate >= @fromdate and winlostdate < @MinSumDate
		delete dbo.rptDepWinlostByProduct_bk with (rowlock) where custid = @CustId and winlostdate >= @fromdate and winlostdate < @MinSumDate
		delete dbo.rptDepWinlost_Transfer3rdOthers_bk with (rowlock) where custid = @CustId and winlostdate >= @fromdate and winlostdate < @MinSumDate
		delete dbo.rptDepWinlost_BonusWallet with (rowlock) where custid = @CustId and winlostdate >= @fromdate and winlostdate < @MinSumDate

		insert into dbo.rptDepWinlost_bk (
			winlostdate, custid, currency, OpeningBalance, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover, Outstanding, Winloss, ClosingBalance
			,recommend, mrecommend, srecommend, actualrate, Transfer3rd, DrawGame, Turnover_BA, Comm_BA, AmountDueTo_BA, playercomm, Transfer3rdOthers, Comm_BetTrade
			,AmountDueTo_BetTrade, Promotion
		)
		select
			winlostdate, custid, currency, OpeningBalance, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover, Outstanding, Winloss, ClosingBalance
			,recommend, mrecommend, srecommend, actualrate, Transfer3rd, DrawGame, Turnover_BA, Comm_BA, AmountDueTo_BA, playercomm, Transfer3rdOthers, Comm_BetTrade
			,AmountDueTo_BetTrade, Promotion
		from dbo.rptDepWinlost_UAT with (nolock)
		where custid = @CustId and winlostdate >= @fromdate and winlostdate < @MinSumDate

		insert into dbo.rptDepWinlostByProduct_bk (winlostdate, custid, sporttype, turnover, drawTO, winlost, playercomm, BetCount, Outstanding, currency)
		select winlostdate, custid, sporttype, turnover, drawTO, winlost, playercomm, BetCount, Outstanding, currency
		from dbo.rptDepWinlostByProduct_UAT with (nolock)
		where custid = @CustId and winlostdate >= @fromdate and winlostdate < @MinSumDate

		insert into dbo.rptDepWinlost_Transfer3rdOthers_bk (winlostdate, CustId, Currency, PartnerId, Recommend, MRecommend, SRecommend, TransferAmount, TransferIn, TransferOut)
		select winlostdate, CustId, Currency, PartnerId, Recommend, MRecommend, SRecommend, TransferAmount, TransferIn, TransferOut
		from dbo.rptDepWinlost_Transfer3rdOthers_UAT with (nolock)
		where custid = @CustId and winlostdate >= @fromdate and winlostdate < @MinSumDate

		insert into dbo.rptDepWinlost_BonusWallet (Winlostdate, CustID, BonusType, Bonus, Adjustment)
		select Winlostdate, CustID, BonusType, Bonus, Adjustment
		from dbo.rptDepWinlost_BonusWallet_UAT with (nolock)
		where custid = @CustId and winlostdate >= @fromdate and winlostdate < @MinSumDate

	-- range Main
		delete dbo.rptDepWinlost_Main with (rowlock) where custid = @CustId and winlostdate >= @MinSumDate and winlostdate <= @MoveBetsDay
		delete dbo.rptDepWinlost_Trans with (rowlock) where custid = @CustId and winlostdate >= @MinSumDate and winlostdate <= @MoveBetsDay
		delete dbo.rptDepWinlost_BonusWallet with (rowlock) where custid = @CustId and winlostdate >= @MinSumDate and winlostdate <= @MoveBetsDay

		insert into dbo.rptDepWinlost_Main (Winlostdate, CustID, OpeningBalance, actualrate, srecommend, mrecommend, recommend, currency)
		select Winlostdate, CustID, OpeningBalance, actualrate, srecommend, mrecommend, recommend, currency
		from dbo.rptDepWinlost_Main_UAT with (nolock)
		where custid = @CustId and winlostdate >= @MinSumDate and winlostdate <= @MoveBetsDay

		insert into dbo.rptDepWinlost_Trans (
			Winlostdate, CustID, SportType, PartnerID, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover, Outstanding, Winloss
			,Transfer3rd, DrawGame, Turnover_BA, Comm_BA, AmountDueTo_BA, playercomm, Transfer3rdOthers, Comm_BetTrade, Comm_Bettrade_Full
			,AmountDueTo_BetTrade, BetCount, TransferAmount, TransferIn, TransferOut, Promotion
		)
		select
			Winlostdate, CustID, SportType, PartnerID, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover, Outstanding, Winloss
			,Transfer3rd, DrawGame, Turnover_BA, Comm_BA, AmountDueTo_BA, playercomm, Transfer3rdOthers, Comm_BetTrade, Comm_Bettrade_Full
			,AmountDueTo_BetTrade, BetCount, TransferAmount, TransferIn, TransferOut, Promotion
		from dbo.rptDepWinlost_Trans_UAT with (nolock)
		where custid = @CustId and winlostdate >= @MinSumDate and winlostdate <= @MoveBetsDay

		insert into dbo.rptDepWinlost_BonusWallet (Winlostdate, CustID, BonusType, Bonus, Adjustment)
		select Winlostdate, CustID, BonusType, Bonus, Adjustment
		from dbo.rptDepWinlost_BonusWallet_UAT with (nolock)
		where custid = @CustId and winlostdate >= @MinSumDate and winlostdate <= @MoveBetsDay

	waitfor delay '00:00:00.280'

	set @i = @i + 1
end