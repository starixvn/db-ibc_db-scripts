/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20240814@Lewis
	DB: DBCUST-CustDB
	Task:  Add new column IsDisabled on Acc_DWLList, Acc_DWLList_xtest tables [RedmineId:  #209319]
*/

USE CustDB
GO

-- ADD IsDisabled
ALTER TABLE Acc_DWLList
ADD [IsDisabled] [bit] NULL CONSTRAINT [DF_Acc_DWLList_IsDisabled]  DEFAULT (0)
GO

ALTER TABLE Acc_DWLList_xtest 
ADD [IsDisabled] [bit] NULL CONSTRAINT [DF_Acc_DWLList_xtest_IsDisabled]  DEFAULT (0)
GO


-- UPDATE IsDisabled
UPDATE a WITH (ROWLOCK,UPDLOCK) SET a.IsDisabled = a.IsDeleted , a.RepUpdateTime = SYSDATETIME()
FROM dbo.Acc_DWLList a 

UPDATE a WITH (ROWLOCK,UPDLOCK) SET a.IsDisabled = a.IsDeleted , a.RepUpdateTime = SYSDATETIME()
FROM dbo.Acc_DWLList_xtest a 
