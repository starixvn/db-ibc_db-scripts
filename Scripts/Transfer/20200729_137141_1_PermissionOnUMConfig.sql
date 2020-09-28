/*<info serverAlias="DBTXN-CUSTDB"></info>*/

/*
Create: 20200729@Sophia
Task: Add column Is Transferring into UMConfig [Redmine: #137141]
DB: DBTXN-CUSTDB

*/

USE CUSTDB
GO 

GRANT SELECT ON UMConfig TO  bodbAdminNet 
GO

GRANT SELECT ON UMConfig TO  bodbDownlineNet 

GO

GRANT SELECT ON UMConfig TO  bodbDownlineNetView 
GO

GRANT SELECT ON UMConfig_UAT TO  bodbAdminNet 
GO

GRANT SELECT ON UMConfig_UAT TO  bodbDownlineNet 

GO
GRANT SELECT ON UMConfig_UAT TO  bodbDownlineNetView 
