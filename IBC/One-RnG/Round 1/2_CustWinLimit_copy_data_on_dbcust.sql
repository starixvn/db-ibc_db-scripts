
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
from dbo.custInfo ci with(nolock) 
	left join dbo.custsuper cs with (nolock) on ci.custid = cs.custid
where roleid = 4 
	and srecommend <= @MaxCustId
	and ci.username not like '3rdSuper%' --dummy acc
	and cs.isinternal = 0 --finance acc
--group by srecommend

--select * from #superIds

--return

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
