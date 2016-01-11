
use custdb
go
/*
	this script copy data for CustWinlimit of ONE-RnG
*/

--drop table dbo.CustUnSyncedCasinoTmp
--drop table dbo.CheckGDWinLimit

go
create table dbo.CustUnSyncedCasinoTmp (custid int)

create table dbo.CheckGDWinLimit (custid int, maxWinLimitA smallmoney, isAutoResetA bit, maxLossLimitA money
, custidB int, maxWinLimitB smallmoney, isAutoResetB bit, maxLossLimitB money
, roleid tinyint)

go
