/*
    Created: 20200102@Malcolm
	Task: Separate setting and notification into Live/Non-Live and bettypes - [Redmine: #126348]
	DB: DBCUST/CustDB
*/
USE CustDB
GO

ALTER TABLE [dbo].[TOControl_Setting] DROP CONSTRAINT  [PK_TOControl_Setting]
GO

ALTER TABLE [dbo].[TOControl_Setting]  ADD liveindicator  BIT NOT NULL, bettypeID SMALLINT NOT  NULL
GO

ALTER TABLE [dbo].[TOControl_Setting] ADD CONSTRAINT [PK_TOControl_Setting] PRIMARY KEY ([CustID],[matchid],[IsGroupHeadLine],[liveindicator],[bettypeID]) 
GO

ALTER TABLE [dbo].[TOControl_GlobalSetting] DROP CONSTRAINT  [PK_TO_ControlglobalSetting]
GO

ALTER TABLE [dbo].[TOControl_GlobalSetting]  ADD liveindicator  BIT NOT NULL, bettypeID SMALLINT NOT NULL
GO

ALTER TABLE [dbo].[TOControl_GlobalSetting] ADD CONSTRAINT [PK_TO_ControlglobalSetting] PRIMARY KEY ([CustID],[Sporttype],[IsGroupHeadLine],[liveindicator],[bettypeID]) 
GO