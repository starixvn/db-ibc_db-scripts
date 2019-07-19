use custdb
go

/*
	Created: 20190719@Percy
	DB: DBCUST.CustDB
	Task: Initialize data for Reset Winning - Bet Builder
*/

declare @launchDate datetime
select  @launchDate = '2019-07-25'

insert into dbo.Acc_GroupExtraPT_Product (GroupId, GroupName, ProductID, Sporttype, SubProduct, FromDate, ToDate, ExtraPT)
select GroupId, GroupName, 1 AS ProductID, 0 AS Sporttype, 'Bet Builder' AS SubProduct, @launchDate AS FromDate, ToDate, ExtraPT
from dbo.Acc_GroupExtraPT_Product with (nolock)
where ProductId = 1 and Sporttype = 0 and SubProduct = ''
	and ToDate >= @launchDate

insert into dbo.Acc_GroupExtraPTSetting (SuperId, GroupId, GroupName, ProductID, Sporttype, SubProduct, FromDate, ToDate, ExtraPT)
select SuperId, GroupId, GroupName, 1 AS ProductID, 0 AS Sporttype, 'Bet Builder' AS SubProduct, @launchDate AS FromDate, ToDate, ExtraPT
from dbo.Acc_GroupExtraPTSetting with (nolock)
where ProductId = 1 and Sporttype = 0 and SubProduct = ''
	and ToDate >= @launchDate