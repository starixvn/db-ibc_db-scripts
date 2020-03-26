USE CUSTDB

/*
Create : 20200326@Sophia
Task: SportType/ Bettype local test Table Games [redmine :#126666]
DB: DBCUST.CUSTDB

*/



INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 40, '3rdCashWLShareRate',0.03,222,4901
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 40, '3rdCreditWLShareRate',0.03,222,4901
