/*
	Created by: Dominic
	Created Date: 20160115
	Description: DCS 
	Database: DBCUST@CustDB
	
	Description: This table will be added to the list of articles of a publication named "CustDB_Customer_Info"
		
*/

USE [CustDB]
GO

--- CREATING FILE GROUP AND DATA FILE
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='ProductSettingUpdateRestriction_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP ProductSettingUpdateRestriction_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='ProductSettingUpdateRestriction_table_01')
BEGIN
ALTER DATABASE CustDB 
ADD FILE 
(
	NAME = ProductSettingUpdateRestriction_table_01,
	FILENAME = 'XXXXXX\ProductSettingUpdateRestriction_table_01.NDF'
	, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
)
TO FILEGROUP ProductSettingUpdateRestriction_table;
END
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [ProductSettingUpdateRestriction_table]
) ON [ProductSettingUpdateRestriction_table]

GO


