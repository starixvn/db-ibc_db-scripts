/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210525@Percy
	DB: DBCUST-bodb_Licensee
	Task: Update setting for Habanero, WM, BG
	https://nexdev.net/issues/155735
*/
use bodb_Licensee
go

delete dbo.OAS_ChargeInfo with (rowlock, updlock)
where ProductId = 62 and ToParty = 563

-- WM for Deposit: 27 May 2021
update dbo.OAS_ChargeInfo with (rowlock)
set FromDate = '2021-05-27'
where ProductId = 51
	and FromParty in (1, 9, 11, 98)
	and ToParty = 520

-- BG for Deposit: 27 May 2021
update dbo.OAS_ChargeInfo with (rowlock)
set FromDate = '2021-05-27'
where ProductId = 57
	and FromParty in (1, 9, 11, 98)
	and ToParty = 526

-- BG for Credit: 21 Jan 2021
update dbo.OAS_ChargeInfo with (rowlock)
set FromDate = '2021-01-21'
where ProductId = 57
	and FromParty in (25, 30)

-- Habanero for Deposit: 27 May 2021
insert into dbo.OAS_ChargeInfo (ProductID,FromParty,ToParty,ParentChargeID,Rate,ChargeType,FromDate,ToDate)
values	(61, 1,563,0,0.05,1,'2021-05-27','2050-01-01'),
		(61, 9,563,0,0.05,1,'2021-05-27','2050-01-01'),
		(61,11,563,0,0.05,1,'2021-05-27','2050-01-01'),
		(61,98,563,0,0.05,1,'2021-05-27','2050-01-01')

insert into dbo.LA_ChargeInfo_SystemMapping (ChargeID,SystemID)
select ChargeID, 2
from dbo.OAS_ChargeInfo with (nolock) where ProductId = 61 and FromParty in (1,9,11,98)