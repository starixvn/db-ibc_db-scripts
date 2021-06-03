-- run on DBLIC.bodb_Licensee
use bodb_Licensee
go

select c.FromParty as PartyId, c.Rate, cc.CurrencyId, cc.Rate as CurrRate
into #SB
from dbo.OAS_ChargeInfo c with (nolock)
	inner join dbo.LA_ChargeInfo_SystemMapping cs with (nolock) on c.ChargeId = cs.ChargeId and cs.SystemId = 2
	left join dbo.LA_ChargeRateByCurrency cc with (nolock) on c.ChargeId = cc.ChargeId
where c.ToParty in (1, 9, 11, 98)
	and '2021-06-01' between c.FromDate and c.ToDate
	and c.ProductId = 0 -- SB

select c.FromParty as PartyId, c.Rate, cc.CurrencyId, cc.Rate as CurrRate
into #SLT
from dbo.OAS_ChargeInfo c with (nolock)
	inner join dbo.LA_ChargeInfo_SystemMapping cs with (nolock) on c.ChargeId = cs.ChargeId and cs.SystemId = 2
	left join dbo.LA_ChargeRateByCurrency cc with (nolock) on c.ChargeId = cc.ChargeId
where c.ToParty in (1, 9, 11, 98)
	and '2021-06-01' between c.FromDate and c.ToDate
	and c.ProductId = 63 -- SPL

select p.PartyId, p.PartyName, t.SB_Rate, t.SLT_Rate
from (
	select sb.PartyId, sb.Rate as SB_Rate, slt.Rate as SLT_Rate
	from #SB sb
		left join #SLT slt on sb.PartyId = slt.PartyId
	where slt.PartyId is null
		or sb.Rate <> sb.Rate
) t
	inner join dbo.OAS_Party p with (nolock) on t.PartyId = p.PartyId
order by 2

select p.PartyId, p.PartyName, t.CurrencyId, e.Code, t.SB_Rate, t.SLT_Rate
from (
	select sb.PartyId, sb.CurrencyId, sb.CurrRate as SB_Rate, slt.CurrRate as SLT_Rate
	from (select * from #SB where CurrencyId is not null) sb
		left join (select * from #SLT where CurrencyId is not null) slt on sb.PartyId = slt.PartyId and sb.CurrencyId = slt.CurrencyId
	where slt.PartyId is null
		or sb.CurrRate <> slt.CurrRate
) t
	inner join dbo.OAS_Party p with (nolock) on t.PartyId = p.PartyId
	inner join bodb02.dbo.Exchange e with (nolock) on t.CurrencyId = e.ExchangeId

drop table #SB
drop table #SLT