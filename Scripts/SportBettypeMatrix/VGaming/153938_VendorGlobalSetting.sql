/*<info serverAlias="DBCUST-CUSTDB" step="3"></info>*/
use CUSTDB
GO 

/*
Create : 20210428@Sophia
Task: Add  VGaming [redmine :#153938]
DB: DBCUST/CUSTDB
*/

INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 66, 'Dep_Contribution_PT_agent',1,NULL,NULL
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 66, 'Dep_Contribution_PT_master',0,NULL,NULL
INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   select 66, 'Dep_Contribution_PT_super',0,NULL,NULL