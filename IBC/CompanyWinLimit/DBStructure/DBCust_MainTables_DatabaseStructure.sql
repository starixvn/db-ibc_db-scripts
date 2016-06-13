/*
	Created by: Helen
	Created Date: 20160613
	Description: Company Win Limit Structure - Phase 2 
	Database: DBCUST/CustDB
	
	Local Test: D:\DB233\IBC_DB\CustDB
	Local Dev: D:\SQLSERVER2008R2\IBC_DB\CustDB
	Production: H:\USER_DB\CustDB
		
*/
USE CustDB
GO

--- CREATING FILE GROUP AND DATA FILE

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='WinlimitSetting_Tables')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP WinlimitSetting_Tables;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='WinlimitSetting_Tables_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = WinlimitSetting_Tables_01,
		-- local dev
		--FILENAME = 'D:\SQLSERVER2008R2\IBC_DB\CustDB\WinlimitSetting_Tables_01.NDF'
		-- local test
		--FILENAME = 'D:\DB233\IBC_DB\CustDB\WinlimitSetting_Tables_01.NDF'
		-- Production
		FILENAME = 'H:\USER_DB\CustDB\WinlimitSetting_Tables_01.NDF'
		-- SIT
		--FILENAME = 'H:\USER_DB\CustDB\WinlimitSetting_Tables_01.NDF'
		
	)
	TO FILEGROUP WinlimitSetting_Tables;
END
GO


USE CustDB

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

CREATE TABLE [dbo].[WinLimit_CustGameStatus](
	[CustID] [int] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[IsBlockedPlaceBet]	[bit] NOT NULL,
	[IsBlockedTransfer] [bit] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
 CONSTRAINT [PK_WinLimit_CustGameStatus] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[ProductID] ASC,
	[BettypeID] ASC
	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO
ALTER TABLE [dbo].[WinLimit_CustGameStatus] ADD  CONSTRAINT [DF_WinLimit_CustGameStatus_IsBlockedPlaceBet] DEFAULT ((0)) FOR [IsBlockedPlaceBet]
GO
ALTER TABLE [dbo].[WinLimit_CustGameStatus] ADD  CONSTRAINT [DF_WinLimit_CustGameStatus_IsBlockedTransfer] DEFAULT ((0)) FOR [IsBlockedTransfer]


