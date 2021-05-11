/*<info serverAlias="DBCUST-CustDB" step="1"></info>*/
use bodb_Licensee
GO 

/*
Create : 20210510@Sophia
Task: Add VendorGlobalSetting 1909, 1910 [redmine: 152960]
DB: DBCUST/CustDB
*/


INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCashWLShareRateBA',0.035,165,1909
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCreditWLShareRateBA',0.035,165,1909
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCashWLShareRateLD',0.035,165,1910
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCreditWLShareRateLD',0.035,165,1910

 