USE CUSTDB
GO 

/*
Create: 20200311@Sophia
Task: Create ExtraPT group for CN88_01.. CN88_55 - Delete data test of QC [Redmind: 130297]
DB: DBCUST.CustDB

*/
DELETE Acc_GroupExtraPTSetting WITH (NOLOCK)  Where GroupName LIKE  'TERRA_Test%' 