
use CustDB
go

/*
	use upline's value if downline un-synced for IsAutoReset
*/

--master level
update cwl
set cwl.IsAutoReset = 0
--select cwl.*, cwl2.*, c.roleid, c.custid, c.SyncCasino, cc.roleid, cc.custid, cc.SyncCasino
from dbo.CustWinLimit cwl with(rowlock, updlock)
	inner join dbo.custInfo c with(nolock) on cwl.CustId = c.custid and cwl.SportType = 208 and cwl.BetType = 2101
	inner join dbo.CustWinLimit cwl2 with(nolock) on c.srecommend = cwl2.CustId and cwl2.SportType = 208 and cwl2.BetType = 2101
	inner join dbo.custInfo cc with(nolock) on cc.custid = cwl2.CustId and cwl2.SportType = 208 and cwl2.BetType = 2101
where c.roleid = 3
	and c.Enabled = 1
	and c.SyncCasino = 0
	and cc.SyncCasino = 1
	and cwl2.IsAutoReset = 0
	and cwl.IsAutoReset = 1
	
--agent level
update cwl
set cwl.IsAutoReset = 0
from dbo.CustWinLimit cwl with(rowlock, updlock)
	inner join dbo.custInfo c with(nolock) on cwl.CustId = c.custid and cwl.SportType = 208 and cwl.BetType = 2101
	inner join dbo.CustWinLimit cwl2 with(nolock) on c.mrecommend = cwl2.CustId and cwl2.SportType = 208 and cwl2.BetType = 2101
	inner join dbo.custInfo cc with(nolock) on cc.custid = cwl2.CustId and cwl2.SportType = 208 and cwl2.BetType = 2101
where c.roleid = 2
	and c.Enabled = 1
	and c.SyncCasino = 0
	and cc.SyncCasino = 1
	and cwl2.IsAutoReset = 0
	and cwl.IsAutoReset = 1

--member level
update cwl
set cwl.IsAutoReset = 0
from dbo.CustWinLimit cwl with(rowlock, updlock)
	inner join dbo.custInfo c with(nolock) on cwl.CustId = c.custid and cwl.SportType = 208 and cwl.BetType = 2101
	inner join dbo.CustWinLimit cwl2 with(nolock) on c.recommend = cwl2.CustId and cwl2.SportType = 208 and cwl2.BetType = 2101
	inner join dbo.custInfo cc with(nolock) on cc.custid = cwl2.CustId and cwl2.SportType = 208 and cwl2.BetType = 2101
where c.roleid = 1
	and c.Enabled = 1
	and c.SyncCasino = 0
	and cc.SyncCasino = 1
	and cwl2.IsAutoReset = 0
	and cwl.IsAutoReset = 1
	
go
