USE CUSTDB
GO 
/*
Create : 20200422@Sophia
Task: VendorGlobalSetting - 3D Lottery - Cardclub 1905 and 1904 [Redmine :#133593, #132254] 
DB: DBCUST.CUSTDB
*/

INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCashWLShareRate3D',0.035,165,1904
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCreditWLShareRate3D',0.035,165,1904

INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCashWLShareRateHL',0.035,165,1905
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCreditWLShareRateHL',0.035,165,1905 


