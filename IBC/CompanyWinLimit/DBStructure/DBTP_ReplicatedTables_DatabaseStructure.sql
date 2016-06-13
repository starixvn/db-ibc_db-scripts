/*
	Created by: Helen
	Created Date: 20160613
	Description: Company Win Limit Structure - Phase 2 
	
	Database: DBTP/bodb_CustHistory (local dev: server232 -   local test: server234)
	
	Filegroup in local test - Server 234: "D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history"
	Filegroup in local dev -  Server 232: "E:\IBC_DB\bodb_CustHistory"
	
	
	Production : 'P:\IBC_DB\bodb_CustHistory\CustPTSetting3rd_table_01.NDF'
*/
USE bodb02
GO
--- CREATING FILE GROUP AND DATA FILE
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='WinlimitSetting_Tables')
BEGIN
	ALTER DATABASE bodb02
	ADD FILEGROUP WinlimitSetting_Tables;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='WinlimitSetting_Tables_01')
BEGIN
ALTER DATABASE bodb02 
ADD FILE 
(
	NAME = WinlimitSetting_Tables_01,
	--local dev
	--FILENAME = 'D:\IBC_DB\bodb02\WinlimitSetting_Tables_01.NDF' 
	
	--local test
	--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb02\WinlimitSetting_Tables_01.NDF' 
	--Production 
	FILENAME = 'P:\IBC_DB\bodb02\WinlimitSetting_Tables_01.NDF'
	--, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
	-- SIT
	--FILENAME = 'P:\IBC_DB\bodb02\WinlimitSetting_Tables_01.NDF'
	
)
TO FILEGROUP WinlimitSetting_Tables;
END
GO

USE bodb02
GO


CREATE TABLE [dbo].[WinLimit_CustSetting](
	[CustID] [int] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[LevelID]	[tinyint] NOT NULL,
	[MaxWinLimit] [money] NOT NULL
 CONSTRAINT [PK_WinLimit_CustSetting] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[ProductID] ASC,
	[BettypeID] ASC,
	[LevelID]
	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO
ALTER TABLE [dbo].[WinLimit_CustSetting] ADD CONSTRAINT [DF_WinLimit_CustSetting_MaxWinLimit] DEFAULT ((0)) FOR [MaxWinLimit]
GO