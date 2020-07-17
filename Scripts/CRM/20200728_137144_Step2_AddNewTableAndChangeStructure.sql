/*<info serverAlias="DBCRM-bodb_CRM"></info>*/

USE bodb_CRM
GO

/*
	Created: 20200717@Malcolm
	DB: DBCRM.bodb_CRM
	Task: add new tables and change structure
	Revisions:
		- 20200717@Malcolm:  add new tables and change structure [RedmineID: #137144]
*/

-- Create new users
CREATE USER [bodbExtAccNet] FOR LOGIN [bodbExtAccNet] WITH DEFAULT_SCHEMA=[dbo]

-- Add new columns

ALTER TABLE dbo.crmUserLog_RunSP
ADD CustID INT
GO

ALTER TABLE dbo.crmLogAction
ADD ActionTypeID INT
GO

ALTER TABLE dbo.crmPICManagement
ADD HeadlineID INT
GO
-- Change data type of old columns
ALTER TABLE dbo.crmUserLog_RunSP
ALTER COLUMN NewValues NVARCHAR(MAX)
GO

ALTER TABLE dbo.crmUserLog_RunSP
ALTER COLUMN OldValues NVARCHAR(MAX)
GO
-- Create new tables
CREATE TABLE dbo.crmPICDefault
(
	HeadlineID INT NOT NULL,
	PicID      INT NOT NULL,
	CONSTRAINT [PK_CRM_PICDefault] PRIMARY KEY CLUSTERED 
	(
		HeadlineID ASC,
		PicID ASC
	) ON DATA
) ON DATA
GO

CREATE TABLE dbo.crmLogActionType
(
	ActionTypeID	INT,
	ActionTypeName	NVARCHAR(100),
	CONSTRAINT PK_crmLogActionType PRIMARY KEY CLUSTERED
	(
		ActionTypeID ASC
	) ON [userlog]
) ON [userlog]
GO