/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/

/*
	Created: 20210426@Percy
	DB:	DBCUST-bodb_Licensee
	Task: Discount setting - Update To date of "GGBOOK group_Apr2021" group
	https://nexdev.net/issues/154051
*/

use bodb_Licensee
go

/*
select *
from dbo.LA_DiscountGroupHeader with (nolock)
where DiscountGroupName = 'GGBOOK group_Apr2021'
*/

update dbo.LA_DiscountGroupHeader with (rowlock, updlock)
set ToDate = '2050-01-01'
where DiscountGroupId = 340