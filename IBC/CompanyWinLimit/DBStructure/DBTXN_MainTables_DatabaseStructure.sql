/*
	Created by: Helen
	Created Date: 20160613
	Description: Company Win Limit Structure - Phase 2 
	
	Database: DBTRANS/bodb02 (DB230 - DB206)
	
	Local Test: D:\IBC_DB\bodb02
	Local Dev: D:\IBC_DB\bodb02
	Production H:\IBC_DB\bodb02\
		
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
		-- local dev
		--FILENAME = 'D:\IBC_DB\bodb02\WinlimitSetting_Tables_01.NDF'
		-- local test
		--FILENAME = 'D:\IBC_DB\bodb02\WinlimitSetting_Tables_01.NDF'
		-- Production
		FILENAME = 'H:\IBC_DB\bodb02\WinlimitSetting_Tables_01.NDF'
		-- SIT
		--FILENAME = 'H:\USER_DB\bodb02\WinlimitSetting_Tables_01.NDF'
		
	)
	TO FILEGROUP WinlimitSetting_Tables;
END
GO


GO
-------
USE bodb02
GO
CREATE TABLE [dbo].[WinLimit_CustGameMonitoring](
	[CustID] [int] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[WinlostDate] [smalldatetime] NOT NULL,
	[LevelID]	[tinyint] NOT NULL,
	[MaxWinLimit] [money] NOT NULL,
	[TotalWinAmt] [money] NOT NULL,
	[WinAmt] [money] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[IsNotified] [bit] NOT NULL,
	[ModifiedBy] [int],
	[CreatedBy] [int]
	
	
 CONSTRAINT [PK_WinLimit_CustGameMonitoring] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[ProductID] ASC,
	[BettypeID] ASC,
	[WinlostDate] ASC
	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring] ADD  CONSTRAINT [DF_WinLimit_CustGameMonitoring_MaxWinLimit] DEFAULT ((0)) FOR [MaxWinLimit]
GO
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring] ADD  CONSTRAINT [DF_WinLimit_CustGameMonitoring_TotalWinAmt] DEFAULT ((0)) FOR [TotalWinAmt]
GO
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring] ADD  CONSTRAINT [DF_WinLimit_CustGameMonitoring_WinAmt] DEFAULT ((0)) FOR [WinAmt]
GO