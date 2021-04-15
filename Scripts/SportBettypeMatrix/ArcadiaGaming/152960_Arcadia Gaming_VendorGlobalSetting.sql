/*<info serverAlias="DBCUST-CustDB" step="1"></info>*/
use bodb_Licensee
GO 

/*
Create : 20210413@Sophia
Task: Add VendorGlobalSetting [redmine: 152960]
DB: DBCUST/CustDB
*/



INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCashWLShareRateMM',0.035,165,1907
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCreditWLShareRateMM',0.035,165,1907
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCashWLShareRateRPS',0.035,165,1908
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCreditWLShareRateRPS',0.035,165,1908

