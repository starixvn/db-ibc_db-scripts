/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/

/*
	Created: 20210409@Percy
	DB: DBCUST-bodb_Licensee
	Task: Check discount group by currency setting
	https://nexdev.net/issues/153158
*/

use bodb_Licensee
go

select distinct h.DiscountGroupId, h.DiscountGroupName, h.DiscountGroupType
	,a.PartyId, a.IsApplyDiscount, a.IsSpecialTreatment
	,isnull(e.Code, 'all') as Currency
into #OldDiscountGroup
from dbo.LA_DiscountGroupHeader h with (nolock)
	inner join dbo.LA_DiscountGroupAssignment a with (nolock) on h.DiscountGroupId = a.DiscountGroupId
	inner join dbo.LA_DiscountGroupCurrency c with (nolock) on h.DiscountGroupId = c.DiscountGroupId and a.PartyID = c.PartyID
	left join bodb02.dbo.Exchange e with (nolock) on c.CurrencyId = e.ExchangeId
where h.ToDate = '2021-02-28'

select distinct h.DiscountGroupId, h.DiscountGroupName, h.DiscountGroupType
	,a.PartyId, a.IsApplyDiscount, a.IsSpecialTreatment
	,isnull(e.Code, 'all') as Currency
into #NewDiscountGroup
from dbo.LA_DiscountGroupHeader h with (nolock)
	inner join dbo.LA_DiscountGroupAssignment a with (nolock) on h.DiscountGroupId = a.DiscountGroupId
	inner join dbo.LA_DiscountGroupCurrency c with (nolock) on h.DiscountGroupId = c.DiscountGroupId and a.PartyID = c.PartyID
	left join bodb02.dbo.Exchange e with (nolock) on c.CurrencyId = e.ExchangeId
where h.FromDate = '2021-03-01'

;with OldSetting as
(
	select o1.PartyId, o1.DiscountGroupName, o1.DiscountGroupType, o1.IsApplyDiscount, o1.IsSpecialTreatment
		,stuff((select ',' + convert(varchar(10), o2.Currency)
				from #OldDiscountGroup o2
				where o1.PartyId = o2.PartyId
				for xml path('')), 1, 1, '') as Currencies
	from #OldDiscountGroup o1
	group by o1.PartyId, o1.DiscountGroupName, o1.DiscountGroupType, o1.IsApplyDiscount, o1.IsSpecialTreatment
), NewSetting as
(
	select o1.PartyId, o1.DiscountGroupName, o1.DiscountGroupType, o1.IsApplyDiscount, o1.IsSpecialTreatment
		,stuff((select ',' + convert(varchar(10), o2.Currency)
				from #NewDiscountGroup o2
				where o1.PartyId = o2.PartyId
				for xml path('')), 1, 1, '') as Currencies
	from #NewDiscountGroup o1
	group by o1.PartyId, o1.DiscountGroupName, o1.DiscountGroupType, o1.IsApplyDiscount, o1.IsSpecialTreatment
)
select p.PartyName, d.*
from (
select
	case when n.PartyId is null then 'Delete Setting'
		when o.PartyId is null then 'Add Setting'
		else 'Update Setting' end as Status
	,o.DiscountGroupName as OldName
	,n.DiscountGroupName as NewName
	,o.DiscountGroupType as OldType
	,n.DiscountGroupType as NewType
	,o.IsApplyDiscount as OldIsApplyDiscount
	,n.IsApplyDiscount as NewIsApplyDiscount
	,o.IsSpecialTreatment as OldIsSpecialTreatment
	,n.IsSpecialTreatment as NewIsSpecialTreatment
	,o.Currencies as OldCurrencyIds
	,n.Currencies as NewCurrencyIds
	,isnull(o.PartyId, n.PartyId) as PartyId
from OldSetting o
	inner join NewSetting n on o.PartyId = n.PartyId
where o.PartyId is null or n.PartyId is null
	or isnull(o.Currencies, '') <> isnull(n.Currencies, '')
) d
	inner join dbo.OAS_Party p with (nolock) on d.PartyId = p.PartyId
order by Status desc, p.PartyName

drop table #NewDiscountGroup
drop table #OldDiscountGroup