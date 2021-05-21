/*<info serverAlias="DBCUST-CustDB" step="1"></info>*/
use CustDB
GO 

/*
Create : 20210521@Sophia
Task: Add VendorGlobalSetting 1911 [redmine: 152960]
DB: DBCUST/CustDB
*/


INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCashWLShareRateGO',0.035,165,1911
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 33, '3rdCreditWLShareRateGO',0.035,165,1911