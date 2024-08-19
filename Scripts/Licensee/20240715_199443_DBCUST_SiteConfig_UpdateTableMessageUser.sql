/*<info serverAlias="DBCUST-SiteConfig"></info>*/
/*
	Created: 20240715@Kai
	DB: DBCUST-SiteConfig
	Task: LAP - Add Source column to table MessageUser
	RedmineID: #199443 - LAP - Enhance Result Amendment
*/

USE SiteConfig
GO

ALTER TABLE [dbo].[MessageUser]
ADD [Source] TINYINT CONSTRAINT [Default_Source] DEFAULT (0) NOT NULL
GO

ALTER TABLE [dbo].[MessageUser] DROP CONSTRAINT [PK_MessageUser]
GO
 
ALTER TABLE [dbo].[MessageUser] ADD CONSTRAINT [PK_MessageUser] PRIMARY KEY CLUSTERED (
	[MessageID] ASC
	,[Source] ASC
	,[LicenseeName] ASC
	,[UserName] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [LIC_Data]
GO