/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210526@Percy
	DB: DBCUST-bodb_Licensee
	Task: Update base currency of ZFRT081: change EUR to CNY
	https://nexdev.net/issues/155795
*/
use bodb_Licensee
go

-- select * from dbo.OAS_Party with (nolock) where PartyName = 'ZFRT081'

update dbo.OAS_PartyBaseCurrency with (rowlock)
set BaseCurrencyId = 13 -- change from EUR (6) to CNY (13)
where PartyId = 570 -- ZFRT081