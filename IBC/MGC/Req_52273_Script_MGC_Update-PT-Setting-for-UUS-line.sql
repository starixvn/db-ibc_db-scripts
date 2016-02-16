
use custdb
go

/*
	https://redmine.nexcel.vn/issues/52273
	 - Enable MicrogameLC & MicrogameRNG
	 - Update PT setting as generic as 0.875, branded as 0.8
	 for all members under some lines: 12BETUUS01, 12BETUUS02, 12BETUUS03, 12BETUUS04 & 12BETUUS05
	run on DBCUST
*/

create table #CustIds (CustId int)

insert into #CustIds(CustId)
select custid--, roleid, username
from dbo.custInfo ci with(nolock)
where recommend in (858249 --12BETUUS01
					, 916515 --12BETUUS02
					, 2812998 --12BETUUS03
					, 3575283 --12BETUUS04
					, 14390439 --12BETUUS05
)
and roleid = 1

--============ start enable status of member ====================================

update ci
SET DisableMicrogameLC = 0
	, DisableMicrogameRnG = 0
from dbo.CustInfo ci with (rowlock, updlock)
where exists (select top 1 1 from #CustIds c where ci.custid = c.CustId)

--============ end enable status of member ====================================

--============ start update PT setting ====================================
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
					where c.CustId = cs.CustID and cs.Sporttype = 203 and cs.Bettype = 2001)

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
					where c.CustId = cs.CustID and cs.Sporttype = 203 and cs.Bettype = 2005)

--============ end update PT setting ====================================
drop table #CustIds

go
