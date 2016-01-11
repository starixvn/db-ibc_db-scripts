
use custdb
go
/*
	this script copy data for CustWinlimit of ONE-RnG
*/

declare @MaxCustId int, @SportType smallint, @BetType smallint

set @MaxCustId = 20335378

select @SportType = 208, @BetType = 2101

create table #superIds (rowindex int identity(1,1), srecommend int)

insert into #superIds(srecommend)
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
