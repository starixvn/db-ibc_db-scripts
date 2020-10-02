/*<info serverAlias="DBCUST-CUSTDB"></info>*/

USE [CustDB]
GO
  
/*
Create : 202001001@Sophia
Task: Update data test for QC: Acc_ClearBalanceList [Redmine: #136992]
DB : DBCUST.CUSTDB
*/ 
 
 delete UMConfig_UAT where FunctionType = 101