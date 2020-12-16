-- run on DBCUST-CustDB
create table #site (sitename varchar(50))
insert into #site (sitename)
select '11bet' union all
select '12Bet' -- use excel to get this list

create table #member (sitename varchar(50), custid int)
insert into #member (sitename, custid)
select sitename, custid
from (
	select s.sitename, c.custid, row_number() over(partition by a.site order by c.custid) as rn
	from CustDB.dbo.vw_Customer a with (nolock)
		inner join #site s on a.site = s.sitename
		inner join CustDB.dbo.vw_Customer c with (nolock) on c.recommend = a.custid
	where a.roleid = 2 and c.roleid = 1
		and a.username not like '%ACC%' -- dummy agent
		and c.username not like '%ClearBal' -- balance
		and c.username not like '%CashOut' -- CO
		and a.currency <> 20
) c
where rn = 1

select m.sitename, 1 - s.apositiontaking as HousePT
from CustDB.dbo.Dep_CustSetting s with (nolock)
	inner join #member m on s.custid = m.custid
where sporttype = 1 and bettype = 1 and islive = 0
order by 1

drop table #member
drop table #site