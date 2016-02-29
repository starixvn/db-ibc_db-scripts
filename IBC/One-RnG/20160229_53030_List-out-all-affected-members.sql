use bodb02
go
/*
	https://redmine.nexcel.vn/issues/53030
	- List out all affected members

	Run on DBTXN
*/

declare @sporttype smallint
	, @bettype smallint

select @sporttype = 208, @bettype = 2101

create table #DataTmp(custid int, username varchar(50), roleid tinyint, MaxWinLimit money, MaxLossLimit money, credit money)

insert into #DataTmp(custid, MaxWinLimit, MaxLossLimit, credit, username, roleid)
	select c.custid, MaxWinLimit, MaxLossLimit, c.credit, username, roleid
	from CustDB.dbo.custinfo c with (nolock)
		inner join DBCUST.CustDB.dbo.CustWinLimit cwl with (nolock) 
			on cwl.CustId = c.custid 
				and cwl.sporttype = @sporttype
				and cwl.bettype = @bettype
	where c.roleid = 1 AND cwl.MaxWinLimit > 0 AND cwl.IsAutoReset = 0

select tt.custid, username, roleid, t.winlost, (credit * MaxWinLimit) as maxwinning, (credit * MaxLossLimit) as maxloss
	, case when (t.winlost > (credit * MaxWinLimit)) then 1 else 0 end as isexccedwinning
	, case when (abs(t.winlost) > (credit * MaxLossLimit)) then 1 else 0 end as isexccedloss
from (
	select custid, sum(Balance) as winlost
	from dbo.BalanceCreditGame b with(nolock) where bettype = @bettype and winlostdate >= '2016-01-27'
	group by custid

	union all
	select custid, -sum(Balance) as winlost
	from dbo.BalanceDebitGame b with(nolock) where bettype = @bettype and winlostdate >= '2016-01-27'
	group by custid
) t inner join #DataTmp tt on t.custid = tt.custid
where (t.winlost > (credit * MaxWinLimit))
	or (abs(t.winlost) > (credit * MaxLossLimit))

drop table #DataTmp

go
