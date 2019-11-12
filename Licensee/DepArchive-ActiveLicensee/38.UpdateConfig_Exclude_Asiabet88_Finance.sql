/*
	Task: Update config to exlude finance accounts of asiabet88 from Archive Process - Support #109528
	Creator: Dominic@20190312
	Run at: DBCUST.CustDB

*/
USE [CustDB]

--Update current active configs to disabled
UPDATE Dep_Customer_Archived_Config
SET Status=1 --Disabled
WHERE Recommend IN (
	1376070,
	1376088,
	1376076,
	1376080,
	1376073,
	1376067,
	6541634
)
