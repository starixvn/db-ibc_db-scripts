/*
	Created: Vicky
	Task: turn off auto increase for table DBA_Rules
	DB: DBACC/bodb_Consistency
	Date: 20181219
*/
USE [bodb_Consistency]
GO

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_DBA_Rules
	(
	RuleId int NOT NULL,
	Name nvarchar(128) NULL,
	Description nvarchar(MAX) NULL,
	SeverityLevel varchar(20) NULL
	)  ON bodb_Consistency_INDEX
	 TEXTIMAGE_ON bodb_Consistency_DATA
GO
ALTER TABLE dbo.Tmp_DBA_Rules SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.DBA_Rules)
	 EXEC('INSERT INTO dbo.Tmp_DBA_Rules (RuleId, Name, Description, SeverityLevel)
		SELECT RuleId, Name, Description, SeverityLevel FROM dbo.DBA_Rules WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.DBA_Rules
GO
EXECUTE sp_rename N'dbo.Tmp_DBA_Rules', N'DBA_Rules', 'OBJECT' 
GO
ALTER TABLE dbo.DBA_Rules ADD CONSTRAINT
	PK_DBA_Rules_RuleId PRIMARY KEY CLUSTERED 
	(
	RuleId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON bodb_Consistency_INDEX

GO
COMMIT
