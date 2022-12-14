/*<info serverAlias="DBCUST-SiteConfig"></info>*/

/*
	Created: 20221214@kai
	DB: DBCUST/SiteConfig
	Task: Abnormal Bet Report
	https://nexdev.net/issues/174308
*/

USE [SiteConfig]
GO
	
CREATE TABLE [dbo].[Message] (
	[MessageID]		INT	IDENTITY(1,1)	NOT NULL
	,[MessageType]	TINYINT				NOT NULL
	,[SubjectEn]	NVARCHAR(300)		NOT NULL
	,[SubjectCs]	NVARCHAR(300)		NULL
	,[ContentEn]	NVARCHAR(MAX)		NULL
	,[ContentCs]	NVARCHAR(MAX)		NULL
	,[EventDate]	DATETIME			NOT NULL
	,[CreatedDate]	DATETIME			NOT NULL
	,CONSTRAINT [PK_Message] PRIMARY KEY CLUSTERED (
		[MessageID] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [LIC_Data]
) ON [LIC_Data]

GO

CREATE TABLE [dbo].[MessageUser] (
	[MessageID]		INT				NOT NULL
	,[UserName]		VARCHAR(20)		NOT NULL
	,[LicenseeName]	VARCHAR(50)		NOT NULL
	,[IsRead]		BIT				NOT NULL
	,[UpdatedDate]	DATETIME		NOT NULL
	,CONSTRAINT [PK_MessageUser] PRIMARY KEY CLUSTERED (
		[MessageID] ASC
		,[UserName] ASC
		,[LicenseeName] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [LIC_Data]
) ON [LIC_Data]

GO

CREATE TABLE [dbo].[MessageLicensee] (
	[MessageID]		INT				NOT NULL
	,[LicenseeName]	VARCHAR(50)		NOT NULL
	,CONSTRAINT [PK_MessageLicensee] PRIMARY KEY CLUSTERED (
		[MessageID] ASC
		,[LicenseeName] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [LIC_Data]
) ON [LIC_Data]

GO