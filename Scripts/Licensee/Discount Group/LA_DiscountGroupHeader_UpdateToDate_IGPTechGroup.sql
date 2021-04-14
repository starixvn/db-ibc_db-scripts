/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/

/*
	Created: 20210414@Percy
	DB:	DBCUST-bodb_Licensee
	Task: Discount setting - Update To date of IGPTech group
	https://nexdev.net/issues/153473
*/

use bodb_Licensee
go

/*
select *
from dbo.LA_DiscountGroupHeader with (nolock)
where DiscountGroupName = 'IGPTech group'
*/

update dbo.LA_DiscountGroupHeader with (rowlock, updlock)
set ToDate = '2050-01-01'
where DiscountGroupId = 330