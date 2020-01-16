/*
    Created: 20200108@Malcolm
	Task: Separate setting and notification into Live/Non-Live and bettypes - [Redmine: #126348]
	DB: DBARC/bodb_Archive
*/
USE bodb_Archive
GO

ALTER TABLE [dbo].[TOControl_Setting_bk] DROP CONSTRAINT  [PK_TOControl_Setting_bk]
GO
ALTER TABLE [dbo].[TOControl_Setting_bk]  ADD ProfileID  SMALLINT NULL
GO
CREATE CLUSTERED INDEX ix_CustID_MatchID_IsGroupHeadLine_ProfileID_bk
ON [dbo].[TOControl_Setting_bk](CustID, MatchID, IsGroupHeadLine, ProfileID)
GO