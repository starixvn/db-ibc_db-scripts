/*<info serverAlias="DBCUST-CUSTDB" step="3"></info>*/
use CUSTDB
GO 

/*
Create : 20210311@Sophia
Task: Add PPLive casino  [redmine :#133717]
DB: DBCUST/CUSTDB
*/

INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 65, '3rdCreditWLShareRate',0.06,170,3701
 