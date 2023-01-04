/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	RUN at KBT@DB061
	Created: Bobby@20221128
	Task: Correct rptStatement historical data
	Redmine: https://nexdev.net/issues/169560
*/
use bodb_Report;
GO
--- 259 affected rows
with cte 
AS (
	select *
	from (
		values(6630793,	cast('2021-07-23' as smalldatetime),	cast(10.8504 as money))
	) as t (custid, winlostdate, winlost)
), result AS (
	select cte.custid, rpt.WinlostDate
		, case when rpt.WinlostDate = cte.winlostdate then rpt.Winlost + cte.winlost else rpt.Winlost end as winlost_New
		, case when rpt.WinlostDate > cte.winlostdate and rpt.WinlostDate <= '2022-04-07' then rpt.OpeningBalance + cte.winlost else rpt.OpeningBalance end as OpeningBalance_New
		, case when rpt.WinlostDate >= cte.winlostdate and rpt.WinlostDate < '2022-04-07' then rpt.ClosingBalance + cte.winlost else rpt.ClosingBalance end as ClosingBalance_New
		, rpt.OpeningBalance, rpt.Winlost,  rpt.ClosingBalance
	from cte
	inner join rptStatement_Old rpt with(nolock) on rpt.Custid = cte.custid and rpt.WinlostDate >= cte.winlostdate
	where rpt.WinlostDate >= '2021-07-23' and rpt.WinlostDate <= '2022-04-07'
) 
--select concat('(', custid, ',''', convert(varchar(20), winlostdate, 120), ''',', FORMAT(OpeningBalance_New, 'G'), ',', FORMAT(winlost_New, 'G'), ',',FORMAT(ClosingBalance_New,'G') ,'),')
--from result
--select * from result
update TOP(259) rpt with(rowlock, updlock)
set rpt.Winlost = up.winlost_New
	, rpt.OpeningBalance =  up.OpeningBalance_New
	, rpt.ClosingBalance =  up.ClosingBalance_New
from rptStatement_Old rpt
inner join result up on up.custid = rpt.Custid and up.WinlostDate = rpt.WinlostDate

---part 2 - 3 rows affected
;with cte 
AS (
	select *
	from (
		values(6630793,	cast('2022-04-07' as smalldatetime),	cast(-3.869 as money))
		,(14616559,	'2022-04-07',	-60.9244)
		,(62026177,	'2022-04-07',	-186.9769)
	) as t (custid, winlostdate, winlost)
), result AS (
	select cte.custid, rpt.WinlostDate
		, case when rpt.WinlostDate = cte.winlostdate then rpt.Winlost + cte.winlost else rpt.Winlost end as winlost_New
		, case when rpt.WinlostDate = cte.winlostdate then rpt.OpeningBalance + (rpt.Winlost + cte.winlost) + rpt.Comm else rpt.ClosingBalance end as ClosingBalance_New
		, rpt.OpeningBalance, rpt.Winlost,  rpt.ClosingBalance
	from cte
	inner join rptStatement_Old rpt with(nolock) on rpt.Custid = cte.custid and rpt.WinlostDate = cte.winlostdate
	where rpt.WinlostDate = '2022-04-07'
)
--select * from result
--select concat('(', custid, ',''', convert(varchar(20), winlostdate, 120), ''',', FORMAT(winlost_New, 'G'), ',',FORMAT(ClosingBalance_New,'G') ,'),')
--from result
update TOP(3) rpt with(rowlock, updlock)
set rpt.Winlost = up.winlost_New
	, rpt.ClosingBalance =  up.ClosingBalance_New
from rptStatement_Old rpt
inner join result up on up.custid = rpt.Custid and up.WinlostDate = rpt.WinlostDate
