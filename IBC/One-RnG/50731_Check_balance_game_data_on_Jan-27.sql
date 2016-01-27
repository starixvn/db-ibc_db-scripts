use bodb02
go

/*
	check balance game data for One-RnG
	run on dbtrans
*/
declare @CustIds table(custid int)
declare @winlostdate smalldatetime

select @winlostdate = '2016-01-26' --replace winlostdate...
insert into @CustIds(custid)
select custid from custdb.dbo.custInfo with(nolock) where username in ('member02', 'ACGUUS3838030') --replace username ....

declare @sourcedata table (custid int, bettype smallint, winlostdate smalldatetime, winlost money)

--check balance game
insert into @sourcedata(custid, winlostdate, winlost, bettype)
select custid, winlostdate, sum(winlost-actual_stake+playercomm) as winlost, 2101
from dbo.bettransRnG with(nolock)
where custid in (select custid from @CustIds)
	and productID in (208,209,210)
	and winlostdate = @winlostdate
	and statusID in (112,113)
group by custid, winlostdate

select g.*, s.*
from dbo.BalanceCreditGame g with(nolock)
	inner join @sourcedata s on g.custid = s.custid and g.winlostdate = s.winlostdate and g.bettype = s.bettype
where s.winlost > 0 and g.balance <> s.winlost

select g.*, s.*
from dbo.BalanceDebitGame g with(nolock)
	inner join @sourcedata s on g.custid = s.custid and g.winlostdate = s.winlostdate and g.bettype = s.bettype
where s.winlost < 0 and g.balance <> abs(s.winlost)

go
