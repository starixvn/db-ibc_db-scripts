
/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	RUN at KBT@DB062
	Created: Bobby@20221128
	Task: Correct rptStatement historical data
	Redmine: https://nexdev.net/issues/169560
*/
use bodb_Report;
GO

--- 634 affected rows - rptStatement_Old
;with result AS (
	select * 
	from 
	( values
		(6630793,	cast('2022-04-08' as smalldatetime), cast(6.9814 as money)),
		(14616559,'2022-04-08',-60.9244),
		(62026177,'2022-04-08',-186.9769)
	) as t (custid, winlostdate, diffOpening)
)
--select count(1)
update TOP(634) rpt with(rowlock, updlock)
set rpt.OpeningBalance = rpt.OpeningBalance + up.diffOpening
	, rpt.ClosingBalance =  rpt.ClosingBalance + up.diffOpening
from rptStatement_Old rpt
inner join result up on up.custid = rpt.Custid and rpt.WinlostDate >= up.WinlostDate


--- 14 affected rows - rptStatement
;with result AS (
	select * 
	from 
	( values
		(6630793,	cast('2022-04-08' as smalldatetime), cast(6.9814 as money)),
		(14616559,'2022-04-08',-60.9244),
		(62026177,'2022-04-08',-186.9769)
	) as t (custid, winlostdate, diffOpening)
)
--select count(1)
update TOP(14) rpt with(rowlock, updlock)
set rpt.OpeningBalance = rpt.OpeningBalance + up.diffOpening
	, rpt.ClosingBalance =  rpt.ClosingBalance + up.diffOpening
from rptStatement rpt
inner join result up on up.custid = rpt.Custid and rpt.WinlostDate >= up.WinlostDate