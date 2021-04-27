/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20210413@Percy
	DB: DBN88-bodb_N88
	Task: Manually clean up V8 Poker (No Revenue) data
	https://nexdev.net/issues/153403
*/

use bodb_n88
go

-- 4495 rows affected
delete dbo.TpBetRecord with (rowlock, updlock)
where WinlostDate between '2021-02-01' and '2021-02-28'
	and GameType = 47

-- 8989 rows affected
delete dbo.TpBetRecord with (rowlock, updlock)
where WinlostDate between '2021-03-01' and '2021-03-31'
	and GameType = 47

-- 5288 rows affected
delete dbo.TpBetRecord with (rowlock, updlock)
where WinlostDate >= '2021-04-01'
	and GameType = 47