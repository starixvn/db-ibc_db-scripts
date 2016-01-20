use custdb
go
/*
	this script copy data for CustWinlimit of ONE-RnG
	backup this data on DBCust
*/

if object_id('CustUnSyncedCasinoTmp', 'u') is null
begin
	select 'Table named CustUnSyncedCasinoTmp does not exist'
	return
end

-- 1. get maxcustid (should check on CustLossLimitTmp to see if it exceed in this table)
select MAX(custid) from custInfo witH(nolock)

-- 2. copy data for member unsync casino
select custid into CustUnSyncedCasinoTmp
--select count(1)
from dbo.custInfo with(nolock) where custid <= @maxcustID and SyncCasino = 0


go
