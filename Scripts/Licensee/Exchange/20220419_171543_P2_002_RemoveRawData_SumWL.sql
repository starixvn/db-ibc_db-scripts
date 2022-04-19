/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20220419@Percy
	DB: DBLIC-bodb_3rdProduct
	Task: Exchange Product - Remove duplicate data due to API's issue
	https://nexdev.net/issues/171543 (part 2)
		- Step 2: Remove raw data with have sum but no betId
*/
use bodb_3rdProduct
go

-- 2714 rows
create table #tmpSumWinloss (userId varchar(16), eventID INT, marketID varchar(50))
insert into #tmpSumWinloss (userId, eventID, marketID)
select s.userId, s.eventID, s.marketID
from dbo.Sum_winloss_Exchange s with (nolock)
	left join dbo.Bettrans_Exchange b with (nolock) on s.userId = b.userId and s.eventID = b.eventID and s.marketID = b.marketID
where s.settledDate >= '2022-04-07' and s.settledDate < '2022-04-10'
	and b.userId is null

delete s with (rowlock)
from dbo.Sum_winloss_Exchange s
	inner join #tmpSumWinloss t on s.userId = t.userId and s.eventID = t.eventID and s.marketID = t.marketID
	
drop table #tmpSumWinloss