
use CUSTDB
GO 

/*
Create : 20200505@Sophia
Task: Add ION Live Casino Product3rd [redmine :#132323]
DB: DBCUST/CUSTDB
*/

INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 50, '3rdCreditWLShareRateION',0.05,225,5601

 