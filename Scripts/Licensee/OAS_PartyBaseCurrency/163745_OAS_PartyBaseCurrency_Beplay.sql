/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20211027@Percy
	DB: DBCUST-bodb_Licensee
	Task: Update base currency for Beplay: from EUR (6) to CNY (13)
*/
use bodb_Licensee
go

update bc
set bc.BaseCurrencyId = 13 -- CNY
from dbo.OAS_PartyBaseCurrency bc with (rowlock)
	inner join dbo.OAS_Party p with (nolock) on bc.PartyId = p.PartyId
where p.PartyName = 'Beplay'