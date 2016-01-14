use custdb
go
/*
	this script copy data for CustWinlimit of ONE-RnG
	run on dbcust
*/
go

-- BEGIN STEP 1: Pull data from DBCASINO ON REPLICATED SERVER --@DB06/DBTP
------------------------------------------------------
create table #supers (rowindex int identity(1,1), custid int)

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

declare @srecommend int, @rowindex int, @sqlQuery varchar(1024)
select @rowindex = 1
while exists (select 1 from #supers where rowindex = @rowindex)
begin
	select @srecommend = custid from #supers where rowindex = @rowindex
	set @rowindex = @rowindex + 1

	set @sqlQuery = 'select custid, IsAutoReset, MaxLossLimit
						from openquery(dbcasino, ''select custid, IsAutoReset, MaxLossLimit
							from CasinoAdmin.dbo.CustLossLimitTmp with (nolock) 
							where custid = ''''' + CAST(@srecommend AS VARCHAR(20)) 
					+ ''''' option (maxdop 4)'')'
	--print @sqlQuery
	insert into dbo.CustLossLimitTmp(custid, IsAutoReset, MaxLossLimit)
	exec (@sqlQuery)
end

-- END STEP 1: Pull data from DBCASINO ON REPLICATED SERVER
------------------------------------------------------


-- BEGIN STEP 1: Pull data from DBCASINO ON @DBCUST---
------------------------------------------------------
create table #supers (rowindex int identity(1,1), custid int)

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

declare @srecommend int, @rowindex int, @sqlQuery varchar(1024)
select @rowindex = 1
while exists (select 1 from #supers where rowindex = @rowindex)
begin
	select @srecommend = custid from #supers where rowindex = @rowindex
	set @rowindex = @rowindex + 1

	set @sqlQuery = 'select custid, IsAutoReset, MaxLossLimit
						from openquery(dbcasino, ''select custid, IsAutoReset, MaxLossLimit
							from CasinoAdmin.dbo.CustLossLimitTmp with (nolock) 
							where custid = ''''' + CAST(@srecommend AS VARCHAR(20)) 
					+ ''''' option (maxdop 4)'')'
	--print @sqlQuery
	insert into dbo.CustLossLimitTmp(custid, IsAutoReset, MaxLossLimit)
	exec (@sqlQuery)
end

-- END STEP 1: Pull data from DBCASINO ON @DBCUST---
------------------------------------------------------