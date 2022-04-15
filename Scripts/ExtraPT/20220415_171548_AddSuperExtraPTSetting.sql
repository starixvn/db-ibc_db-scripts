/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20220415@Percy
	DB: DBCUST-CustDB
	Task: Add Athena000 super Extra PT setting
		https://nexdev.net/issues/171548
*/

use CustDB
go

insert into dbo.Acc_GroupExtraPTSetting (SuperId,GroupId,GroupName,ProductId,Sporttype,SubProduct,ExtraPT,FromDate,ToDate)
select 10063437 as SuperId,GroupId,GroupName,ProductId,Sporttype,SubProduct,ExtraPT,FromDate,ToDate
from dbo.Acc_GroupExtraPT_Product with (nolock)
where GroupName='ACCAthena000' and ProductId = 6 and FromDate = '2022-04-15'