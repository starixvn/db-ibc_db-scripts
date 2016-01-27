
use bodb02
go

/*
	check data between bettrans & bettransrng for One-RnG
	run on db06 or db052
*/
declare @CustIds table(custid int)
declare @winlostdate smalldatetime

select @winlostdate = '2016-01-26' --replace winlostdate...
insert into @CustIds(custid)
select custid from dbo.custInfo with(nolock) where username in ('member02', 'ACGUUS3838030') --replace username ....

declare @sourcedata table (custid int, username varchar(50), matchid int
	, bettype smallint, winlostdate smalldatetime, status varchar(10)
	, turnover money, winlost money, awinlost money, mwinlost money, swinlost money
	, scomm money, acomm money, comm money, playercomm money)

declare @targetdata table (custid int, username varchar(50), matchid int
	, bettype smallint, winlostdate smalldatetime, status varchar(10)
	, turnover money, winlost money, awinlost money, mwinlost money, swinlost money
	, scomm money, acomm money, comm money, playercomm money)

--case 1: check ticket between bettransrng & bettrans
insert into @sourcedata(custid, username, matchid, bettype, winlostdate, status
	, turnover, winlost, awinlost, swinlost, mwinlost, scomm, acomm, comm, playercomm)
select custid, username, productid, gameID, winlostdate
	, case when sum(winlost-actual_stake+playercomm) > 0 then 'WON'
		when sum(winlost-actual_stake+playercomm) < 0 then 'LOSE'
		else 'DRAW' end as status
	, sum(stake) as stake, sum(winlost-actual_stake) as winlost, sum(awinlost) as awinlost, sum(swinlost) as swinlost, sum(mwinlost) as mwinlost
	, sum(scomm) as scomm, sum(acomm) as acomm, sum(comm) as comm, sum(playercomm) as playercomm
from dbo.bettransRnG with(nolock)
where custid in (select custid from @CustIds)
	and productID in (208,209,210)
	and winlostdate = @winlostdate
	and issum = 1
group by custid, username, productid, gameid, winlostdate

insert into @targetdata(custid, username, matchid, bettype, winlostdate, status
	, turnover, winlost, awinlost, swinlost, mwinlost, scomm, acomm, comm, playercomm)
select custid, username, matchid, bettype, winlostdate, status
	, sum(stake) as stake, sum(winlost-actual_stake) as winlost
	, sum(awinlost) as awinlost, sum(swinlost) as swinlost, sum(mwinlost) as mwinlost
	, sum(scomm) as scomm, sum(acomm) as acomm, sum(comm) as comm, sum(playercomm) as playercomm
from dbo.bettrans with(nolock)
where custid in (select custid from @CustIds)
	and matchid in (208,209,210)
	and winlostdate = @winlostdate
	and statusid not in (0,1)
group by custid, username, matchid, bettype, winlostdate, status

--
select s.*, t.*
from @sourcedata s
	inner join @targetdata t on s.custid = t.custid and s.bettype = t.bettype and s.winlostdate = t.winlostdate
where s.turnover <> t.turnover 
	or s.winlost <> t.winlost 
	or s.swinlost <> t.swinlost 
	or s.mwinlost <> t.mwinlost 
	or s.awinlost <> t.awinlost
	or s.scomm <> t.scomm 
	or s.acomm <> t.acomm 
	or s.comm <> t.comm 
	or s.playercomm <> t.playercomm


go
