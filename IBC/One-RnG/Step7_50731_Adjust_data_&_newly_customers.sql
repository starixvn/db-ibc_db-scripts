use custdb
go
/*
	run on dbcust
	task: adjust_data_for_newly_customers_and_turn_on_sync_casino
*/
declare @MaxCustId int, @SportType smallint, @BetType smallint
select @MaxCustId = ???, @SportType = 208, @BetType = 2101

create table #AdjustData (custid int)

--for newly customers
insert into dbo.CustWinLimit(CustId, SportType, BetType, MaxWinLimit, IsAutoReset, MaxLossLimit)
select custid, @SportType, @BetType, 0, 1, 0
from dbo.custInfo c with(nolock)
where custid > @MaxCustId
	and roleid <= 4
	and SyncCasino = 0
	and Enabled = 1

--incorrected data
select custid, 'Error!!!' as 'Error'
from dbo.custInfo c with(nolock)
where custid > @MaxCustId
	and roleid <= 4
	and SyncCasino = 1
	and Enabled = 1
	
--for customer turn on sync casino
insert into #AdjustData(custid)
select ci.custid
from dbo.custInfo ci with(nolock)
	inner join dbo.CustUnSyncedCasinoTmp t on ci.custid = t.custid
where ci.custid <= @MaxCustId
	and roleid <= 4
	and SyncCasino = 1
	and Enabled = 1

--adjust data
update cwl
set MaxWinLimit = 0
	, IsAutoReset = cs.IsAutoReset
	, MaxLossLimit = isnull(MaxTransferCredit, 0)
from dbo.CustWinLimit cwl with(rowlock, updlock)
	inner join DBCasino.CasinoAdmin.dbo.Customer cc with(nolock) on cwl.custid = cc.IBCCustID
	inner join DBCasino.CasinoAdmin.dbo.CustSetting cs with(nolock) on cc.custid = cs.CustSettingID
where exists (select custid from #AdjustData where custid = cwl.CustId and SportType = @SportType and BetType = @BetType)

drop table #AdjustData
go
