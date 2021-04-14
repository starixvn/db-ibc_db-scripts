/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20210413@Percy
	DB: DBN88-bodb_N88
	Task: Manually clean up V8 Poker data
	https://nexdev.net/issues/153403
*/

use bodb_n88
go

-- 5670 rows affected
delete dbo.TpBetRecord with (rowlock, updlock)
where WinlostDate between '2021-02-01' and '2021-02-28'
	and GameType = 42

-- 8403 rows affected
delete dbo.TpBetRecord with (rowlock, updlock)
where WinlostDate between '2021-03-01' and '2021-03-31'
	and GameType = 42

-- 8403 rows affected
delete dbo.TpBetRecord with (rowlock, updlock)
where WinlostDate >= '2021-04-01'
	and GameType = 42