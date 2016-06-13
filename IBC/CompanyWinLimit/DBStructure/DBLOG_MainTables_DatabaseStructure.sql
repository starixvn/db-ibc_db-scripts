/*
	Created by: Helen
	Created Date: 20160613
	Description: Company Win Limit Structure - Phase 2 
	Database: DBLOG/Bodb_CustomerLog (DB231 - DB215)
	
	Local Test: D:\IBC_DB\bodb_CustomerLog
	Local Dev:  E:\IBC_DB\bodb_CustomerLog
	Production G:\IBC_DB\bodb_CustomerLog
		
*/
USE Bodb_CustomerLog
GO
--- CREATING FILE GROUP AND DATA FILE
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='WinlimitSetting_Tables')
BEGIN
	ALTER DATABASE Bodb_CustomerLog
	ADD FILEGROUP WinlimitSetting_Tables;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='WinlimitSetting_Tables_01')
BEGIN
	ALTER DATABASE Bodb_CustomerLog 
	ADD FILE 
	(
		NAME = WinlimitSetting_Tables_01,
		-- local dev
		--FILENAME = 'E:\IBC_DB\bodb_CustomerLog\WinlimitSetting_Tables_01.NDF'
		-- local test
		--FILENAME = 'D:\IBC_DB\Bodb_CustomerLog\WinlimitSetting_Tables_01.NDF'
		-- Production
		FILENAME = 'G:\IBC_DB\bodb_CustomerLog\WinlimitSetting_Tables_01.NDF'
	)
	TO FILEGROUP WinlimitSetting_Tables;
END
GO
GO
-------
USE Bodb_CustomerLog
GO
CREATE TABLE [dbo].[WinLimit_CustGameMonitoring_History](
	[LogID] [bigint] NOT NULL,
	[CustID] [int] NOT NULL,
	[ProductID] [tinyint] NOT NULL,
	[BettypeID] [smallint] NOT NULL,
	[WinlostDate] [smalldatetime] NOT NULL,
	[LevelID]	[tinyint] NOT NULL,
	[MaxWinLimit] [money] NOT NULL,
	[TotalWinAmt] [money] NOT NULL,
	[WinAmt] [money] NOT NULL,
	[ActionID] [tinyint] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[IsNotified] [bit] NOT NULL,
	[ModifiedBy] [int],
	[CreatedBy] [int]
	
 CONSTRAINT [PK_WinLimit_CustGameMonitoring_History] PRIMARY KEY  ([LogID])
 , CONSTRAINT CIX_CustID_ProductID_BetTypeID_WinlostDate UNIQUE CLUSTERED (CustID,ProductID,BetTypeID,WinlostDate)

WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [WinlimitSetting_Tables]
) ON [WinlimitSetting_Tables]

GO
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring_History] ADD  DEFAULT ((0)) FOR [MaxWinLimit]
GO
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring_History] ADD  DEFAULT ((0)) FOR [TotalWinAmt]
GO
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring_History] ADD  DEFAULT ((0)) FOR [WinAmt]
go
ALTER TABLE [dbo].[WinLimit_CustGameMonitoring_History] ADD  DEFAULT ((0)) FOR [ActionID]
GO