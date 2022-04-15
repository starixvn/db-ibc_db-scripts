/*<info serverAlias="DBCUST-CustDB"></info>*/  
/*
	Created: 20211201@Percy
	DB: DBCUST-CustDB
	Task: Manually insert Athena000 Extra PT Setting
	https://nexdev.net/issues/165612
*/
use CustDB
go

-- Insert setting for Super: Athena000SuperUUS (10063437): 5 affected rows
insert into dbo.Acc_GroupExtraPTSetting (SuperId,GroupId,GroupName,ProductId,Sporttype,SubProduct,ExtraPT,FromDate,ToDate)
select 10063437 as SuperId,GroupId,GroupName,ProductId,Sporttype,SubProduct,ExtraPT,FromDate,ToDate
from dbo.Acc_GroupExtraPT_Product with (nolock)
where GroupName = 'ACCAthena000' and FromDate = '2021-12-01'