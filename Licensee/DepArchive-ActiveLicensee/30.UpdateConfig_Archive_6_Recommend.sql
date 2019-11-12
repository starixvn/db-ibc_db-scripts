/*
	Task: Update config to archive members of 6 recommendID first: 6630793,4688811,3417162,2748014,13682919,14442436 - Support #109528
	Creator: Dominic@20190304
	Run at: DBCUST.CustDB

*/
USE [CustDB]

UPDATE Dep_Customer_Archived_Config
SET Status=2 --Pending
WHERE Status=0 --Active
AND Recommend NOT IN (6630793,4688811,3417162,2748014,13682919,14442436)

