USE BODB_ACC
GO 
/*
Create : 20200325@Sophia
Task: Insert dummy acctest for ExtraPT [redmine: #130372]
DB: DBACC.bodb_Acc
*/


INSERT INTO  [dbo].[Acc_DWLList_ExtraPT] (CustID, GroupId, GroupName, IsDisabled)
VALUES (42407242, 67, 'ACCTEST', 0)
