
use custdb
go

/*
	insert or update setting for UUS line of 12bet on member level
		- generic as 0.875
		- branded as 0.8
	run on DBCUST
*/

create table #CustIds (CustId int)

insert into #CustIds(CustId)
select custid--, roleid, username
from dbo.custInfo ci with(nolock)
where exists (select top 1 1 
				from dbo.Dep_CustSuper s with(nolock) 
				where ci.srecommend = s.custid 
					and s.site = '12bet'
					and s.currency = 20)
and roleid = 1

--Geneic game: 0.875
update cs
set apositiontaking = 0.875
from dbo.Dep_CustSettingGame cs with(rowlock, updlock)
where exists (select top 1 1 from #CustIds c where cs.custid = c.custid)
	and Sporttype = 203
	and Bettype = 2001
	and apositiontaking <> 0.875

insert into dbo.Dep_CustSettingGame(CustId, spositiontaking, mpositiontaking, apositiontaking, Sporttype, Bettype)
select c.CustId, 0 as spositiontaking, 0 as mpositiontaking, 0.875 as apositiontaking, 203 as sportype, 2001 as bettype
from #CustIds c
where not exists (select top 1 1 
					from dbo.Dep_CustSettingGame cs with(nolock)
					where c.CustId = cs.CustID and cs.Sporttype = 203 and Bettype = 2001)

--Branded game: 0.8
update cs
set apositiontaking = 0.8
from dbo.Dep_CustSettingGame cs with(rowlock, updlock)
where exists (select top 1 1 from #CustIds c where cs.custid = c.custid)
	and Sporttype = 203
	and Bettype = 2005
	and apositiontaking <> 0.8

insert into dbo.Dep_CustSettingGame(CustID, spositiontaking, mpositiontaking, apositiontaking, Sporttype, Bettype)
select c.CustId, 0 as spositiontaking, 0 as mpositiontaking, 0.8 as apositiontaking, 203 as sportype, 2005 as bettype
from #CustIds c
where not exists (select top 1 1 
					from dbo.Dep_CustSettingGame cs with(nolock) 
					where c.CustId = cs.CustID and cs.Sporttype = 203 and Bettype = 2005)

drop table #CustIds

go
