 /*
	Created: 20151231@Patrick
	Task: copy winlimit for One-RnG
	DB: DBCUST/CustDB
	
	Noted: make sure that we have already restored CasinoAdmin database on these servers need to run this script

*/ 
 alter procedure dbo.Acc_ExecRep_Cust_09 @srecommend int	
	, @maxcustid int
	, @target varchar(20)
	, @SportType smallint
	, @BetType smallint
as
begin
	set nocount on
	
	if (@target = 'replicated' and @@servername = 'dbcust') return	-- run at all replicated servers
	if (@target = 'dbcust' and @@servername <> 'dbcust') return -- run at dbtrans only
	
	if (select count(1) from sys.objects where name in ('custinfo', 'custwinlimit')) <> 2
		return

	--for case unsynced casino --> set default value for all level
	insert into dbo.CustWinLimit(CustId, SportType, BetType, MaxWinLimit, IsAutoReset, MaxLossLimit)
	select custid, @SportType, @BetType, 0, 1, 0
	from dbo.custInfo c with(nolock)
	where srecommend = @srecommend 
		and roleid <= 4 
		and custid <= @MaxCustId 
		and SyncCasino = 0 
		and Enabled = 1

	--for case synced casino
	insert into dbo.CustWinLimit(CustId, SportType, BetType, MaxWinLimit, IsAutoReset, MaxLossLimit)
	select c.custid, @SportType, @BetType, 0, cs.IsAutoReset, isnull(MaxTransferCredit, 0)
	from dbo.custInfo c with(nolock)
		inner join CasinoAdmin.dbo.Customer cc with(nolock) on c.custid = cc.IBCCustID
		inner join CasinoAdmin.dbo.CustSetting cs with(nolock) on cc.custid = cs.CustSettingID
	where srecommend = @srecommend 
		and c.roleid <= 4
		and c.custid <= @MaxCustId
		and c.SyncCasino = 1
		and Enabled = 1
end