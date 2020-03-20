USE CUSTDB
GO

/*
Create : 20200320@Sophia
Task: Update FromDate for extraPT of VirtualGames [redmine: #130807]
DB: DBCUST.CUSTDB

*/

UPDATE Acc_GroupExtraPT_Product 
SET FromDate = '2020-03-19'
WHERE GROUPNAME IN ('ACCYEN789','ACCYEN889','ACCUT')
AND ProductID = 38
 

 
UPDATE Acc_GroupExtraPTSetting 
SET FromDate = '2020-03-19'
WHERE GROUPNAME IN ('ACCYEN789','ACCYEN889','ACCUT')
AND ProductID = 38
 