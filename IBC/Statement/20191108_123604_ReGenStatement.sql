/*
Create: 20191108@Sophia
Task: Regen data rptstatement  [redmine : #123604]
DB: DBAcc.bodd_report
*/


--delete data
delete from rptStatement where winlostdate = '2019-10-25'
delete from rptStatement where winlostdate = '2019-10-26'
delete from rptStatement where winlostdate = '2019-10-27'
delete from rptStatement where winlostdate = '2019-10-28'
delete from rptStatement where winlostdate = '2019-10-29'
delete from rptStatement where winlostdate = '2019-10-30'
delete from rptStatement where winlostdate = '2019-10-31'

--==import data again
insert into rptStatement (WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance) 
select WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance 
from rptStatement_Old where winlostdate = '2019-10-25'
insert into rptStatement (WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance) 
select WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance 
from rptStatement_Old where winlostdate = '2019-10-26'

insert into rptStatement (WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance) 
select WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance 
from rptStatement_Old where winlostdate = '2019-10-27'
insert into rptStatement (WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance) 
select WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance 
from rptStatement_Old where winlostdate = '2019-10-28'
insert into rptStatement (WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance) 
select WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance 
from rptStatement_Old where winlostdate = '2019-10-29'
insert into rptStatement (WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance) 
select WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance 
from rptStatement_Old where winlostdate = '2019-10-30'
insert into rptStatement (WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance) 
select WinlostDate, Custid, OpeningBalance, VoidAmt, Turnover, NetTurnover, TransferAmt, Winlost, Comm, ClosingBalance, GrandPrize, OpeningTotalBalance 
from rptStatement_Old where winlostdate = '2019-10-31'

--==correct data
DECLARE @winlostdate		SMALLDATETIME
				,@dateFrom		SMALLDATETIME
				,@dateTo	SMALLDATETIME
		
SELECT @dateFrom = '2019-11-01', @dateTo = '2019-11-03 00:00:00.000'

SELECT @winlostdate = @dateFrom
		
WHILE(@winlostdate <= @dateTo)
BEGIN
	EXEC [dbo].[Task_DailyRptStatement_CheckData] @winlostdate = @winlostdate, @isCheckDataOnly = 0
			
	SELECT @winlostdate = DATEADD(DD, 1, @winlostdate)
END