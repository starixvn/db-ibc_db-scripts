
use bodb02
go

/*
	check balance game data for One-RnG
	run on dbtrans
*/
declare @CustIds table(custid int)
declare @winlostdate smalldatetime

select @winlostdate = '2016-01-26' --replace winlostdate...
--insert into @CustIds(custid)
--select custid from custdb.dbo.custInfo with(nolock) where username in ('member02', 'ACGUUS3838030') --replace username ....

declare @sourcedata table (custid int, bettype smallint, winlostdate smalldatetime, winlost money)
declare @targetdata table (custid int, bettype smallint, winlostdate smalldatetime, winlost money)

--check balance game
insert into @sourcedata(custid, winlostdate, winlost, bettype)
select custid, winlostdate, sum(winlost-actual_stake+playercomm) as winlost, 2101
from dbo.bettransRnG with(nolock)
where productID in (208,209,210)
	and winlostdate = @winlostdate
	and statusID in (112,113)
group by custid, winlostdate

insert into @targetdata(custid, winlostdate, bettype, winlost)
select custid, winlostdate, bettype, sum(balance) as winlost
from (
	select c.custid, c.winlostdate, c.bettype, c.balance
	from dbo.BalanceCreditGame c with(nolock)
	inner join @sourcedata s on c.custid = s.custid and c.winlostdate = s.winlostdate and c.bettype = s.bettype
	
	union all
	select c.custid, c.winlostdate, c.bettype, c.balance * -1
	from dbo.BalanceDebitGame c with(nolock)
	inner join @sourcedata s on c.custid = s.custid and c.winlostdate = s.winlostdate and c.bettype = s.bettype
)t
group by custid, winlostdate, bettype

select *
from @sourcedata s
	inner join @targetdata t on t.custid = s.custid and t.winlostdate = s.winlostdate and t.bettype = s.bettype
where s.winlost <> t.winlost


go
