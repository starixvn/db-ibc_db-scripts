/*<info serverAlias="DBCUST-CUSTDB" step="3"></info>*/
use CUSTDB
GO 

/*
Create : 20200914@Sophia
Task: Add Poker Product3rd [redmine :#131575]
DB: DBCUST/CUSTDB
*/

INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 56, '3rdCashWLShareRate',0.03,234,6401
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 56, '3rdCreditWLShareRate',0.03,234,6401