/*<info serverAlias="DBN88POL-N88_UserControl"></info>*/
/*	
	Created: 20230111@Kai
	Task: Abnormal Bet Report - [Redmine:#174308]
	DB: DBN88POL/N88_UserControl
*/

USE [N88_UserControl]
GO

CREATE TABLE [dbo].[N88_Message] (
	[MessageID]		INT	IDENTITY(1,1)	NOT NULL
	,[MessageType]	TINYINT				NOT NULL
	,[SubjectEn]	NVARCHAR(300)		NOT NULL
	,[SubjectCs]	NVARCHAR(300)		NULL
	,[ContentEn]	NVARCHAR(MAX)		NULL
	,[ContentCs]	NVARCHAR(MAX)		NULL
	,[EventDate]	DATETIME			NOT NULL
	,[CreatedDate]	DATETIME			NOT NULL
	,CONSTRAINT [PK_N88_Message] PRIMARY KEY CLUSTERED (
		[MessageID] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

CREATE TABLE [dbo].[N88_MessageUser] (
	[MessageID]		INT				NOT NULL
	,[UserName]		NVARCHAR(50)	NOT NULL
	,[LicenseeName]	VARCHAR(50)		NOT NULL
	,[IsRead]		BIT				NOT NULL
	,[UpdatedDate]	DATETIME		NOT NULL
	,CONSTRAINT [PK_N88_MessageUser] PRIMARY KEY CLUSTERED (
		[MessageID] ASC
		,[UserName] ASC
		,[LicenseeName] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

CREATE TABLE [dbo].[N88_MessageLicensee] (
	[MessageID]		INT				NOT NULL
	,[LicenseeName]	VARCHAR(50)		NOT NULL
	,CONSTRAINT [PK_N88_MessageLicensee] PRIMARY KEY CLUSTERED (
		[MessageID] ASC
		,[LicenseeName] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [NAP_UserControl_table]
) ON [NAP_UserControl_table]

GO

