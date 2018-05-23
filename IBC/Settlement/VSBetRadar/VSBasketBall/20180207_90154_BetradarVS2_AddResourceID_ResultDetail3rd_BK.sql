/*
	Created: 20180223@Sophia
	Task: Add column ResourceID in table ResultDetail3rd_BK [Redmine:90154]
	DB: DBARC/bodb_Archive 
*/
USE bodb_Archive
GO
ALTER TABLE dbo.ResultDetail3rd_BK ADD ResourceId VARCHAR(20) 
GO 