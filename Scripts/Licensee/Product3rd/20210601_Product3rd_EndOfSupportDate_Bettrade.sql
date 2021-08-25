/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210601@Percy
	DB: DBCUST-bodb_Licensee
	Task: Update EndOfSupportDate for BetTrade
*/
use bodb_Licensee
go

update dbo.Product3rd
set EndOfSupportDate = '2018-12-31'
where ProductId = 13 -- BetTrade