/*
    Created: 20200108@Malcolm
	Task: Separate setting and notification into Live/Non-Live and bettypes - [Redmine: #126348]
	DB: DBCUST/CustDB
*/

USE CustDB
GO

CREATE TABLE [dbo].[TOControl_Profile](
	ProfileID SMALLINT IDENTITY (1,1),
	ProfileName NVARCHAR(50) NULL,
	Sporttype SMALLINT,
	GroupName NVARCHAR(100) NULL
 CONSTRAINT [PK_TOControl_Profile] PRIMARY KEY CLUSTERED 
(
	[ProfileID] ASC
	
) ON DATA
) ON DATA
CREATE NONCLUSTERED INDEX ix_Sporttype ON [TOControl_Profile] (Sporttype)
GO

CREATE TABLE [dbo].[TOControl_ProfileSetting](
	ProfileSettingID INT IDENTITY (1,1),
	ProfileID SMALLINT NOT NULL,
	Sporttype SMALLINT NOT NULL,
	Bettype SMALLINT NOT NULL,
	liveindicator BIT NOT NULL,
 CONSTRAINT [PK_TOControl_ProfileSetting] PRIMARY KEY CLUSTERED 
(
	ProfileSettingID
)ON DATA
) ON DATA
GO
CREATE NONCLUSTERED INDEX [ix_Sporttype_Bettype_liveindicator] ON [dbo].[TOControl_ProfileSetting] 
(
	[Sporttype] ASC,
	[Bettype] ASC,
	[liveindicator] ASC
) INCLUDE (ProfileID)
GO

ALTER TABLE [dbo].[TOControl_Setting] DROP CONSTRAINT  [PK_TOControl_Setting]
GO
ALTER TABLE [dbo].[TOControl_Setting]  ADD ProfileID  SMALLINT NULL
GO
CREATE CLUSTERED INDEX ix_CustID_MatchID_IsGroupHeadLine_ProfileID
ON [dbo].[TOControl_Setting](CustID, MatchID, IsGroupHeadLine, ProfileID)
GO





