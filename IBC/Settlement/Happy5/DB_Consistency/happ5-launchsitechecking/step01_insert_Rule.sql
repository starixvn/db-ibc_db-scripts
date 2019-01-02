/*
	Created: Vicky
	Task: insert Rules for Happy5
	DB: DBTP/bodb_Consistency
	Date: 20181218
*/
USE [bodb_Consistency]
GO



------------------------------------------------------------------------------------------------------------------------------------------------------------
SET IDENTITY_INSERT DBA_Rules ON

INSERT INTO DBA_Rules (RuleId, Name, Description, SeverityLevel)
VALUES
	 --check un-launched sites
	 (17,'Check un-launched sites','Check un-launched sites','High')
	
SET IDENTITY_INSERT DBA_Rules OFF