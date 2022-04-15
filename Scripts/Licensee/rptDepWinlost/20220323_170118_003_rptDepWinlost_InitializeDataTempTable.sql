/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220322@Percy
	DB: DBRPT-bodb_Report
	Task: Regen data on rptDepWinlost
		- Step 3: Initialize data for _UAT report table
*/
use bodb_Report
go

-- 2. Initialize Opening Balance
declare @CustId int, @WinlostDate smalldatetime, @i int, @n int, @msg varchar(200)
select @n = count(1) from dbo.rptDepCust_UAT with (nolock)

set @i = 1
while @i <= @n
begin
	select @CustId = custid, @WinlostDate = dateadd(day, -1, init_winlostdate) from rptDepCust_UAT with (nolock) where id = @i

	select @msg = '==> Start ' + convert(varchar(10), @i) + ' / ' + convert(varchar(10), @n) + ' with FromDate: ' + convert(varchar(10), @WinlostDate, 120)
	print (@msg)

		delete dbo.rptDepWinlost_UAT with (rowlock) where custid = @CustId
		delete dbo.rptDepWinlostByProduct_UAT with (rowlock) where custid = @CustId
		delete dbo.rptDepWinlost_Transfer3rdOthers_UAT with (rowlock) where custid = @CustId
		delete dbo.rptDepWinlost_BonusWallet_UAT with (rowlock) where custid = @CustId

		insert into dbo.rptDepWinlost_UAT (
			winlostdate, custid, currency, OpeningBalance, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover, Outstanding, Winloss, ClosingBalance
			,recommend, mrecommend, srecommend, actualrate, Transfer3rd, DrawGame, Turnover_BA, Comm_BA, AmountDueTo_BA, playercomm, Transfer3rdOthers, Comm_BetTrade
			,AmountDueTo_BetTrade, Promotion
		)
		select
			winlostdate, custid, currency, OpeningBalance, Deposit, Withdrawal, Aff2MemTransfer, Bonus, Adjustment, Turnover, Outstanding, Winloss, ClosingBalance
			,recommend, mrecommend, srecommend, actualrate, Transfer3rd, DrawGame, Turnover_BA, Comm_BA, AmountDueTo_BA, playercomm, Transfer3rdOthers, Comm_BetTrade
			,AmountDueTo_BetTrade, Promotion
		from dbo.rptDepWinlost_bk r with (nolock)
		where custid = @CustId and winlostdate = @WinlostDate

		insert into dbo.rptDepWinlostByProduct_UAT (winlostdate, custid, sporttype, turnover, drawTO, winlost, playercomm, BetCount, Outstanding, currency)
		select winlostdate, custid, sporttype, turnover, drawTO, winlost, playercomm, BetCount, Outstanding, currency
		from dbo.rptDepWinlostByProduct_bk with (nolock)
		where custid = @CustId and winlostdate = @WinlostDate

		insert into dbo.rptDepWinlost_Transfer3rdOthers_UAT (winlostdate, CustId, Currency, PartnerId, Recommend, MRecommend, SRecommend, TransferAmount, TransferIn, TransferOut)
		select winlostdate, CustId, Currency, PartnerId, Recommend, MRecommend, SRecommend, TransferAmount, TransferIn, TransferOut
		from dbo.rptDepWinlost_Transfer3rdOthers_bk with (nolock)
		where custid = @CustId and winlostdate = @WinlostDate

		insert into dbo.rptDepWinlost_BonusWallet_UAT (Winlostdate, CustID, BonusType, Bonus, Adjustment)
		select Winlostdate, CustID, BonusType, Bonus, Adjustment
		from dbo.rptDepWinlost_BonusWallet with (nolock)
		where custid = @CustId and winlostdate = @WinlostDate

	waitfor delay '00:00:00.280'

	set @i = @i + 1
end