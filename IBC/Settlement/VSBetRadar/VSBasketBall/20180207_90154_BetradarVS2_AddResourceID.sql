/*
	Created: 20180207@Helen
	Task: Add column ResourceID in table ResultDetail3rd, ResultDetail3rd14 - [Redmine:90154]
	DB: DBPRO/bodb02 
*/
USE bodb02
GO
ALTER TABLE dbo.ResultDetail3rd ADD ResourceId VARCHAR(20) 
GO
ALTER TABLE dbo.ResultDetail3rd14 ADD ResourceId VARCHAR(20) 
GO