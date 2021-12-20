/*<info serverAlias="DBODDSFEED-bodb_OddsFeed"></info>*/
/*
	Created: 20211220@Percy
	DB: DBODDSFEED-bodb_OddsFeed
	Task: Add Kabaddi sport
	https://nexdev.net/issues/166220
*/
use bodb_oddsfeed
go

update dbo.SystemSetting with (rowlock)
set SValue = SValue + ',47' -- 47: Kabaddi
where Type = 'SportTypes' and SName = 'SupportedSports'