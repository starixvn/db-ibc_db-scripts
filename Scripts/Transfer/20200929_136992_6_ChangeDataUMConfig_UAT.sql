/*<info serverAlias="DBCUST-CUSTDB"></info>*/

USE [CustDB]
GO
  
/*
Create : 202001001@Sophia
Task: Update data test for QC: Acc_ClearBalanceList [Redmine: #136992]
DB : DBCUST.CUSTDB
*/ 
 
UPDATE Acc_ClearBalanceList 
SET isTransferring = 1 
WHERE custID IN (27994283,
43212912,
44091846)