
use CustDB
go

/*
	use downline's value if downline turn on IsAutoReset
*/
create table #AffectedData (CustId int)

--agent level
update cwl
set cwl.IsAutoReset = 1
output inserted.CustId
into #AffectedData(CustId)
from dbo.CustWinLimit cwl with(rowlock, updlock)
inner join (
	select cwl.CustId--, cwl2.*, c.roleid
	from dbo.CustWinLimit cwl with(nolock)
		inner join dbo.custInfo c with(nolock) on cwl.CustId = c.recommend and cwl.SportType = 208 and cwl.BetType = 2101
		inner join dbo.CustWinLimit cwl2 with(nolock) on c.custid = cwl2.CustId and cwl2.SportType = 208 and cwl2.BetType = 2101
	where c.roleid = 1
		and c.Enabled = 1
		and c.SyncCasino = 1
		and cwl2.IsAutoReset = 1
		and cwl.IsAutoReset = 0
	group by cwl.CustId
) t on cwl.CustId = t.CustId AND cwl.SportType = 208 and cwl.BetType = 2101

--master level
update cwl
set cwl.IsAutoReset = 1
output inserted.CustId
into #AffectedData(CustId)
from dbo.CustWinLimit cwl with(rowlock, updlock)
inner join (
	select cwl.CustId--, cwl2.*, c.roleid
	from dbo.CustWinLimit cwl with(nolock)
		inner join dbo.custInfo c with(nolock) on cwl.CustId = c.mrecommend and cwl.SportType = 208 and cwl.BetType = 2101
		inner join dbo.CustWinLimit cwl2 with(nolock) on c.custid = cwl2.CustId and cwl2.SportType = 208 and cwl2.BetType = 2101
	where c.roleid = 2
		and c.Enabled = 1
		and c.SyncCasino = 1
		and cwl2.IsAutoReset = 1
		and cwl.IsAutoReset = 0
	group by cwl.CustId
) t on cwl.CustId = t.CustId AND cwl.SportType = 208 and cwl.BetType = 2101

--super level
update cwl
set cwl.IsAutoReset = 1
output inserted.CustId
into #AffectedData(CustId)
from dbo.CustWinLimit cwl with(rowlock, updlock)
inner join (
	select cwl.CustId--, cwl2.*, c.roleid
	from dbo.CustWinLimit cwl with(nolock)
		inner join dbo.custInfo c with(nolock) on cwl.CustId = c.srecommend and cwl.SportType = 208 and cwl.BetType = 2101
		inner join dbo.CustWinLimit cwl2 with(nolock) on c.custid = cwl2.CustId and cwl2.SportType = 208 and cwl2.BetType = 2101
	where c.roleid = 3
		and c.Enabled = 1
		and c.SyncCasino = 1
		and cwl2.IsAutoReset = 1
		and cwl.IsAutoReset = 0
	group by cwl.CustId
) t on cwl.CustId = t.CustId AND cwl.SportType = 208 and cwl.BetType = 2101


select * from #AffectedData

drop table #AffectedData
go
