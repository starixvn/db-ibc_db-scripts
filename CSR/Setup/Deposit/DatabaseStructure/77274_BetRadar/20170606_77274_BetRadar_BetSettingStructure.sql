/*
	Created by: Helen
	Created Date: 20170606
	Description: DCS - Deposit - Bet Setting 
	Database: DBCUST/CustDB
		
*/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustBetSetting_Member_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP Dep_CustBetSetting_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustBetSetting_Member_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = Dep_CustBetSetting_Member_table_01,
		FILENAME = 'H:\USER_DB\CustDB\Dep_CustBetSetting_Member_table_01.NDF'
	)
	TO FILEGROUP Dep_CustBetSetting_Member_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='Dep_CustBetSetting_Agent_table')
BEGIN
	ALTER DATABASE CustDB
	ADD FILEGROUP Dep_CustBetSetting_Agent_table;
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='Dep_CustBetSetting_Agent_table_01')
BEGIN
	ALTER DATABASE CustDB 
	ADD FILE 
	(
		NAME = Dep_CustBetSetting_Agent_table_01,
		FILENAME = 'H:\USER_DB\CustDB\Dep_CustBetSetting_Agent_table_01.NDF'
	)
	TO FILEGROUP Dep_CustBetSetting_Agent_table;
END

GO

CREATE TABLE [dbo].[Dep_CustBetSetting_Member](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[MaxPerMatch] [money] NULL,
 CONSTRAINT [PK_Dep_CustBetSetting_Member] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustBetSetting_Member_Table]
) ON [Dep_CustBetSetting_Member_Table]

GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Member] ADD  DEFAULT ((0)) FOR [MinBet]
GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Member] ADD  DEFAULT ((0)) FOR [MaxBet]
GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Member] ADD  DEFAULT ((0)) FOR [MaxPerMatch]
GO
CREATE TABLE [dbo].[Dep_CustBetSetting_Agent](
	[CustID] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[MaxPerMatch] [money] NULL,
 CONSTRAINT [PK_Dep_CustBetSetting_Agent] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [Dep_CustBetSetting_Agent_Table]
) ON [Dep_CustBetSetting_Agent_Table]

GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Agent] ADD  DEFAULT ((0)) FOR [MinBet]
GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Agent] ADD  DEFAULT ((0)) FOR [MaxBet]
GO

ALTER TABLE [dbo].[Dep_CustBetSetting_Agent] ADD  DEFAULT ((0)) FOR [MaxPerMatch]
GO


