USE CUSTDB
GO 
/*
Create: 20200323@Sophia
Task: VendorGlobalSetting for SA Gaming [Redmine: #123946]
DB: DBCUST.CUSTDB
*/

INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 39, '3rdCashWLShareRate',0.06,244,3001
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 39, '3rdCreditWLShareRate',0.045,244,3001
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 39, '3rdCreditRebateRate',0.01,244,3001
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 39, '3rdCashTipShareRate',0.5,244,3007
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 39, 'CashTipShareRate',0.5,244,3007