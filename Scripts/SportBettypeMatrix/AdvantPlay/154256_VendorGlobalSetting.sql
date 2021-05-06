/*<info serverAlias="DBCUST-CUSTDB" step="3"></info>*/
use CUSTDB
GO 

/*
Create : 20210506@Sophia
Task: Add AdvantPlay [redmine :#154256]
DB: DBCUST/CUSTDB
*/


INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 67, '3rdCashWLShareRate',0.05,172,7701
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 67, '3rdCreditWLShareRate',0.05,172,7701