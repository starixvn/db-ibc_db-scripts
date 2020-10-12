/*<info serverAlias="DBN88-bodb_N88"></info>*/
use bodb_N88
go

/*
	Created: 20201012@Percy
	DB: DBN88.bodb_N88
	Task: Novacash - manually regen data due to API issue
*/

-- 1 row
update top (2) dbo.TpBetRecord with (rowlock)
set Stake = Stake / 1000.0
	, WinlostAmount = WinlostAmount / 1000.0
	, ValidBet = ValidBet / 1000.0
where WinlostDate = '2020-09-04'
	and GameType = 1
	and TransId = '109809417212'

/*
	select stake, ValidBet, WinlostAmount, *
	from dbo.TpBetRecord with (nolock)
	where WinlostDate = '2020-09-04'
		and GameType = 1
		and TransId = '109809417212'

	select stake, actual_stake, winlost - actual_stake
	from DBARC.bodb_Archive.dbo.bettrans_bk with (nolock)
	where transid = 109809417212
*/

-- manually regen sum data
exec dbo.Task_N88_RptWinloss @winlostdate = '2020-09-04'