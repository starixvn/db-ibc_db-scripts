/*
    Created: 20200108@Malcolm
	Task: Separate setting and notification into Live/Non-Live and bettypes - [Redmine: #126348]
	DB: DBCUST/CustDB
*/
USE CustDB
GO

ALTER TABLE [dbo].[TOControl_Setting] DROP CONSTRAINT  [PK_TOControl_Setting]
GO

ALTER TABLE [dbo].[TOControl_Setting]  ADD ProfileID  SMALLINT NULL
GO

CREATE CLUSTERED INDEX ix_CustID_MatchID_IsGroupHeadLine_ProfileID
ON [dbo].[TOControl_Setting](CustID, MatchID, IsGroupHeadLine, ProfileID)
GO

