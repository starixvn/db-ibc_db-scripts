use CustDB
go
/*
	clean test data of One-RnG
*/
delete from dbo.CustWinlimit with(rowlock, updlock)
where SportType = 208 and BetType = 2101

go
