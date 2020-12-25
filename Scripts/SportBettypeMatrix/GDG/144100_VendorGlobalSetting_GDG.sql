/*<info serverAlias="DBCUST-CUSTDB"></info>*/
use CUSTDB
GO 

/*
Create : 20201202@Sophia
Task: Add GDG Product3rd [redmine :#144100]
DB: DBCUST/CUSTDB
*/

INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 59, '3rdCashWLShareRate',0.05,236,5701
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 59, '3rdCreditWLShareRate',0.035,236,5701