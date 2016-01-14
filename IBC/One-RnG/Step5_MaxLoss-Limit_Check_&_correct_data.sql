  use CustDB
  go
  /*
	Date: 2016-01-06
	Task: correct GD win limit
	DB: DBCUST/CUSTDB
 */
 --deploy table CheckRnGWinLimit on DBCUST 

-- BEGIN STEP 1: Check data ------
------------------------------------------------------
 if object_id('CheckRnGWinLimit', 'u') is null
 begin
	select 'Table named CheckRnGWinLimit does not exist'
	return
end
 
create table ##supers (rowindex int identity(1,1), custid int)

insert into ##supers(custid)
select ci.custid
from dbo.CustInfo ci with(nolock)
	inner join dbo.customer c with (nolock) on ci.custid = c.custid
	inner join dbo.site s with (nolock) on c.site = s.site
	left join dbo.custsuper cs with (nolock) on ci.custid = cs.custid
where ci.roleid = 4 	
	and ci.username not like '3rdSuper%'
	and cs.isinternal = 0
	and ci.custid not in (select custid from dbo.Dep_CustSuper with(nolock))
	and s.islicensee = 0
	
declare @srecommend int, @rowindex int, @bettype smallint, @sporttype smallint
select @rowindex = 1, @bettype = 2101, @sporttype = 208

--delete for round #2
delete from dbo.CheckRnGWinLimit

