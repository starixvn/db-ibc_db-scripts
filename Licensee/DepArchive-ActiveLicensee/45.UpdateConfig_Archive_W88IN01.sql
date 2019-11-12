/*
	Task: Update config to archive W88IN01 - Support #109528
	Creator: Dominic@20190318
	Run at: DBCUST.CustDB

*/
USE [CustDB]

--Update current active config to 'Pending'
UPDATE Dep_Customer_Archived_Config
SET Status=2 --Pending
WHERE Status=0 --Active

--Archive W88IN01
UPDATE Dep_Customer_Archived_Config
SET Status=0 --Active
WHERE Recommend = 10580778
