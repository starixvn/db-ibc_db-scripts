
use CustDB
go
/*
	Task: copy Global Setting for One-RnG
	DB: DBCUST/CustDB
*/

--newly data
insert into dbo.LossLimit_GlobalSetting(ProductId, ExchangeId, MinLossLimit, DefaultLossLimit)
select 6, ee.ExchangeID, MaxTransferCredit, SuperMaxTransfer
from dbtxn.CasinoAdmin.dbo.Exchange e with(nolock)
	inner join dbtxn.CasinoAdmin.dbo.code c with(nolock) on e.exchangeid = c.codeid
	inner join dbo.exchange ee with(nolock) on c.codeno = ee.exchangeid
	left join dbo.LossLimit_GlobalSetting s with(nolock) on ee.ExchangeID = s.exchangeid
where s.exchangeid is null

--update data
update s with(rowlock, updlock)
set MinLossLimit = MaxTransferCredit
	, DefaultLossLimit = SuperMaxTransfer
from dbo.LossLimit_GlobalSetting s
inner join (
	select 6 as ProductId, ee.ExchangeID, MaxTransferCredit, SuperMaxTransfer
	from dbtxn.CasinoAdmin.dbo.Exchange e with(nolock)
		inner join dbtxn.CasinoAdmin.dbo.code c with(nolock) on e.exchangeid = c.codeid
		inner join dbo.exchange ee with(nolock) on c.codeno = ee.exchangeid
		inner join dbo.LossLimit_GlobalSetting s with(nolock) on ee.ExchangeID = s.exchangeid
	where s.MinLossLimit <> MaxTransferCredit or DefaultLossLimit <> SuperMaxTransfer
)t on s.ProductId = t.ProductId and s.ExchangeId = t.exchangeid

go
