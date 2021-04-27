/*<info serverAlias="DBCUST-CUSTDB"></info>*/
use CUSTDB
GO 

/*
Create : 20201225@Sophia
Task: Add BG Product3rd [redmine :#142459]
DB: DBCUST/CUSTDB
*/


INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 57, '3rdCashWLShareRate',0.04,239,3501
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 57, '3rdCreditWLShareRate',0.04,239,3501