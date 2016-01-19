use custdb
go
/*
	this script copy data for CustWinlimit of ONE-RnG
	run on dbcust
*/
go
-- BEGIN STEP 1: Pull data from DBCASINO ON @DBCUST---
------------------------------------------------------
create table #supers (custid int, isFinished bit default(0))

insert into #supers(custid)
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

declare @srecommend int, @sqlQuery varchar(1024)
while 1 = 1-- exists (select 1 from #supers where rowindex = @rowindex)
begin
	update top (1) #supers
	set isFinished = 1
		, @srecommend = custid			
	where isFinished = 0
	
	if @@rowcount = 0 break

	set @sqlQuery = 'select custid, IsAutoReset, MaxLossLimit
						from openquery(dbcasino, ''select custid, IsAutoReset, MaxLossLimit
							from CasinoAdmin.dbo.CustLossLimitTmp with (nolock) 
							where custid = ''''' + CAST(@srecommend AS VARCHAR(20)) 
					+ ''''' option (maxdop 4)'')'
	--print @sqlQuery
	insert into dbo.CustLossLimitTmp(custid, IsAutoReset, MaxLossLimit)
	exec (@sqlQuery)
end
go
-- END STEP 1: Pull data from DBCASINO ON @DBCUST---
------------------------------------------------------

-- BEGIN STEP 2: Pull data from DBCASINO ON REPLICATED SERVER --@DB06/DBTP 
--need to change link server properly
------------------------------------------------------
create table #supers (custid int, isFinished bit default(0))

insert into #supers(custid)
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

declare @srecommend int, @sqlQuery varchar(1024)
while 1=1 -- exists (select 1 from #supers where rowindex = @rowindex)
begin
	update top (1) #supers
	set isFinished = 1
		, @srecommend = custid			
	where isFinished = 0
	
	if @@rowcount = 0 break

	set @sqlQuery = 'select custid, IsAutoReset, MaxLossLimit
						from openquery(dbcasino, ''select custid, IsAutoReset, MaxLossLimit
							from CasinoAdmin.dbo.CustLossLimitTmp with (nolock) 
							where custid = ''''' + CAST(@srecommend AS VARCHAR(20)) 
					+ ''''' option (maxdop 4)'')'
	--print @sqlQuery
	insert into dbo.CustLossLimitTmp(custid, IsAutoReset, MaxLossLimit)
	exec (@sqlQuery)
end

-- END STEP 2: Pull data from DBCASINO ON REPLICATED SERVER
------------------------------------------------------


