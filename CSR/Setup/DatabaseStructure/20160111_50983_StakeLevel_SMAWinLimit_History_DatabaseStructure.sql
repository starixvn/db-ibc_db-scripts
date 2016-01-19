/*
	Created by: Elodie	
	Created Date: 20160115
	Description: DCS 
	Database: DBTP/bodb_CustHistory 
	
	Filegroup in local test - Server 234: "D:\DB234_SQLSERVER2008R2\IBC_DB\bodb_history"
	Filegroup in local dev -  Server 232: "E:\IBC_DB\bodb_CustHistory"
*/
USE bodb_CustHistory
GO
--- CREATING FILE GROUP AND DATA FILE
ALTER DATABASE bodb_CustHistory ADD FILEGROUP CustWinLossLimit_table
ALTER DATABASE bodb_CustHistory ADD FILEGROUP CustStakeLevel_table

GO
ALTER DATABASE bodb_CustHistory 
ADD FILE 
(
	NAME = CustWinLossLimit_table_01,
	FILENAME = 'P:\IBC_DB\bodb_CustHistory\CustWinLossLimit_table_01.NDF'
	, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
)
TO FILEGROUP CustWinLossLimit_table

GO
ALTER DATABASE bodb_CustHistory 
ADD FILE 
(
	NAME = CustStakeLevel_table_01,
	FILENAME = 'P:\IBC_DB\bodb_CustHistory\CustStakeLevel_table_01.NDF'
	, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
)
TO FILEGROUP CustStakeLevel_table

USE bodb_CustHistory
GO
CREATE TABLE [dbo].[CustWinLossLimit_Agent_history](
	[UpdateTime] [datetime] NOT NULL,
	[CustId] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [int] NOT NULL,
	[MaxWinLimit] [smallmoney] NULL,
	[MaxLossLimit] [money] NULL,
	[IsAutoReset] [bit] NULL
) ON [CustWinLossLimit_table]

GO
ALTER TABLE [dbo].[CustWinLossLimit_Agent_history] ADD  CONSTRAINT [DF_CustWinLossLimit_Agent_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
CREATE CLUSTERED INDEX [CustWinLossLimit_Agent_His_Index] ON [dbo].[CustWinLossLimit_Agent_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO

GO
CREATE TABLE [dbo].[CustWinLossLimit_Member_history](
	[UpdateTime] [datetime] NOT NULL,
	[CustId] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [int] NOT NULL,
	[MaxWinLimit] [smallmoney] NULL,
	[MaxLossLimit] [money] NULL,
	[IsAutoReset] [bit] NULL
 ) ON [CustWinLossLimit_table]
 GO
 ALTER TABLE [dbo].[CustWinLossLimit_Member_history] ADD  CONSTRAINT [DF_CustWinLossLimit_Member_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
 GO
CREATE CLUSTERED INDEX [CustWinLossLimit_Member_His_Index] ON [dbo].[CustWinLossLimit_Member_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO

CREATE TABLE [dbo].[CustStakeLevel_Agent_history] (
	UpdateTime		DATETIME			NOT NULL,
	CustID			INT					NOT NULL,
	SportType		SMALLINT			NOT NULL,
	BetType			INT					NOT NULL,
	StakeLevelList	VARCHAR(200)		NULL,
) ON [CustStakeLevel_table]
 GO
 ALTER TABLE [dbo].[CustStakeLevel_Agent_history] ADD  CONSTRAINT [DF_CustStakeLevel_Agent_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
 GO
CREATE CLUSTERED INDEX [CustStakeLevel_Agent_His_Index] ON [dbo].[CustStakeLevel_Agent_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO

CREATE TABLE [dbo].[CustStakeLevel_Member_history] (
	UpdateTime		DATETIME			NOT NULL,
	CustID			INT					NOT NULL,
	SportType		SMALLINT			NOT NULL,
	BetType			INT					NOT NULL,
	StakeLevelList	VARCHAR(200)		NULL,
	LastUpdated		DATETIME			NULL	
	CONSTRAINT		DF_CustStakeLevel_Member_history_LastUpdate DEFAULT GETDATE(),
) ON [CustStakeLevel_table]
 GO
 ALTER TABLE [dbo].[CustStakeLevel_Member_history] ADD  CONSTRAINT [DF_CustStakeLevel_Member_history_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
 GO
CREATE CLUSTERED INDEX [CustStakeLevel_Member_His_Index] ON [dbo].[CustStakeLevel_Member_history] 
(
	[UpdateTime] ASC,
	[CustID] ASC
) 
GO

