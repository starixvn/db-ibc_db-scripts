/*<info serverAlias="DBCUST-CUSTDB"></info>*/

/*
Create: 20200729@Sophia
Task: Add column Is Transferring into Acc_ClearBalanceList [Redmine: #137141]
DB: DBCUST-CUSTDB

*/

USE CUSTDB
GO 

GRANT SELECT ON Acc_ClearBalanceList TO  bodbAdminNet 
GO

GRANT SELECT ON Acc_ClearBalanceList TO  bodbDownlineNet 


GRANT SELECT ON Acc_ClearBalanceList TO  bodbDownlineNetView 


GRANT SELECT ON Acc_ClearBalanceList TO  bodbExtAccNet  