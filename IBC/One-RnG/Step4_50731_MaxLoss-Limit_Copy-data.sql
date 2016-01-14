
use custdb
go
/*
	this script copy data for CustWinlimit of ONE-RnG
	run on DBCust.CustDB
*/

 -- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
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
	select c.custid, @SportType, @BetType, 0, cc.IsAutoReset, isnull(cc.MaxTransferCredit, 0)
	from dbo.custInfo c with(nolock)
		inner join dbo.CustLossLimitTmp cc with(nolock) on c.custid = cc.custid
	where srecommend = @srecommend 
		and c.roleid <= 4
		and c.custid <= @MaxCustId
		and c.SyncCasino = 1
		and Enabled = 1
end
go
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------

declare @MaxCustId int, @SportType smallint, @BetType smallint
select @SportType = 208, @BetType = 2101

set @MaxCustId = ???

create table #superIds (rowindex int identity(1,1), srecommend int)

insert into #superIds(srecommend)
select ci.custid 
from dbo.custInfo ci with(nolock) 
	left join dbo.custsuper cs with (nolock) on ci.custid = cs.custid
where roleid = 4 
	and srecommend <= @MaxCustId
	and ci.username not like '3rdSuper%' --dummy acc
	and cs.isinternal = 0 --finance acc
	and not exists (select 1 from dbo.Dep_CustSuper cs with (nolock) where ci.custid = cs.custid)
	
declare @rowindex int, @srecommend int
set @rowindex = 1
while exists (select top 1 1 from #superIds where rowindex = @rowindex)
begin
	select @srecommend = srecommend from #superIds where rowindex = @rowindex
	set @rowindex = @rowindex + 1

	exec dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
			, @maxcustid = @maxcustid
			, @target = 'REPLICATED'
			, @SportType = @SportType
			, @BetType = @BetType
	
	waitfor delay '00:00:0.280'

end

drop table #superIds
go
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
-----------------------------------------------------------------------------------

---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
declare @MaxCustId int, @SportType smallint, @BetType smallint
select @SportType = 208, @BetType = 2101

set @MaxCustId = ???

create table #superIds (rowindex int identity(1,1), srecommend int)

insert into #superIds(srecommend)
select ci.custid 
from dbo.custInfo ci with(nolock) 
	left join dbo.custsuper cs with (nolock) on ci.custid = cs.custid
where roleid = 4 
	and srecommend <= @MaxCustId
	and ci.username not like '3rdSuper%' --dummy acc
	and cs.isinternal = 0 --finance acc
	and not exists (select 1 from dbo.Dep_CustSuper cs with (nolock) where ci.custid = cs.custid)
	
declare @rowindex int, @srecommend int
set @rowindex = 1
while exists (select top 1 1 from #superIds where rowindex = @rowindex)
begin
	select @srecommend = srecommend from #superIds where rowindex = @rowindex
	set @rowindex = @rowindex + 1

	exec dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
			, @maxcustid = @maxcustid
			, @target = 'DBCUST'
			, @SportType = @SportType
			, @BetType = @BetType
	
	waitfor delay '00:00:0.280'

end

drop table #superIds
go

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------