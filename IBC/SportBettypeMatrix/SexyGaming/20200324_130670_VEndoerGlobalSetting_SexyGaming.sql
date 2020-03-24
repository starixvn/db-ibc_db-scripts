USE CUSTDB
GO 
/*
Create: 20200323@Sophia
Task: VendorGlobalSetting for sexy gaming [Redmine: #130670]
DB: DBCUST.CUSTDB
*/


INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 45, '3rdCreditWLShareRate',0.03,243,'3101'