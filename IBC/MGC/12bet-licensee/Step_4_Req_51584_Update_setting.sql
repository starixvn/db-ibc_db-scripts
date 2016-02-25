use custdb
go
/*
	https://redmine.nexcel.vn/issues/51584
	Adjust for newly member:
		- insert or update setting for 12bet licensee
		- enable status for 12bet licensee
	run on DBCUST.CustDB
*/

declare @maxcustid int

set @maxcustid = ???

declare @bettypeIds table (bettype smallint, sporttype smallint, pt money)
insert into @bettypeIds(bettype, sporttype, pt)
values(2001, 203, 0.875), (2005, 203, 0.8)

create table #DataTmp (custid int, roleid tinyint, bettype smallint, sporttype smallint, pt money)

insert into #DataTmp(custid, roleid, bettype, sporttype, pt)
select ci.custid, ci.roleid, f.bettype, f.sporttype, f.pt
from dbo.custinfo ci with(nolock)
	inner join dbo.custinfo mci with(nolock) on ci.mrecommend = mci.custid
	inner join dbo.Dep_CustSuper s with(nolock) on ci.srecommend = s.custid
	cross apply @bettypeIds f
where ci.custid > @maxcustid
	and ci.roleid <= 4
	and mci.username not like '12betacc%' --need to check for sure
	and s.currency in (3, 6, 4, 12, 2, 13, 20, 9, 41, 1, 15, 51, 45, 61, 32)
	
if not exists (select top 1 1 from #DataTmp)
	return

--====start PT setting=====
--update PT for newly member
update cs
set spositiontaking = case when t.roleid = 4 then t.pt else 0 end
	, mpositiontaking = case when t.roleid = 3 then t.pt else 0 end
	, apositiontaking = case when t.roleid in (2,1) then t.pt else 0 end
from dbo.Dep_CustSettingGame cs with(rowlock, updlock)
	inner join #DataTmp t on cs.CustID = t.custid and cs.Sporttype = t.sporttype and cs.Bettype = t.bettype

--insert PT for newly member
insert into dbo.Dep_CustSettingGame(CustId, Sporttype, Bettype
	, spositiontaking, mpositiontaking, apositiontaking
	, playerdiscount, discount, adiscount, sdiscount)
select t.custid, t.sporttype, t.bettype
	, case when t.roleid = 4 then t.pt else 0 end as spositiontaking
	, case when t.roleid = 3 then t.pt else 0 end as mpositiontaking
	, case when t.roleid in (2,1) then t.pt else 0 end as apositiontaking
	, 0, 0, 0, 0
from #DataTmp t
where not exists (select top 1 1 from dbo.Dep_CustSettingGame cs with(nolock) where cs.CustID = t.custid and cs.Sporttype = t.sporttype and cs.Bettype = t.bettype)

--====end PT setting=====

--====start enable status=====

update ci with(rowlock, updlock)
set DisableMicrogameLC = 0, DisableMicrogameRNG = 0
from dbo.custinfo ci with(nolock)
where exists (select top 1 1 from #DataTmp t where ci.custid = t.custid)
	and (ci.DisableMicrogameLC = 1 or ci.DisableMicrogameRNG = 1)

--====end enable status======

drop table #DataTmp
go
