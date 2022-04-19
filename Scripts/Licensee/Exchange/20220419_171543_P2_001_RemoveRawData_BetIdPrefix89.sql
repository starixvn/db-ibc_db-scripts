/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20220419@Percy
	DB: DBLIC-bodb_3rdProduct
	Task: Exchange Product - Remove duplicate data due to API's issue
	https://nexdev.net/issues/171543 (part 2)
		- Step 1: Remove raw data with betIds have prefix 89
*/
use bodb_3rdProduct
go

-- 34 rows
create table #tmpBetExchange (betID bigint)
insert into #tmpBetExchange (betID)
select b.betID
from dbo.Sum_winloss_Exchange s with (nolock)
	inner join dbo.Bettrans_Exchange b with (nolock) on s.userId = b.userId and s.eventID = b.eventID and s.marketID = b.marketID
where settledDate >= '2022-04-10' and settledDate < '2022-04-11'
	and convert(varchar(10), b.betID) like '89%'

-- Bettrans_Exchange: 34 rows
delete b with (rowlock)
from dbo.Bettrans_Exchange b
	inner join #tmpBetExchange t on b.betID = t.betID

-- BettransM_Exchange: 34 rows
delete b with (rowlock)
from dbo.BettransM_Exchange b
	inner join #tmpBetExchange t on b.betID = t.betID

drop table #tmpBetExchange