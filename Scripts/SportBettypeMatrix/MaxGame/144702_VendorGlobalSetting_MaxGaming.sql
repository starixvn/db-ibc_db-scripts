/*<info serverAlias="DBCUST-CUSTDB"></info>*/
use CUSTDB
GO 

/*
Create : 20201225@Sophia
Task: Add MaxGaming VendorGlobalSetting [redmine :#144702]
DB: DBCUST/CUSTDB
*/


INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 60, '3rdCreditWLShareRate',0.03,237,5401 