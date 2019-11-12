/*
	Task: Update config to archive HAIFARMB01 - Support #111652
	Creator: Dominic@20190422
	Run at: DBCUST.CustDB

*/
USE [CustDB]

--Update current active config to 'Pending'
UPDATE Dep_Customer_Archived_Config
SET Status=2 --Pending
WHERE Status=0 --Active

--Archive HAIFARMB01
UPDATE Dep_Customer_Archived_Config
SET Status=0 --Active
WHERE Recommend = 4359308
