/*<info serverAlias="DBCUST-CUSTDB,DBTXN-CUSTDB"></info>*/

USE [CustDB]
GO

/*
Create : 20200730@Sophia
Task: UMConfig_UAT - for Transfer [Redmine: #136992]
DB : DBCUST.CUSTDB
*/

 DELETE UMCOnfig_UAT WHERE FunctionType = 101 and SuperID = 23003140 

 UPDATE UMCOnfig_UAT 
 SET SiteID = 0
 , Currency = 20
 , BeginTime = '2020-09-30 1:00:00'
 , EndTime = '2020-10-02 15:00:00'
 WHERE FunctionType = 101 and SuperID = 0 

SELECT * FROM UMConfig_UAT  Where FunctionType = 101 
GO

  