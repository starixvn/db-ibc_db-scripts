use CasinoAdmin
go
/*
	Task: copy data for CustWinlimit of ONE-RnG
*/
--
-- 0. prepare bodb_lukas to store data from CasinoAdmin
-- 1. import data into table CustLossLimitTmp, remember to check with maxCustID
select cc.IBCCustID as custid , cs.IsAutoReset, isnull(MaxTransferCredit, 0) as MaxTransferCredit
from dbo.Customer cc with(nolock)
 inner join dbo.CustSetting cs with(nolock) on cc.custid = cs.CustSettingID
-- 2. create index 
create unique clustered index CIX_CustLossLimitTmp on CustLossLimitTmp (custid) on data

-- 3. delete deposit customer
DELETE t from CustLossLimitTmp t 
 inner join custInfo ci witH(nolocK) on t.custid = ci.custid 
where exists (select custid from Dep_CustSuper with(nolock) where custid = ci.srecommend)

-- 4. rebuild index
alter index CIX_CustLossLimitTmp on CustLossLimitTmp rebuild 

-- 5. deploy this table to all server: DBCust, DB06, DBTP, DBMNL, DBCust, DB06
go


