/*
	Task: Update current active config to 'Pending' - Support #109528
	Creator: Dominic@20190318
	Run at: DBCUST.CustDB

*/
USE [CustDB]

UPDATE Dep_Customer_Archived_Config
SET Status=2 --Pending
WHERE Status=0 --Active
