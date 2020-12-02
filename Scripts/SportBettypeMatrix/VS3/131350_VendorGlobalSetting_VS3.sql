/*<info serverAlias="DBCUST-CUSTDB" step="3"></info>*/
use CUSTDB
GO 

/*
Create : 20201201@Sophia
Task: Add VS3 Product3rd [redmine :#131350]
DB: DBCUST/CUSTDB
*/


INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 49, '3rdCashWLShareRate',0.05,231,5301
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 49, '3rdCreditWLShareRate',0.01,231,5301
