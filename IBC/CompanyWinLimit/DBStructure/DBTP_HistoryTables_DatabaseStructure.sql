/*
	Created by: Helen
	Created Date: 20160613
	Description: Company Win Limit Structure - Phase 2 
	
	Database: DBTP/bodb_CustHistory (local dev: server232 -   local test: server234)
	
	Filegroup in local test - Server 234: "D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history"
	Filegroup in local dev -  Server 232: "E:\IBC_DB\bodb_CustHistory"
	Production : 'P:\IBC_DB\bodb_CustHistory\CustPTSetting3rd_table_01.NDF'
*/
USE bodb_CustHistory
GO
--- CREATING FILE GROUP AND DATA FILE
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='WinlimitSetting_Tables')
BEGIN
	ALTER DATABASE bodb_CustHistory
	ADD FILEGROUP WinlimitSetting_Tables;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='WinlimitSetting_Tables_01')
BEGIN
ALTER DATABASE bodb_CustHistory 
ADD FILE 
(
	NAME = WinlimitSetting_Tables_01,
	--local dev
	--FILENAME = 'E:\IBC_DB\bodb_CustHistory\WinlimitSetting_Tables_01.NDF' 
	
	--local test
	--FILENAME = 'D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history\WinlimitSetting_Tables_01.NDF' 
	--Production 
	FILENAME = 'P:\IBC_DB\bodb_CustHistory\WinlimitSetting_Tables_01.NDF'
	--, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
	-- SIT
	--FILENAME = 'P:\IBC_DB\bodb_CustHistory\WinlimitSetting_Tables_01.NDF'
)
TO FILEGROUP WinlimitSetting_Tables;
END
GO

USE bodb_CustHistory
GO

CREATE TABLE [dbo].[WinLimit_CustSetting_history](
	[UpdateTime] [datetime] NOT NULL,
	[CustID] [int] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[LevelID]	[tinyint] NOT NULL,
	[MaxWinLimit] [money] NOT NULL
 
) ON [WinlimitSetting_Tables]

GO
ALTER TABLE [dbo].[WinLimit_CustSetting_history] ADD  CONSTRAINT [DF_WinLimit_CustSetting_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]

GO
ALTER TABLE [dbo].[WinLimit_CustSetting_history] ADD CONSTRAINT [DF_WinLimit_CustSetting_MaxWinLimit] DEFAULT ((0)) FOR [MaxWinLimit]
GO
CREATE CLUSTERED INDEX [CustPTSetting3rd_Member_His_Index] ON [dbo].[WinLimit_CustSetting_history] 
(
	[UpdateTime] ASC,
	[custid] ASC
) 
