
use bodb02
go

/*
	check data between bettrans & bettransrng for One-RnG
	run on db06 or db052 or dbtrans
*/
declare @CustIds table(custid int)
declare @winlostdate smalldatetime

select @winlostdate = '2016-01-05' --replace winlostdate
insert into @CustIds(custid)
select custid from dbo.custInfo with(nolock) where username in ('12BETUUS01006') --replace username ....

declare @sourcedata table (custid int, username varchar(50), matchid int, bettype smallint, winlostdate smalldatetime, turnover money, winlost money, status varchar(10))
declare @targetdata table (custid int, username varchar(50), matchid int, bettype smallint, winlostdate smalldatetime, turnover money, winlost money, status varchar(10))

--case 1: check ticket between bettransrng & bettrans
insert into @sourcedata(custid, username, matchid, bettype, winlostdate, turnover, winlost, status)
select custid, username, productid, gameID, winlostdate, sum(stake) as stake, sum(winlost-actual_stake) as winlost
	, case when sum(winlost-actual_stake) > 0 then 'WON'
		when sum(winlost-actual_stake) < 0 then 'LOSE'
		else 'DRAW' end as status
from dbo.bettransRnG with(nolock)
where custid in (select custid from @CustIds)
	and productID in (208,209,210)
	and winlostdate = @winlostdate
	and issum = 1
group by custid, username, productid, gameid, winlostdate

insert into @targetdata(custid, username, matchid, bettype, winlostdate, turnover, winlost, status)
select custid, username, matchid, bettype, winlostdate, sum(stake) as stake, sum(winlost-actual_stake) as winlost  
	, status
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
where s.turnover <> t.turnover or s.winlost <> t.winlost


go
