/*
	Created by: Dominic
	Created Date: 20160115
	Description: DCS 
	Database: DBCUST@CustDB
		
*/

USE [CustDB]
GO

CREATE TABLE [dbo].[ProductSettingUpdateRestriction](
	[SystemID] [tinyint] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[SettingType] [smallint] NOT NULL,
	[ActorRoleID] [tinyint] NOT NULL,
	[TargetRoleID] [tinyint] NOT NULL,
	[ErrCode] [int] NULL,
	[RestrictionMode] [tinyint] NULL,
 CONSTRAINT [PK_ProductSettingUpdateRestriction] PRIMARY KEY CLUSTERED 
(
	[SystemID] ASC,
	[ProductID] ASC,
	[SettingType] ASC,
	[ActorRoleID] ASC,
	[TargetRoleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]

GO


