Use CUSTDB
GO 
/*
Create : 20200331@Sophia 
Task: VendorGlobalSetting of GT  [redmineID: #130684]
DB: DBCUST.CUSTDB
*/


INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 46, '3rdCashWLShareRate',0.04,242,3201
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 46, '3rdCreditWLShareRate',0.05,242,3201
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 46, '3rdCreditRebateRate',0.01,242,3201

 