/*<info serverAlias="DBCUST-CUSTDB" step="3"></info>*/
use CUSTDB
GO 

/*
Create : 20210408@Sophia
Task: Add  Creative gaming [redmine :#146016]
DB: DBCUST/CUSTDB
*/

INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 62, '3rdCashWLShareRate',0.03,167,7301
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 62, '3rdCreditWLShareRate',0.03,167,7301
 