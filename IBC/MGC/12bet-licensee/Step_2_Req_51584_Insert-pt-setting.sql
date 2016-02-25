/*
	https://redmine.nexcel.vn/issues/51584
	insert PT setting for 12bet licensee
*/

-- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
alter procedure dbo.Acc_CustSetting3rd_19 @srecommend int	
	, @maxcustid int
	, @target varchar(20)
as
begin
	set nocount on
	
	if (@target = 'replicated' and @@servername = 'dbcust') return	-- run at all replicated servers
	if (@target = 'dbcust' and @@servername <> 'dbcust') return -- run at dbtrans only
	
	if (select count(1) from sys.objects where name in ('custinfo', 'Dep_CustSettingGame')) <> 2
		return

	declare @bettypeIds table (bettype smallint, sporttype smallint, pt money)
	insert into @bettypeIds(bettype, sporttype, pt)
	values(2001, 203, 0.875), (2005, 203, 0.8)
	
	--for super level
	insert into dbo.Dep_CustSettingGame(CustId, Sporttype, Bettype
		, spositiontaking, mpositiontaking, apositiontaking
		, playerdiscount, discount, adiscount, sdiscount)
	select @srecommend, sporttype, bettype
		, pt, 0, 0
		, 0, 0, 0, 0
	from @bettypeIds

	--for master, agent & member level
	insert into dbo.Dep_CustSettingGame(CustId, Sporttype, Bettype
		, spositiontaking, mpositiontaking, apositiontaking
		, playerdiscount, discount, adiscount, sdiscount)
	select ci.custid, f.sporttype, f.bettype
		, case when ci.roleid = 4 then f.pt else 0 end as spositiontaking
		, case when ci.roleid = 3 then f.pt else 0 end as mpositiontaking
		, case when ci.roleid in (2,1) then f.pt else 0 end as apositiontaking
		, 0, 0, 0, 0
	from dbo.custinfo ci with(nolock)
		inner join dbo.custinfo mci with(nolock) on ci.mrecommend = mci.custid
		cross apply @bettypeIds f
	where ci.srecommend = @srecommend
		and ci.roleid <= 4
		and mci.username not like '12betacc%' --need to check for sure
end
go
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
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
	and s.currency in (3, 6, 4, 12, 2, 13, 20, 9, 41, 1, 15, 51, 45, 61, 32)
	
declare @srecommend int

while 1 = 1
begin
	
	update top (1) #superIds
	set isFinished = 1
		, @srecommend = srecommend
	where isFinished = 0
	
	if @@rowcount = 0 break

	exec dbo.Acc_CustSetting3rd_19 @srecommend = @srecommend
			, @maxcustid = @maxcustid
			, @target = 'REPLICATED'
	
	waitfor delay '00:00:0.280'

end

drop table #superIds
go
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
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
	and s.currency in (3, 6, 4, 12, 2, 13, 20, 9, 41, 1, 15, 51, 45, 61, 32)
	
declare @srecommend int

while 1 = 1
begin
	
	update top (1) #superIds
	set isFinished = 1
		, @srecommend = srecommend			
	where isFinished = 0
	
	if @@rowcount = 0 break

	exec dbo.Acc_CustSetting3rd_19 @srecommend = @srecommend
			, @maxcustid = @maxcustid
			, @target = 'DBCUST'
	
	waitfor delay '00:00:0.280'

end

drop table #superIds
go

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------
go
