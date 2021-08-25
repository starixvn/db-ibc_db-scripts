/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20210806@Percy
	DB: DBN88-bodb_N88
	Task: Manually delete SBC data from 5 Aug 2021 (Change to VGaming)
	https://nexdev.net/issues/159827
*/
use bodb_N88
go

-- 21 rows
delete dbo.TpBetRecord with (rowlock, updlock)
where GameType = 25 -- OW Saba Club
	and WinlostDate >= '2021-08-05'

-- select * from dbo.TpGameType with (nolock) where Type = 25 -- OW Saba Club