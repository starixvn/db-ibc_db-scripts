/*
	Task: Update config to archive members of asiabet88, TLC - Support #109528
	Creator: Dominic@20190312
	Run at: DBCUST.CustDB

*/
USE [CustDB]

--Update current active configs to pending
UPDATE Dep_Customer_Archived_Config
SET Status=2 --Pending
WHERE status=0 --Active

--Update config to archive members of asiabet88, TLC
UPDATE Dep_Customer_Archived_Config
SET Status=0 --Active
WHERE Site IN ('asiabet88','TLC')
