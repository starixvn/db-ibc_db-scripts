/*
Rollback script:
	https://redmine.nexcel.vn/issues/51584
	enable/disable microgaming for 12bet licensee
*/

-- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
alter procedure dbo.Acc_ExecRep_Cust_09 @srecommend int
	, @maxcustid int
	, @target varchar(20)
as
begin
	set nocount on
	
	if (@target = 'replicated' and @@servername = 'dbcust') return	-- run at all replicated servers
	if (@target = 'dbcust' and @@servername <> 'dbcust') return -- run at dbtrans only
	
	if (select count(1) from sys.objects where name in ('custinfo')) <> 1
		return

	--for super level
	update dbo.custInfo with(rowlock, updlock)
	set DisableMicrogameLC = 1, DisableMicrogameRNG = 1
	where custid = @srecommend 
		--and (DisableMicrogameLC = 0 or DisableMicrogameRNG = 0)

	--for master, agent & member level
	update ci with(rowlock, updlock)
	set DisableMicrogameLC = 1, DisableMicrogameRNG = 1
	from dbo.custinfo ci with(nolock)
		inner join dbo.custinfo mci with(nolock) on ci.mrecommend = mci.custid
	where ci.srecommend = @srecommend
		and ci.roleid <= 4
		and mci.username not like '12betacc%' --need to check for sure
		--and (ci.DisableMicrogameLC = 0 or ci.DisableMicrogameRNG = 0)
end
go
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS -----
--------------------------------------------------------------------------------------

declare @MaxCustId int

set @MaxCustId = ???

create table #superIds (srecommend int, isFinished bit default(0))

insert into #superIds(srecommend)
select ci.custid 
from dbo.custInfo ci with(nolock)
	inner join dbo.Dep_CustSuper s with (nolock) on ci.custid = s.custid
where roleid = 4
	and srecommend <= @MaxCustId
	and s.site = '12bet'
	and s.currency in (3, 6, 4, 12, 2, 13, 9, 41, 1, 15, 51, 45, 61, 32)
	
declare @srecommend int

while 1 = 1
begin
	
	update top (1) #superIds
	set isFinished = 1
		, @srecommend = srecommend
	where isFinished = 0
	
	if @@rowcount = 0 break

	exec dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
			, @maxcustid = @maxcustid
			, @target = 'REPLICATED'
	
	waitfor delay '00:00:0.280'

end

drop table #superIds
go
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
declare @MaxCustId int

set @MaxCustId = ???

create table #superIds (srecommend int, isFinished bit default(0))

insert into #superIds(srecommend)
select ci.custid 
from dbo.custInfo ci with(nolock) 
	inner join dbo.Dep_CustSuper s with (nolock) on ci.custid = s.custid
where roleid = 4
	and srecommend <= @MaxCustId
	and s.site = '12bet'
	and s.currency in (3, 6, 4, 12, 2, 13, 9, 41, 1, 15, 51, 45, 61, 32)
	
declare @srecommend int

while 1 = 1
begin
	
	update top (1) #superIds
	set isFinished = 1
		, @srecommend = srecommend			
	where isFinished = 0
	
	if @@rowcount = 0 break

	exec dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend
			, @maxcustid = @maxcustid
			, @target = 'DBCUST'
	
	waitfor delay '00:00:0.280'

end

drop table #superIds
go

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------
go
