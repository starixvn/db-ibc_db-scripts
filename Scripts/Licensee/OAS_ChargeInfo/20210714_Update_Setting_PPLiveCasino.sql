/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210714@Percy
	DB: DBCUST-bodb_Licensee
	Task: Change charge rate for PP Live Casino
*/
use bodb_Licensee
go

update dbo.OAS_ChargeInfo with (rowlock)
set ToDate = '2021-07-31'
where FromDate = '2021-04-15' and ToParty = 565 -- PP Live Casino

insert into dbo.OAS_ChargeInfo (ProductId, FromParty, ToParty, ParentChargeId, Rate, ChargeType, FromDate, ToDate, MinAmount, MaxAmount, BaseCurrencyId)
select 65 as ProductId, p.FromParty, 565 as ToParty, 0 as ParentChargeId, c.Rate, 1 as ChargeType, '2021-08-01' as FromDate, '2050-01-01' as ToDate, c.MinAmount, c.MaxAmount, 3 as BaseCurrencyId
from (values (25), (30)) as p (FromParty)
	cross join (
		select 0.00 as MinAmount, 2000000.00 as MaxAmount, 0.065 as Rate union all
		select 2000001, 5000000, 0.06 union all
		select 5000001, 10000000000000, 0.05
	) c

insert into dbo.LA_ChargeInfo_SystemMapping (ChargeId, SystemId)
select ChargeId, 2
from dbo.OAS_ChargeInfo with (nolock)
where ToParty = 565 and FromDate = '2021-08-01'