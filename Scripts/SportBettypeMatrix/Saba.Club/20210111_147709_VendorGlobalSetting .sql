/*<info serverAlias="DBCUST-CUSTDB"></info>*/
/*
	Create : 20200111@Sol
	Task: update VendorGlobalSetting for Saba.club- [Redmine :#147709]
	DB: DBCUST/CUSTDB
*/

USE CUSTDB

GO 

INSERT INTO VendorGlobalSetting (VendorID, VName, NumberValue, Sporttype, Bettype )   
VALUES 
	(42, 'Dep_Contribution_PT_agent', 1, NULL, NULL),
	(42, 'Dep_Contribution_PT_master', 0, NULL, NULL),
	(42, 'Dep_Contribution_PT_super', 0, NULL, NULL)
	
GO