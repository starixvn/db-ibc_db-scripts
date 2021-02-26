/*<info serverAlias="DBCUST-CUSTDB"></info>*/
use CUSTDB
GO 

/*
Create :  20210226@Sophia
Task: Add VendorGlobalSetting Habanero [redmine :#145456] 
DB: DBCUST/CUSTDB
*/

INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 61, '3rdCashWLShareRate',0.05,238,7001
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 61, '3rdCreditWLShareRate',0.05,238,7001
