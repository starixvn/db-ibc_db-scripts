/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	RUN at KBT@DB062
	Created: Bobby@20221129
	Task: Correct rptStatement historical data
	Redmine: https://nexdev.net/issues/169560
*/
use bodb_Report;
GO

drop table if exists #chkCust;
drop table if exists #result;

create table #result (rIdx INT identity(1,1) primary key, WinlostDate smalldatetime, Custid int, OpeningBalance money, TransferAmt money, ClosingBalance money, OpeningTotalBalance money)

declare @cIdx int, @batch int = 500;

select custid, DiffFrom
INTO #chkCust
from (
	values (6911909,cast('2022-07-07' as smalldatetime)),
	(6911911,'2022-07-07'),
	(6911913,'2022-07-07'),
	(6911914,'2022-07-07'),
	(6911916,'2022-07-07'),
	(6911918,'2022-07-07'),
	(8158305,'2022-07-07'),
	(14054918,'2022-07-07'),
	(18188766,'2022-07-07'),
	(20174356,'2022-07-07'),
	(20664406,'2022-07-07'),
	(21080784,'2022-07-07'),
	(21080850,'2022-07-07'),
	(21080917,'2022-07-07'),
	(21080930,'2022-07-07'),
	(21080986,'2022-07-07'),
	(21080997,'2022-07-07'),
	(21081023,'2022-07-07'),
	(21289307,'2022-07-07'),
	(21535688,'2022-07-07'),
	(23765766,'2022-07-07'),
	(26513853,'2022-07-07'),
	(26513859,'2022-07-07'),
	(28435541,'2022-07-07'),
	(29712506,'2022-07-07'),
	(35739415,'2022-07-07'),
	(37499112,'2022-07-07'),
	(40069250,'2022-04-07'),
	(40289263,'2022-04-07'),
	(40699724,'2022-04-07'),
	(41936271,'2022-04-07'),
	(42339463,'2022-04-07'),
	(42372045,'2022-04-07'),
	(42612749,'2022-04-07'),
	(42639190,'2022-04-07'),
	(42794723,'2022-04-07'),
	(43027344,'2022-04-07'),
	(43164358,'2022-04-07'),
	(44658119,'2022-04-07'),
	(45318301,'2022-04-07'),
	(46337228,'2022-04-07'),
	(46772844,'2022-04-07'),
	(47072738,'2022-04-07'),
	(47352638,'2022-04-07'),
	(47582912,'2022-04-07'),
	(48614882,'2022-04-07'),
	(48749081,'2022-04-07'),
	(48878251,'2022-04-07'),
	(49353402,'2022-04-07'),
	(50389504,'2022-04-07'),
	(50550771,'2022-04-07'),
	(50728919,'2022-04-07'),
	(50858848,'2022-04-07'),
	(54297999,'2022-04-07'),
	(60129882,'2022-04-07'),
	(62585582,'2022-09-15'),
	(60655820,'2022-09-15')
) as t (custid, DiffFrom);

-- Part 1 - Sync rptStatement_Old - 9901 rows
insert into #result (WinlostDate, Custid, OpeningBalance, TransferAmt, ClosingBalance, OpeningTotalBalance)
select rpt.WinlostDate, rpt.Custid, rpt.OpeningBalance, rpt.TransferAmt, rpt.ClosingBalance, rpt.OpeningTotalBalance
from #chkCust cte
inner join DBRPT.bodb_report.dbo.rptStatement_Old rpt with(nolock) on rpt.Custid=cte.custid and rpt.WinlostDate > cte.DiffFrom

select @@ROWCOUNT [#result]

SET @cIdx = 0;
while exists (select top 1 1 from #result where rIdx >  @cIdx)
begin
	update top(@batch) rpt with(rowlock, updlock)
	set rpt.OpeningBalance = rs.OpeningBalance
		,rpt.TransferAmt = rs.TransferAmt
		,rpt.ClosingBalance = rs.ClosingBalance
		,rpt.OpeningTotalBalance = rs.OpeningTotalBalance
	FROM dbo.rptStatement_Old rpt
	inner join #result rs ON rs.Custid = rpt.Custid AND rs.WinlostDate = rpt.WinlostDate
	where rs.rIdx > @cIdx

	if @@ROWCOUNT < @batch BREAK

	set @cIdx += @batch;
end

-- Part 2 - Sync rptStatement - 448 rows
drop table if exists #result2;
create table #result2 (rIdx INT identity(1,1) primary key, WinlostDate smalldatetime, Custid int, OpeningBalance money, TransferAmt money, ClosingBalance money, OpeningTotalBalance money)

insert into #result2 (WinlostDate, Custid, OpeningBalance, TransferAmt, ClosingBalance, OpeningTotalBalance)
select rpt.WinlostDate, rpt.Custid, rpt.OpeningBalance, rpt.TransferAmt, rpt.ClosingBalance, rpt.OpeningTotalBalance
from #chkCust cte
inner join DBRPT.bodb_report.dbo.rptStatement rpt with(nolock) on rpt.Custid=cte.custid and rpt.WinlostDate > cte.DiffFrom

select @@ROWCOUNT [#result2]

SET @cIdx = 0;
while exists (select top 1 1 from #result2 where rIdx >  @cIdx)
begin
	update top(@batch) rpt with(rowlock, updlock)
	set rpt.OpeningBalance = rs.OpeningBalance
		,rpt.TransferAmt = rs.TransferAmt
		,rpt.ClosingBalance = rs.ClosingBalance
		,rpt.OpeningTotalBalance = rs.OpeningTotalBalance
	FROM dbo.rptStatement rpt
	inner join #result2 rs ON rs.Custid = rpt.Custid AND rs.WinlostDate = rpt.WinlostDate
	WHERE rs.rIdx > @cIdx;

	if @@ROWCOUNT < @batch BREAK

	set @cIdx += @batch;
end