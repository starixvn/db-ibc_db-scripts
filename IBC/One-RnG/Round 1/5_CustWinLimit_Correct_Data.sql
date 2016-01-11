use CustDB
go

if object_id('CheckGDWinLimit', 'u') is null
begin
	select 'Table named CheckGDWinLimit does not exist'
	return
end

if not exists (select top 1 1 from dbo.CheckGDWinLimit)
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

	update top (10000) dbo.CheckGDWinLimit
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

	update top (10000) dbo.CheckGDWinLimit
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

	update top (10000) dbo.CheckGDWinLimit
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
