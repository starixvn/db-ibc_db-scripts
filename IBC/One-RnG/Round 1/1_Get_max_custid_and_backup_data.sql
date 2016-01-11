use custdb
go
/*
	this script copy data for CustWinlimit of ONE-RnG
*/

if object_id('CustUnSyncedCasinoTmp', 'u') is null
begin
	select 'Table named CustUnSyncedCasinoTmp does not exist'
	return
end

declare @MaxCustId int
select @MaxCustId = max(custid) 
from dbo.Customer with(nolock) where roleid <= 4

--copy data for member unsync casino
insert into dbo.CustUnSyncedCasinoTmp(custid)
select custid from dbo.custInfo with(nolock) where custid <= @MaxCustId and SyncCasino = 0

select @MaxCustId as '@MaxCustId'
