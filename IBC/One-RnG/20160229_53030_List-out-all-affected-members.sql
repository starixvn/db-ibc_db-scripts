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

create table #DataTmp(custid int, username varchar(50), roleid tinyint, MaxWinLimit money, IsAutoReset bit, MaxLossLimit money, credit money)

insert into #DataTmp(custid, MaxWinLimit, MaxLossLimit, IsAutoReset, credit, username, roleid)
	select c.custid, MaxWinLimit, -MaxLossLimit, IsAutoReset, c.credit, username, roleid
	from CustDB.dbo.custinfo c with (nolock)
		inner join DBCUST.CustDB.dbo.CustWinLimit cwl with (nolock) 
			on cwl.CustId = c.custid 
				and cwl.sporttype = @sporttype
				and cwl.bettype = @bettype
	where c.roleid = 1 AND (cwl.MaxWinLimit > 0 OR cwl.MaxLossLimit > 0) AND cwl.IsAutoReset = 1
	option (maxdop 4)

;with MemberWinning as (
	select custid, sum(winlost) as winlost
	from (
		select custid, Balance as winlost
		from dbo.BalanceCreditGame b with(nolock) where bettype = @bettype and winlostdate >= '2016-01-27'

		union all
		select custid, -Balance as winlost
		from dbo.BalanceDebitGame b with(nolock) where bettype = @bettype and winlostdate >= '2016-01-27'
	) t
	group by custid
)
select tt.custid, username, roleid, t.winlost, IsAutoReset, (credit * MaxWinLimit) as maxwinning, MaxLossLimit as maxloss
	, case when (MaxWinLimit > 0 and t.winlost > (credit * MaxWinLimit)) then 1 else 0 end as isexccedwinning
	, case when (MaxLossLimit > 0 and t.winlost < MaxLossLimit) then 1 else 0 end as isexccedloss
from MemberWinning t 
	inner join #DataTmp tt on t.custid = tt.custid
where (MaxWinLimit > 0 and (t.winlost > (credit * MaxWinLimit)))
	or (MaxLossLimit > 0 and t.winlost < MaxLossLimit)
option (maxdop 4)

drop table #DataTmp

go
