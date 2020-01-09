
/*
    Created: 20200108@Malcolm
	Task: Separate setting and notification into Live/Non-Live and bettypes - [Redmine: #126348]
	DB: DBCUST/CustDB
*/

USE CustDB
GO
DROP TABLE [TOControl_Profile]
GO
CREATE TABLE [dbo].[TOControl_Profile](
	[ProfileID] [smallint] IDENTITY (1,1),
	[ProfileName] [nvarchar](50) NULL,
	Sporttype smallint
 CONSTRAINT [PK_TOControl_Profile] PRIMARY KEY CLUSTERED 
(
	[ProfileID] ASC
	
) ON DATA
) ON DATA
CREATE NONCLUSTERED INDEX ix_Sporttype ON [TOControl_Profile] (Sporttype)
GO
DROP TABLE [TOControl_ProfileSetting]
GO
CREATE TABLE [dbo].[TOControl_ProfileSetting](
	ProfileSettingID INT IDENTITY (1,1),
	[ProfileID] [smallint] NOT NULL,
	[Sporttype] [smallint] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[liveindicator] [bit] NOT NULL,
 CONSTRAINT [PK_TOControl_ProfileSetting] PRIMARY KEY CLUSTERED 
(
	ProfileSettingID
)ON DATA
) ON DATA
GO
CREATE NONCLUSTERED INDEX ix_Sporttype_Bettype_liveindicator ON TOControl_ProfileSetting
(
	[Sporttype],
	[Bettype],
	[liveindicator]
	
)
GO
ALTER TABLE [dbo].[TOControl_Setting] DROP CONSTRAINT  [PK_TOControl_Setting]
GO
ALTER TABLE [dbo].[TOControl_Setting]  ADD ProfileID  SMALLINT NULL
GO
CREATE CLUSTERED INDEX ix_CustID_MatchID_IsGroupHeadLine_ProfileID
ON [dbo].[TOControl_Setting](CustID, MatchID, IsGroupHeadLine, ProfileID)
GO





