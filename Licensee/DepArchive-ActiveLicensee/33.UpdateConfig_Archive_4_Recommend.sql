/*
	Task: Update config to archive members of 4 recommendID : 3752259,14373731,14616559,15617041 - Support #109528
	Creator: Dominic@20190306
	Run at: DBCUST.CustDB

*/
USE [CustDB]

--Update current active configs to pending
UPDATE Dep_Customer_Archived_Config
SET Status=2 --Pending
WHERE Recommend IN (6630793,4688811,3417162,2748014,13682919,14442436)

--Update config to archive members of 4 recommendID
UPDATE Dep_Customer_Archived_Config
SET Status=0 --Active
WHERE Recommend IN (3752259,14373731,14616559,15617041)

