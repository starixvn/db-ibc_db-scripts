/*
	Task: Update configs to enable Archive Process for e8casino and GPIGAME - Support #107171
	Creator: Dominic@2190111
	Run at: CustDB@DBCUST
*/
USE CustDB
GO


--Skip e8casino: 1 affected row
UPDATE Dep_Customer_Archived_Config WITH(ROWLOCK)
Set Status = 0 --To run 
WHERE site = 'e8casino'

--Archvie GPIGAME : 4 affected rows
UPDATE Dep_Customer_Archived_Config WITH(ROWLOCK)
Set Status = 0 --To run 
WHERE site = 'GPIGAME'
