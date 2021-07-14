/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210714@Percy
	DB: DBCUST-bodb_Licensee
	Task: Change charge rate for PP Live Casino
*/
use bodb_Licensee
go

update dbo.OAS_ChargeInfo with (rowlock)
set ToDate = '2050-01-01'
where FromDate = '2021-04-15'
	and ToParty = 1 -- OW
	and ProductId = 65 -- PP Live Casino