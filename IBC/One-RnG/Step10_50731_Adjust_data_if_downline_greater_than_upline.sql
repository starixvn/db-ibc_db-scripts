
use CustDB
go

/*
	use upline's value if downline's value is greater than upline's value
*/

--master level
update cwl
set cwl.MaxLossLimit = cwl2.MaxLossLimit
--select cwl.*, cwl2.*
from dbo.CustWinLimit cwl with(rowlock, updlock)
	inner join dbo.custInfo c with(nolock) on cwl.CustId = c.custid and cwl.SportType = 208 and cwl.BetType = 2101
	inner join dbo.CustWinLimit cwl2 with(nolock) on c.srecommend = cwl2.CustId and cwl2.SportType = 208 and cwl2.BetType = 2101
where c.roleid = 3
	and c.Enabled = 1
	and c.SyncCasino = 1
	and cwl2.MaxLossLimit > 0
	and((cwl.MaxLossLimit > cwl2.MaxLossLimit) --Upline > downline
		or (cwl2.MaxLossLimit > 0 and cwl.MaxLossLimit = 0) -- Upline > 0 but downline = 0
	)
	
--agent level
update cwl
set cwl.MaxLossLimit = cwl2.MaxLossLimit
--select cwl.*, cwl2.*
from dbo.CustWinLimit cwl with(rowlock, updlock)
	inner join dbo.custInfo c with(nolock) on cwl.CustId = c.custid and cwl.SportType = 208 and cwl.BetType = 2101
	inner join dbo.CustWinLimit cwl2 with(nolock) on c.mrecommend = cwl2.CustId and cwl2.SportType = 208 and cwl2.BetType = 2101
where c.roleid = 2
	and c.Enabled = 1
	and c.SyncCasino = 1
	and((cwl.MaxLossLimit > cwl2.MaxLossLimit) --Upline > downline
		or (cwl2.MaxLossLimit > 0 and cwl.MaxLossLimit = 0) -- Upline > 0 but downline = 0
	)

--member level
update cwl
set cwl.MaxLossLimit = cwl2.MaxLossLimit
--select cwl.*, cwl2.*, c.*
from dbo.CustWinLimit cwl with(rowlock, updlock)
	inner join dbo.custInfo c with(nolock) on cwl.CustId = c.custid and cwl.SportType = 208 and cwl.BetType = 2101
	inner join dbo.CustWinLimit cwl2 with(nolock) on c.recommend = cwl2.CustId and cwl2.SportType = 208 and cwl2.BetType = 2101
where c.roleid = 1
	and c.Enabled = 1
	and c.SyncCasino = 1
	and((cwl.MaxLossLimit > cwl2.MaxLossLimit) --Upline > downline
		or (cwl2.MaxLossLimit > 0 and cwl.MaxLossLimit = 0) -- Upline > 0 but downline = 0
	)

go
