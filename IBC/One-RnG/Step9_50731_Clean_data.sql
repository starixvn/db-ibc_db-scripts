use custdb
go
/*
	this script copy data for CustWinlimit of ONE-RnG
*/
-- BEGIN STEP 1: Run ON @DBCUST.CUSTDB------------------------
------------------------------------------------------

drop table dbo.CustUnSyncedCasinoTmp
drop table dbo.CustLossLimitTmp
drop table dbo.CheckRnGWinLimitTmp

go

-- END STEP 1: Run ON @DBCUST.CUSTDB------------------------
------------------------------------------------------

-- BEGIN STEP 2: Run ON @DBCASINO.CasinoAdmin------------------------
------------------------------------------------------

drop table dbo.CustLossLimitTmp

go

-- END STEP 3: Run ON @DBCASINO.CasinoAdmin------------------------
------------------------------------------------------

-- BEGIN STEP 3: Run ON @REPLICATED SERVER --> DB06/DBTP
------------------------------------------------------

drop table dbo.CustLossLimitTmp

go

-- END STEP 3: Run ON @REPLICATED SERVER --> DB06/DBTP
------------------------------------------------------