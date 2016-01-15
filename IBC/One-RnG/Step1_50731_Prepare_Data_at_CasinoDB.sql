use CasinoAdmin
go
/*
	Task: copy data for CustWinlimit of ONE-RnG
*/
--
select cc.IBCCustID, cs.IsAutoReset, isnull(MaxTransferCredit, 0)
from dbo.Customer cc with(nolock)
	inner join dbo.CustSetting cs with(nolock) on cc.custid = cs.CustSettingID
go

