/*<info serverAlias="DBCUST-CUSTDB,DBTXN-CUSTDB"></info>*/

USE [CustDB]
GO

/*
Create : 202001001@Sophia
Task: UMConfig_UAT - for Transfer [Redmine: #136992]
DB : DBCUST.CUSTDB
*/
 

 UPDATE UMCOnfig_UAT 
 SET SiteID = 0
 , Currency = 0
 , BeginTime = '2020-09-30 2:00:00'
 , EndTime = '2020-10-02 10:00:00'
 WHERE FunctionType = 101 and SuperID = 0 

SELECT * FROM UMConfig_UAT  Where FunctionType = 101 
GO


----------------------------

/*
Create : 202001001@Sophia
Task: Acc_ClearBalanceList - for Transfer [Redmine: #136992]
DB : DBCUST.CUSTDB
*/ 


 UPDATE Acc_ClearBalanceList 
 SET isTransferring = 1
 WHERE  custID = 27642991
 
  