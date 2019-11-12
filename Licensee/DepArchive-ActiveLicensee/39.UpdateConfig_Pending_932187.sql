/*
	Task: Update config to 'Pending' for recommend=932187,932165,932180,932192,932251 - Support #109528
	Creator: Dominic@20190312
	Run at: DBCUST.CustDB

*/
USE [CustDB]

UPDATE Dep_Customer_Archived_Config
SET Status=2 --Pending
WHERE Recommend IN (932187,932165,932180,932192,932251)
