
use CUSTDB
GO 

/*
Create : 20200520@Sophia
Task: Add RNG War Product3rd [redmine :#132001]
DB: DBCUST/CUSTDB
*/

INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 50, '3rdCreditWLShareRate',0.04,224,5500