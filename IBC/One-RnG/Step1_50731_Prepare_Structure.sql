
use custdb
go
/*
	this script copy data for CustWinlimit of ONE-RnG
	run on dbcust
*/
/*
	drop table dbo.CustUnSyncedCasinoTmp
	drop table dbo.CustLossLimitTmp
	drop table dbo.CheckRnGWinLimitTmp
*/
go
-- BEGIN STEP 1: Run On @DBCUST.CustDB ---------------
------------------------------------------------------
create table dbo.CustUnSyncedCasinoTmp (custid int) --on [DATA]

create table dbo.CustLossLimitTmp (CustId int primary key, IsAutoReset bit, MaxLossLimit money) --on [DATA]

create table dbo.CheckRnGWinLimitTmp (custid int, maxWinLimitA smallmoney, isAutoResetA bit, maxLossLimitA money
, custidB int, maxWinLimitB smallmoney, isAutoResetB bit, maxLossLimitB money
, roleid tinyint, isfinished bit default(0)) --on [DATA]

go
-- BEGIN STEP 1: Run On @DBCUST.CustDB ---------------
------------------------------------------------------

-- BEGIN STEP 2: Run On @REPLICATED SERVER --@DB06/DBTP-----------
------------------------------------------------------
create table dbo.CustLossLimitTmp (CustId int primary key, IsAutoReset bit, MaxLossLimit money)
-- END STEP 2: Run On @REPLICATED SERVER -----------
------------------------------------------------------