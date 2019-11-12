/*
	Task: Update configs to archive members of e8Casino only - Support #107169
	Creator: Dominic@20181228
	Run at: CustDB@DBCUST
*/
USE CustDB
GO


--Update ALL: 244 affected rows
UPDATE Dep_Customer_Archived_Config WITH(ROWLOCK)
Set Status = 1 --To skip 
WHERE site <> 'e8casino'
