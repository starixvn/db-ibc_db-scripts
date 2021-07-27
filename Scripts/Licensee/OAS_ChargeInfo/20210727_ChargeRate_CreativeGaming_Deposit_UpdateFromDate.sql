/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210727@Percy
	DB: DBCUST-bodb_Licensee
	Task: Creative Gaming - Update FromDate of Deposit Charge Rate Setting
	https://nexdev.net/issues/159103
*/
use bodb_Licensee
go

update dbo.OAS_ChargeInfo with (rowlock)
set FromDate = '2021-07-15'
where ProductId = 62 -- Creative Gaming
	and FromParty in (1, 9, 11, 98) -- Deposit