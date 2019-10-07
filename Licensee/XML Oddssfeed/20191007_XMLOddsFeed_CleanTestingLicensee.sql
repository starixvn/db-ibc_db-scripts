use bodb_oddsfeed
go

/*
	Created: 20191007@Percy
	DB: DBODDSFEED.bodb_OddsFeed
	Task: Remove testing licensee - JennyTest
*/

-- 3 rows
-- select * from dbo.[System] with (nolock) where SystemID in (17,18,19) -- jennytest
delete from dbo.[System] with (rowlock, updlock) where SystemID in (17,18,19) -- jennytest


-- 3 rows
-- select top 10 * from dbo.SystemDomain with (nolock) where SystemID in (17,18,19)
delete from dbo.SystemDomain with (rowlock, updlock) where SystemID in (17,18,19)


-- 3 rows
-- select * from dbo.OddsSystemProfile with (nolock) where SystemID in (17,18,19)
delete from dbo.OddsSystemProfile with (rowlock, updlock) where SystemID in (17,18,19)