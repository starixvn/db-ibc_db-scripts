/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/

/*
	Created: 20210409@Percy
	DB: DBCUST-bodb_Licensee
	Task: Correct discount group by currency setting
	https://nexdev.net/issues/153158
*/
use bodb_Licensee
go

--
/*
	select *
	from dbo.OAS_Party with (nolock)
	where PartyId in (14,56,60,72,124,65,17,220,43,358,292,127,143,73,166,80,154,502,361,230,312,507,305)
	order by PartyName
*/
create table #DiscountGroup (DiscountGroupId smallint, PartyId int)

insert into #DiscountGroup (DiscountGroupId, PartyId)
select distinct c.DiscountGroupId, c.PartyId
from dbo.LA_DiscountGroupHeader h with (nolock)
	inner join dbo.LA_DiscountGroupCurrency c with (nolock) on h.DiscountGroupId = c.DiscountGroupId
where h.FromDate = '2021-03-01'
	and c.PartyId in (14,56,60,72,124,65,17,220,43,358,292,127,143,73,166,80,154,502,361,230,312,507,305)

-- remove old setting
delete c with (rowlock, updlock)
from dbo.LA_DiscountGroupCurrency c
	inner join #DiscountGroup d on c.DiscountGroupId = d.DiscountGroupId and c.PartyId = d.PartyId

-- insert new setting with all currencies (CurrencyId = 0)
insert into dbo.LA_DiscountGroupCurrency (DiscountGroupId, PartyID, CurrencyId)
select DiscountGroupId, PartyId, 0 as CurrencyId
from #DiscountGroup

drop table #DiscountGroup