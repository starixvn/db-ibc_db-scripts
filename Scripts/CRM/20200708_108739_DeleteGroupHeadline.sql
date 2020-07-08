/*<info serverAlias="DBCUST-CustDB"></info>*/

USE [CustDB]
GO

/*
	Created: 20200708@Malcolm
	DB: DBCUST.CustDB
	Task: delete all headlines having groupid = 0
	Redmine: #108739 
*/

DELETE 
FROM CustGroupHeadline
WHERE GroupID = 0