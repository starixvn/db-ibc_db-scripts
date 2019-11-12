/*
	Task: Update config to archive the rest lines of HAIFARMB01 - Support #111652
	Creator: Dominic@20190423
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
WHERE Recommend IN (
	4345531
	,4359430
	,7262800
	,8362823
	,10557009
	,10557029
)
