/*<info serverAlias="DBCUST-CUSTDB,DBTXN-CUSTDB"></info>*/

USE [CustDB]
GO

/*
Create : 20200730@Sophia
Task: UMConfig for Transfer [Redmine: #136992]
DB : DBCUST.CUSTDB
*/

update UMConfig_UAT 
SET BeginTime = '2020-09-29 03:00:00',
EndTime ='2020-09-29 6:00:00'
WHERE SuperID  = 23003140 
AND FunctionType = 101  


update UMConfig_UAT 
SET BeginTime = '2020-09-29 05:00:00',
EndTime ='2020-10-02 08:00:00'
WHERE SuperID  = 0 
AND FunctionType = 101    

SELECT * FROM UMConfig_UAT  Where FunctionType = 101 
GO

  