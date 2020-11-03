/*<info serverAlias="DBCUST-CUSTDB" step="3"></info>*/
use CUSTDB
GO 

/*
Create : 20200914@Sophia
Task: Add WM Product3rd [redmine :#131555]
DB: DBCUST/CUSTDB
*/
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 51, '3rdCashWLShareRate',0.04,233,3401
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 51, '3rdCreditWLShareRate',0.04,233,3401