while exists (select top 1 1 from ##supers where rowindex = @rowindex)
begin

	select @srecommend = custid
	from ##supers where rowindex = @rowindex
	select @rowindex = @rowindex + 1
	
	--master level
	insert into dbo.CheckRnGWinLimit(custid, maxWinLimitA, isAutoResetA, maxLossLimitA
		, custidB, maxWinLimitB, isAutoResetB, maxLossLimitB
		, roleid)	
	select ci.custid as custid, cs.maxWinLimit as maxWinLimitA, cs.isAutoReset as isAutoResetA, cs.MaxLossLimit as MaxLossLimitA
		, ci.srecommend as custidB, scs.maxWinLimit as maxWinLimitB, scs.isAutoReset as isAutoResetB, scs.MaxLossLimit as MaxLossLimitB
		, 3 as roleid
	from dbo.CustWinLimit cs with(nolock)
		inner join dbo.CustInfo ci with(nolock) on cs.custid = ci.custid
		inner join dbo.CustWinLimit scs with(nolock) 
			on scs.custid = ci.srecommend
				and scs.sporttype = cs.sporttype
				and scs.bettype = cs.bettype
	where ci.srecommend = @srecommend 
		and ci.roleid = 3
		and cs.sporttype = @sporttype
		and cs.bettype = @bettype
		and (
				(scs.maxWinLimit > 0 and (cs.maxWinLimit = 0 or cs.maxWinLimit > scs.maxWinlimit))
				or (scs.maxLossLimit > 0 and (cs.maxLossLimit = 0 or cs.maxLossLimit > scs.maxLossLimit))
				or (scs.IsAutoReset = 0 and cs.IsAutoReset = 1)
			)

	--agent level
	insert into dbo.CheckRnGWinLimit(custid, maxWinLimitA, isAutoResetA, maxLossLimitA
		, custidB, maxWinLimitB, isAutoResetB, maxLossLimitB
		, roleid)	
	select ci.custid as custid, cs.maxWinLimit as maxWinLimitA, cs.isAutoReset as isAutoResetA, cs.MaxLossLimit as MaxLossLimitA
		, ci.mrecommend as custidB,  mcs.maxWinLimit as maxWinLimitB, mcs.isAutoReset as isAutoResetB, mcs.maxWinLimit as MaxLossLimitB
		, 2
	from dbo.CustWinLimit cs with(nolock)
		inner join dbo.CustInfo ci with(nolock) on cs.custid = ci.custid
		inner join dbo.CustWinLimit scs with(nolock) 
			on scs.custid = ci.srecommend
				and scs.sporttype = cs.sporttype
				and scs.bettype = cs.bettype
		inner join dbo.CustWinLimit mcs with(nolock) 
			on mcs.custid = ci.mrecommend
				and mcs.sporttype = cs.sporttype
				and mcs.bettype = cs.bettype													
	where ci.srecommend = @srecommend 
		and ci.roleid = 2
		and cs.sporttype = @sporttype
		and cs.bettype = @bettype
		and (	--maxwin
				(scs.maxWinLimit > 0 and (mcs.maxWinLimit = 0 or cs.maxWinLimit = 0 or cs.maxWinLimit > mcs.maxWinlimit))
				or (scs.maxWinLimit = 0 and (mcs.maxWinLimit > 0 and (cs.maxWinLimit = 0 or cs.maxWinLimit > mcs.maxWinlimit)))
				--maxloss
				or (scs.maxLossLimit > 0 and (mcs.maxLossLimit = 0 or cs.maxLossLimit = 0 or cs.maxLossLimit > mcs.maxLossLimit))
				or (scs.maxLossLimit = 0 and (mcs.maxLossLimit > 0 and (cs.maxLossLimit = 0 or cs.maxLossLimit > mcs.maxLossLimit)))
				--isauto
				or (scs.IsAutoReset = 0 and (mcs.IsAutoReset = 1 or cs.IsAutoReset = 1))
				or (scs.IsAutoReset = 1 and mcs.IsAutoReset = 0 and cs.IsAutoReset = 1)
			)

	--member level
	insert into dbo.CheckRnGWinLimit(custid, maxWinLimitA, isAutoResetA, maxLossLimitA
		, custidB, maxWinLimitB, isAutoResetB, maxLossLimitB
		, roleid)	
	select ci.custid as custid, cs.maxWinLimit as maxWinLimitA, cs.isAutoReset as isAutoResetA, cs.MaxLossLimit as maxLossLimitA
		, ci.recommend as custidB,  acs.maxWinLimit as maxWinLimitB, acs.isAutoReset as isAutoResetB, acs.MaxLossLimit as maxLossLimitB
		, 1 as roleid
	from dbo.CustWinLimit cs with(nolock)
		inner join dbo.CustInfo ci with(nolock) on cs.custid = ci.custid
		inner join dbo.CustWinLimit scs with(nolock) 
			on scs.custid = ci.srecommend
				and scs.sporttype = cs.sporttype
				and scs.bettype = cs.bettype
		inner join dbo.CustWinLimit mcs with(nolock) 
			on mcs.custid = ci.mrecommend
				and mcs.sporttype = cs.sporttype
				and mcs.bettype = cs.bettype													
		inner join dbo.CustWinLimit acs with(nolock) 
			on acs.custid = ci.recommend
				and acs.sporttype = cs.sporttype
				and acs.bettype = cs.bettype													
	where ci.srecommend = @srecommend 
		and ci.roleid = 1
		and cs.sporttype = @sporttype
		and cs.bettype = @bettype
		and (	--maxwin
				(scs.maxWinLimit > 0 and (mcs.maxWinLimit = 0 or acs.maxWinLimit = 0 or cs.maxWinLimit = 0 or cs.maxWinLimit > acs.maxWinlimit))
				or (scs.maxWinLimit > 0 and mcs.maxWinLimit > 0 and (acs.maxWinLimit = 0 or cs.maxWinLimit = 0 or cs.maxWinLimit > acs.maxWinlimit))
				or (scs.maxWinLimit > 0 and mcs.maxWinLimit > 0 and acs.maxWinLimit > 0 and (cs.maxWinLimit = 0 or cs.maxWinLimit > acs.maxWinlimit))
				or (scs.maxWinLimit = 0 and mcs.maxWinLimit = 0 and acs.maxWinLimit > 0 and (cs.maxWinLimit = 0 or cs.maxWinLimit > acs.maxWinlimit))
				or (scs.maxWinLimit = 0 and mcs.maxWinLimit > 0 and acs.maxWinLimit > 0 and (cs.maxWinLimit = 0 or cs.maxWinLimit > acs.maxWinlimit))
				or (scs.maxWinLimit = 0 and mcs.maxWinLimit > 0 and acs.maxWinLimit = 0 and cs.maxWinLimit = 0)
				--maxloss
				or (scs.maxLossLimit > 0 and (mcs.maxLossLimit = 0 or acs.maxLossLimit = 0 or cs.maxLossLimit = 0 or cs.maxLossLimit > acs.maxLossLimit))
				or (scs.maxLossLimit > 0 and mcs.maxLossLimit > 0 and (acs.maxLossLimit = 0 or cs.maxLossLimit = 0 or cs.maxLossLimit > acs.maxLossLimit))
				or (scs.maxLossLimit > 0 and mcs.maxLossLimit > 0 and acs.maxLossLimit > 0 and (cs.maxLossLimit = 0 or cs.maxLossLimit > acs.maxLossLimit))
				or (scs.maxLossLimit = 0 and mcs.maxLossLimit = 0 and acs.maxLossLimit > 0 and (cs.maxLossLimit = 0 or cs.maxLossLimit > acs.maxLossLimit))
				or (scs.maxLossLimit = 0 and mcs.maxLossLimit > 0 and acs.maxLossLimit > 0 and (cs.maxLossLimit = 0 or cs.maxLossLimit > acs.maxLossLimit))
				or (scs.maxLossLimit = 0 and mcs.maxLossLimit > 0 and acs.maxLossLimit = 0 and cs.maxLossLimit = 0)
				--isauto
				or (scs.IsAutoReset = 0 and (mcs.IsAutoReset = 1 or acs.IsAutoReset = 1 or cs.IsAutoReset = 1))--un-sync master
				or (scs.IsAutoReset = 0 and mcs.IsAutoReset = 0 and (acs.IsAutoReset = 1 or cs.IsAutoReset = 1))--un-sync agent
				or (scs.IsAutoReset = 0 and mcs.IsAutoReset = 0 and acs.IsAutoReset = 0 and cs.IsAutoReset = 1)	--un-sync member			
				or (scs.IsAutoReset = 1 and mcs.IsAutoReset = 0 and (acs.IsAutoReset = 1 or cs.IsAutoReset = 1))--un-sync agent
				or (scs.IsAutoReset = 1 and mcs.IsAutoReset = 0 and acs.IsAutoReset = 0 and cs.IsAutoReset = 1)--un-sync member	
				or (scs.IsAutoReset = 1 and mcs.IsAutoReset = 1 and acs.IsAutoReset = 0 and cs.IsAutoReset = 1)--un-sync member	
			)
end

drop table ##supers
--select * from CheckRnGWinLimit
	
go	    

-- END STEP 1: Check data ------
------------------------------------------------------

-- BEGIN STEP 2: Correct data if have ------
------------------------------------------------------

use CustDB
go

if object_id('CheckRnGWinLimit', 'u') is null
begin
	select 'Table named CheckRnGWinLimit does not exist'
	return
end

if not exists (select top 1 1 from dbo.CheckRnGWinLimit)
begin
	select 'No data'
	return
end

create table #tmp (custid int)
declare @bettype smallint, @sporttype smallint
select @bettype = 2101, @sporttype = 208

--master level
while 1 = 1
begin
	--clean data
	delete from #tmp

	update top (10000) dbo.CheckRnGWinLimit
	set isfinished = 1
	output deleted.custid into #tmp
	where isfinished = 0
		and roleid = 3

	if @@rowcount = 0
		break

	update cs
	set cs.maxWinLimit = case when scs.maxWinLimit > 0 and (cs.maxWinLimit = 0 OR cs.maxWinLimit > scs.maxWinlimit) 
							then scs.maxWinlimit 
							else cs.maxWinLimit 
						end
		, cs.MaxLossLimit = case when scs.MaxLossLimit > 0 and (cs.MaxLossLimit = 0 OR cs.MaxLossLimit > scs.MaxLossLimit) 
							then scs.MaxLossLimit 
							else cs.MaxLossLimit 
						end
		, cs.IsAutoReset = case when scs.IsAutoReset = 0 and cs.IsAutoReset = 1 
							then scs.IsAutoReset 
							else cs.IsAutoReset 
						end
	from dbo.CustWinLimit cs with(updlock,rowlock)
		inner join dbo.CustInfo ci with(nolock) on cs.custid = ci.custid
		inner join dbo.CustWinLimit scs with(nolock) 
			on scs.custid = ci.srecommend
				and scs.sporttype = cs.sporttype
				and scs.bettype = cs.bettype
		where ci.custid in (select custid from #tmp)
			and cs.sporttype = @sporttype
			and cs.bettype = @bettype
			and (
					(scs.maxWinLimit > 0 and (cs.maxWinLimit = 0 or cs.maxWinLimit > scs.maxWinlimit))
					or (scs.maxLossLimit > 0 and (cs.maxLossLimit = 0 or cs.maxLossLimit > scs.maxLossLimit))
					or (scs.IsAutoReset = 0 and cs.IsAutoReset = 1)
				)

end

--agent level
while 1 = 1
begin
	--clean data
	delete from #tmp

	update top (10000) dbo.CheckRnGWinLimit
	set isfinished = 1
	output deleted.custid into #tmp
	where isfinished = 0
		and roleid = 2

	if @@rowcount = 0
		break

	update cs
	set cs.maxWinLimit = case when scs.maxWinLimit > 0 and (cs.maxWinLimit = 0 OR cs.maxWinLimit > scs.maxWinlimit) 
							then scs.maxWinlimit 
							else cs.maxWinLimit 
						end
		, cs.MaxLossLimit = case when scs.MaxLossLimit > 0 and (cs.MaxLossLimit = 0 OR cs.MaxLossLimit > scs.MaxLossLimit) 
							then scs.MaxLossLimit 
							else cs.MaxLossLimit 
						end
		, cs.IsAutoReset = case when scs.IsAutoReset = 0 and cs.IsAutoReset = 1 
							then scs.IsAutoReset 
							else cs.IsAutoReset 
						end
	from dbo.CustWinLimit cs with(updlock,rowlock)
		inner join dbo.CustInfo ci with(nolock) on cs.custid = ci.custid
		inner join dbo.CustWinLimit scs with(nolock) 
			on scs.custid = ci.mrecommend
				and scs.sporttype = cs.sporttype
				and scs.bettype = cs.bettype
		where ci.custid in (select custid from #tmp)
			and cs.sporttype = @sporttype
			and cs.bettype = @bettype
			and (
					(scs.maxWinLimit > 0 and (cs.maxWinLimit = 0 or cs.maxWinLimit > scs.maxWinlimit))
					or (scs.maxLossLimit > 0 and (cs.maxLossLimit = 0 or cs.maxLossLimit > scs.maxLossLimit))
					or (scs.IsAutoReset = 0 and cs.IsAutoReset = 1)
				)

end

--member level
while 1 = 1
begin
	--clean data
	delete from #tmp

	update top (10000) dbo.CheckRnGWinLimit
	set isfinished = 1
	output deleted.custid into #tmp
	where isfinished = 0
		and roleid = 1

	if @@rowcount = 0
		break

	update cs
	set cs.maxWinLimit = case when scs.maxWinLimit > 0 and (cs.maxWinLimit = 0 OR cs.maxWinLimit > scs.maxWinlimit) 
							then scs.maxWinlimit 
							else cs.maxWinLimit 
						end
		, cs.MaxLossLimit = case when scs.MaxLossLimit > 0 and (cs.MaxLossLimit = 0 OR cs.MaxLossLimit > scs.MaxLossLimit) 
							then scs.MaxLossLimit 
							else cs.MaxLossLimit 
						end
		, cs.IsAutoReset = case when scs.IsAutoReset = 0 and cs.IsAutoReset = 1 
							then scs.IsAutoReset 
							else cs.IsAutoReset 
						end
	from dbo.CustWinLimit cs with(updlock,rowlock)
		inner join dbo.CustInfo ci with(nolock) on cs.custid = ci.custid
		inner join dbo.CustWinLimit scs with(nolock) 
			on scs.custid = ci.recommend
				and scs.sporttype = cs.sporttype
				and scs.bettype = cs.bettype
		where ci.custid in (select custid from #tmp)
			and cs.sporttype = @sporttype
			and cs.bettype = @bettype
			and (
					(scs.maxWinLimit > 0 and (cs.maxWinLimit = 0 or cs.maxWinLimit > scs.maxWinlimit))
					or (scs.maxLossLimit > 0 and (cs.maxLossLimit = 0 or cs.maxLossLimit > scs.maxLossLimit))
					or (scs.IsAutoReset = 0 and cs.IsAutoReset = 1)
				)

end

drop table #tmp

go

-- END STEP 2: Correct data if have ------
------------------------------------------------------