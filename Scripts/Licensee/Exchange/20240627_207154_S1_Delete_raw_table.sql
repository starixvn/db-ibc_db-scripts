/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20240627@Kelvin
	DB: DBLIC-bodb_3rdProduct
	Task: Exchange Product - Remove data in June [RedmineID: #207154]
		- Step 1: Remove raw data
*/
USE bodb_3rdProduct
GO

declare  @FromDate date  = '2024-06-01',
		 @ToDate   date  = '2024-06-28',		
		 @batch	int = 2000

drop table if exists #tmpSum_winloss_Exchange
drop table if exists #tmpBettrans_Exchange

create table #tmpSum_winloss_Exchange (userId varchar(16), eventID int, marketID varchar(50), settledDate datetime, isfinished bit default(0))	
create table #tmpBettrans_Exchange (betID bigint, isfinished bit default(0))

insert into #tmpSum_winloss_Exchange (userId, eventID, marketID, settledDate)
select userId, eventID, marketID, settledDate
from dbo.Sum_winloss_Exchange s with (nolock)
where settledDate >= @FromDate and settledDate <= @ToDate

insert into #tmpBettrans_Exchange (betID)
select s.betID
from dbo.Bettrans_Exchange s with (nolock)
	inner join #tmpSum_winloss_Exchange b with (nolock) on s.userId = b.userId and s.eventID = b.eventID and s.marketID = b.marketID


-- Bettrans_Exchange & BettransM_Exchange
print 'Bettrans_Exchange & BettransM_Exchange'

while exists (select top 1 1 from #tmpBettrans_Exchange)
begin	
	update top (@batch)	b
	set isfinished = 1
	from #tmpBettrans_Exchange b

	delete b with (rowlock)
	from dbo.Bettrans_Exchange b
		inner join #tmpBettrans_Exchange t on b.betID = t.betID
	where isfinished = 1

	delete m with (rowlock)
	from dbo.BettransM_Exchange m
		inner join #tmpBettrans_Exchange t on m.betID = t.betID
	where isfinished = 1

	delete from #tmpBettrans_Exchange where isfinished = 1

	waitfor delay '00:00:00.280'	
end


-- Sum_winloss_Exchange
print 'Sum_winloss_Exchange'

while exists (select top 1 1 from #tmpSum_winloss_Exchange)
begin
	update top (@batch)	b
	set isfinished = 1
	from #tmpSum_winloss_Exchange b

	delete s with (rowlock)
	from dbo.Sum_winloss_Exchange s
	 	inner join #tmpSum_winloss_Exchange t 
			on s.userId = t.userId and s.eventID = t.eventID and s.marketID = t.marketID and s.settledDate = t.settledDate
	where isfinished = 1

	delete from #tmpSum_winloss_Exchange where isfinished = 1

	waitfor delay '00:00:00.280'
end



