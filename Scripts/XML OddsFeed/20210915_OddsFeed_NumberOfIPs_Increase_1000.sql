/*<info serverAlias="DBODDSFEED-bodb_OddsFeed"></info>*/
/*
	Created: 20210915@Percy
	DB: DBODDSFEED-bodb_OddsFeed
	Task: Increase Maximum Number Of IPs setting
*/
use bodb_OddsFeed
go

update dbo.SystemSetting with (rowlock)
set SValue = '1000'
where Type = 'Config' and SName = 'MaximumNumberOfIPs'