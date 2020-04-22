USE CUSTDB
GO 
/*
Create : 20200422@Sophia
Task: VendorGlobalSetting - GT Casino  [redmine: #130684]
DB: DBCUST.CUSTDB
*/


INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 46, '3rdCreditWLShareRate',0.05,242,3201

 