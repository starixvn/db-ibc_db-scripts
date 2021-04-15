/*<info serverAlias="DBAFFN8G-Affiliate_N8G"></info>*/

/*
	Created: 20210415@Percy
	DB: DBAFFN8G-Affiliate_N8G
	Task: Insert affiliate member manually due to missing from member site
	https://nexdev.net/issues/153561
*/

use Affiliate_N8G
go

insert into dbo.MemberInfo (CustId,UserName,Currency,ActStatus,Status,RegisteredDate,AffId,IsRemoved,ClickId,FirstDepositDate,FirstDepositAmount)
select CustId,UserName,CurrencyId,ActStatus,Status,dateadd(hour, 8, RegTime),80 AffId,0 IsRemoved,0 ClickId,dateadd(hour, 8, FirstDepositDate),FirstDepositAmount
from bodb_N88.dbo.Customer with (nolock)
where CustId in (274122, 264090, 274187, 264070, 265209, 36876, 281911, 280436)
go