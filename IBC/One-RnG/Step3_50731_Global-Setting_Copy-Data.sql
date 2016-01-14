
use CustDB
go
/*
	Task: copy Global Setting for One-RnG
	DB: DBCUST/CustDB
	delete from dbo.LossLimit_GlobalSetting
*/
insert into dbo.LossLimit_GlobalSetting(ProductId, ExchangeId, MinLossLimit, DefaultLossLimit)
select 6, ee.ExchangeID, MaxTransferCredit, SuperMaxTransfer
from DBCasino.CasinoAdmin.dbo.Exchange e with(nolock)
	inner join DBCasino.CasinoAdmin.dbo.code c with(nolock) on e.exchangeid = c.codeid
	inner join dbo.exchange ee with(nolock) on c.codeno = ee.exchangeid

go
