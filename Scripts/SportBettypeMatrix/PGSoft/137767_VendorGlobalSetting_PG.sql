/*<info serverAlias="DBCUST-CUSTDB" step="1"></info>*/
use CUSTDB
GO 

/*
Create : 20200808@Sophia
Task: Add PG Soft VendorGlobalSetting [redmine :#137767]
DB: DBCUST/CUSTDB
*/


INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 55, '3rdCashWLShareRate',0.04,232,6001
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 55, '3rdCreditWLShareRate',0.04,232,6001