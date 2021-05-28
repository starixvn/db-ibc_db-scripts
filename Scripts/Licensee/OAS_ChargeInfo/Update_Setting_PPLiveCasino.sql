/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210528@Percy
	DB: DBCUST-bodb_Licensee
	Task: Update base currency for PP Live Casino
*/
use bodb_Licensee
go

update dbo.OAS_ChargeInfo with (rowlock)
set BaseCurrencyId = 3 -- USD
where ChargeId in (5590, 5591) -- ProductId = 65 --PP Live Casino