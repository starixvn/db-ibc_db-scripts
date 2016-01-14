
use custdb
go
/*
	this script copy data for CustWinlimit of ONE-RnG
	run on dbcust
*/

--drop table dbo.CustUnSyncedCasinoTmp
--drop table dbo.CheckRnGWinLimit

go
create table dbo.CustUnSyncedCasinoTmp (custid int)

create table dbo.CheckRnGWinLimit (custid int, maxWinLimitA smallmoney, isAutoResetA bit, maxLossLimitA money
, custidB int, maxWinLimitB smallmoney, isAutoResetB bit, maxLossLimitB money
, roleid tinyint, isfinished bit default(0))

go
