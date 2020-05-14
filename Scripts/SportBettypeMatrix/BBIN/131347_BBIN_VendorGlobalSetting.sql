use CUSTDB
GO 

/*
Create 20200409@Sophia
DB: DBCUST.CUSTDB
Task VendorGlobalSetting for BBIN [redmine: #131347]
*/
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )  
 select 47, '3rdCreditWLShareRate',0.04,241,3300