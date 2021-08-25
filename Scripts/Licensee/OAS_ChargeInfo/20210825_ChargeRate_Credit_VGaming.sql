/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210825@Percy
	DB: DBCUST-bodb_Licensee
	Task: Add VGaming Charge Rate Setting for Credit
	https://nexdev.net/issues/160725
*/
use bodb_Licensee
go

insert into dbo.OAS_ChargeInfo (ProductId, FromParty, ToParty, ParentChargeId, Rate, ChargeType, FromDate, ToDate)
values (66, 25, 1, 0, 0, 1, '2021-06-01', '2050-01-01')
	  ,(66, 30, 1, 0, 0, 1, '2021-06-01', '2050-01-01')

insert into dbo.LA_ChargeInfo_SystemMapping (ChargeId, SystemId)
select c.ChargeId, 2 as SystemId
from dbo.OAS_ChargeInfo c with (nolock)
	left join dbo.LA_ChargeInfo_SystemMapping s with (nolock) on c.ChargeId = s.ChargeId and s.SystemId = 2
where c.ProductId = 66 and c.FromParty in (25, 30) and c.ToParty = 1