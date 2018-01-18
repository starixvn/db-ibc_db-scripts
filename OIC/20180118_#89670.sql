USE [bodb_OIC]
GO

ALTER TABLE dbo.AmendmentMessage ADD EventDate Datetime NOT NULL DEFAULT '2018-01-17';

ALTER TABLE [dbo].[ExternalMessageUser] DROP  CONSTRAINT [PK_ExternalMessageUser];

ALTER TABLE dbo.AmendmentTicket
ALTER COLUMN LicenseeName NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.ExternalMessageUser
ALTER COLUMN LicenseeName NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.ExternalMessageUser
ALTER COLUMN UserName NVARCHAR(50) NOT NULL;

ALTER TABLE [dbo].[ExternalMessageUser] ADD  CONSTRAINT [PK_ExternalMessageUser] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC,
	[MessageType] ASC,
	[UserName] ASC,
	[LicenseeName] ASC
);