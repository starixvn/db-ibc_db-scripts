/*
	Task: Update configs to archive members of DEWA only - Support #107170
	Creator: Dominic@20190107
	Run at: CustDB@DBCUST
*/
USE CustDB
GO


--Skip e8casino: 1 affected row
UPDATE Dep_Customer_Archived_Config WITH(ROWLOCK)
Set Status = 1 --To skip 
WHERE site = 'e8casino'

--Archvie DEWA : 4 affected rows
UPDATE Dep_Customer_Archived_Config WITH(ROWLOCK)
Set Status = 0 --To run 
WHERE site = 'DEWA'
