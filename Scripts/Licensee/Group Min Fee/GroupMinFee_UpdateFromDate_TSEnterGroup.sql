/*<info serverAlias="DBCUST-bodb_Licensee"></info>*/
/*
	Created: 20210407@Percy
	DB: DBCUST-bodb_Licensee
	Task: update from date of TSEnter group min fee to Apr 01 (Current: Mar 31)
	https://nexdev.net/issues/153019
*/

use bodb_Licensee
go

--select * from bodb_Licensee.dbo.LA_GroupMinFeeHeader with (nolock)
--where Name = 'TSEnter group' -- GroupMinFeeID = 25

-- 1 row affected
update dbo.LA_GroupMinFeeHeader with (nolock)
set FromDate = '2021-04-01'
where GroupMinFeeID = 25

-- 1 row affected
update dbo.LA_GroupMinFeeDetail with (nolock)
set FromDate = '2021-04-01'
where GroupMinFeeID = 25
