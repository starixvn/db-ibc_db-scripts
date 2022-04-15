/*<info serverAlias="DBLIC-bodb_3rdProduct"></info>*/
/*
	Created: 20220415@Percy
	DB: DBLIC-bodb_3rdProduct
	Task: Exchange Product - Remove duplicate data due to API's issue
		- Step 1: Remove raw data
*/
use bodb_3rdProduct
go

-- 33,482 rows
create table #tmpBetExchange (betID bigint)
insert into #tmpBetExchange (betID)
select b.betID
from dbo.Sum_winloss_Exchange s with (nolock)
	inner join dbo.Bettrans_Exchange b with (nolock) on s.userId = b.userId and s.eventID = b.eventID and s.marketID = b.marketID
where settledDate >= '2022-04-06' and settledDate < '2022-04-12'
	and (convert(varchar(10), betID) like '86%'
		or convert(varchar(10), betID) like '88%')

declare @i int, @n int, @batch int = 3000

-- Bettrans_Exchange
--select count(1) from dbo.Bettrans_Exchange bm with (nolock)
--	inner join #tmpBetExchange t on bm.BetID = t.betID
print 'Bettrans_Exchange'
select @i = 1, @n = 33482 / @batch + 1
while 1=1
begin
	print ('Start batch: ' + convert(varchar(10), @i) + ' / ' + convert(varchar(10), @n))
	
	delete top (@batch) b with (rowlock)
	from dbo.Bettrans_Exchange b
		inner join #tmpBetExchange t on b.betID = t.betID

	if @@rowcount < @batch
		break

	waitfor delay '00:00:00.280'

	set @i = @i + 1
end

-- BettransM_Exchange
--select count(1) from dbo.BettransM_Exchange bm with (nolock)
--	inner join #tmpBetExchange t on bm.BetID = t.betID
print 'BettransM_Exchange'
select @i = 1, @n = 33482 / @batch + 1
while 1=1
begin
	print ('Start batch: ' + convert(varchar(10), @i) + ' / ' + convert(varchar(10), @n))
	
	delete top (@batch) b with (rowlock)
	from dbo.BettransM_Exchange b
		inner join #tmpBetExchange t on b.betID = t.betID

	if @@rowcount < @batch
		break

	waitfor delay '00:00:00.280'

	set @i = @i + 1
end

drop table #tmpBetExchange