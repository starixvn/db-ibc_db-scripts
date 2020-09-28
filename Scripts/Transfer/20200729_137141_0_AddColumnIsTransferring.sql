/*<info serverAlias="DBCUST-CUSTDB"></info>*/

/*
Create: 20200729@Sophia
Task: Add column Is Transferring into Acc_ClearBalanceList [Redmine: #137141]
DB: DBCUST-CUSTDB

*/

USE CUSTDB
GO 

ALTER TABLE Acc_ClearBalanceList ADD isTransferring BIT
GO

ALTER TABLE Acc_ClearBalanceList ADD CONSTRAINT DF_Acc_ClearBalanceList_isTransferring  DEFAULT (0) FOR isTransferring
GO
 