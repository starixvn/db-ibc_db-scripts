USE [CustDB]
GO


/*
Create: 20190917@Sophia
Task: Add UplineID - Move Super CN88 [redmine: #118962]
DB: DBUCST.CUSTDB
*/


---tructure
ALTER TABLE [dbo].[Acc_GroupExtraPTSetting] ADD UplineId INT  