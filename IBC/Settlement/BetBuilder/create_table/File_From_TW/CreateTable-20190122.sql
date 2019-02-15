USE [master]
GO
ALTER DATABASE [bodb02] ADD FILEGROUP [SMP_index]
GO
ALTER DATABASE [bodb02] ADD FILE ( NAME = N'SMP_index', FILENAME = N'H:\USER_DB\bodb02\SMP_index.ndf' , SIZE = 3072KB , FILEGROWTH = 65536KB ) TO FILEGROUP [SMP_index]
GO
ALTER DATABASE [bodb02] ADD FILEGROUP [SMP_table]
GO
ALTER DATABASE [bodb02] ADD FILE ( NAME = N'SMP_table', FILENAME = N'H:\USER_DB\bodb02\SMP_table.ndf' , SIZE = 3072KB , FILEGROWTH = 65536KB ) TO FILEGROUP [SMP_table]
GO
USE [bodb02]
GO
ALTER TABLE dbo.VendorStatus
ADD [FixtureId] [varchar](20) NULL
GO

CREATE TABLE [dbo].[SMP_Selection](
	[SelectionType] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SelectionName] [varchar](200) NOT NULL,
	[ResourceCh] [nvarchar](200) NULL,
	[ResourceCs] [nvarchar](200) NULL,
	[ResourceSc2] [nvarchar](200) NULL,
	[ResourceJp] [nvarchar](200) NULL,
	[ResourceTh] [nvarchar](200) NULL,
	[ResourceKo] [nvarchar](200) NULL,
	[ResourceEs] [nvarchar](200) NULL,
	[ResourceVn] [nvarchar](200) NULL,
	[ResourceId] [nvarchar](200) NULL,
	[ResourceFr] [nvarchar](200) NULL,
	[ResourceRu] [nvarchar](200) NULL,
	[ResourcePt] [nvarchar](200) NULL,
	[ResourceDe] [nvarchar](200) NULL,
	[ResourceIt] [nvarchar](200) NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_SMP_Selection] PRIMARY KEY CLUSTERED 
(
	[SelectionType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SMP_table]
) ON [SMP_table]
GO
SET ANSI_PADDING OFF
GO

----@DB02 only
CREATE UNIQUE NONCLUSTERED INDEX [IX_SMP_SelectionName] ON [dbo].[SMP_Selection] 
(
	[SelectionName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SMP_index]
GO

----@DBODDS only
--USE [bodb_odds]
--GO

--/****** Object:  Index [IX_tstamp]    Script Date: 01/21/2019 06:16:27 ******/
--CREATE NONCLUSTERED INDEX [IX_tstamp] ON [dbo].[SMP_Selection] 
--(
--	[tstamp] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SMP_index]
--GO

/****** Object:  Table [dbo].[SMP_MarketSelection]    Script Date: 01/15/2019 23:57:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMP_MarketSelection](
	[MarketSelectionId] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MarketId] [varchar](20) NOT NULL,
	[SelectionType] [int] NOT NULL,
	[Result] [varchar](20) NULL,
	[ResultStatusId] [tinyint] NOT NULL,
	[MatchId] [int] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_SMP_MarketSelection] PRIMARY KEY NONCLUSTERED 
(
	[MarketSelectionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SMP_index]
) ON [SMP_table]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE CLUSTERED INDEX [IXM_MatchId_MarketId] ON [dbo].[SMP_MarketSelection] 
(
	[MatchId] ASC,
	[MarketId] ASC,
	[SelectionType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SMP_table]
GO

/****** Object:  Table [dbo].[SMP_Market]    Script Date: 01/15/2019 23:57:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SMP_Market](
	[MarketId] [varchar](20) NOT NULL,
	[MatchId] [int] NOT NULL,
	[VendorId] [smallint] NOT NULL,
	[Price] [smallmoney] NOT NULL,
	[TradeStatus] [varchar](20) NOT NULL,
	[Result] [varchar](20) NULL,
	[ResultStatusId] [tinyint] NOT NULL,
	[SelectionCounts] [tinyint] NULL,
	[CreateTime] [datetime] NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
	[tstamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_SMP_Market] PRIMARY KEY CLUSTERED 
(
	[MatchId] ASC,
	[MarketId] ASC,
	[VendorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SMP_table]
) ON [SMP_table]
GO
SET ANSI_PADDING OFF
GO


-----------------SMP table 14 & bk--------------
USE [master]
GO
ALTER DATABASE [bodb02] ADD FILEGROUP [SMP_index14]
GO
ALTER DATABASE [bodb02] ADD FILE ( NAME = N'SMP_index14', FILENAME = N'H:\USER_DB\bodb02\SMP_index14.ndf' , SIZE = 3072KB , FILEGROWTH = 65536KB ) TO FILEGROUP [SMP_index14]
GO
ALTER DATABASE [bodb02] ADD FILEGROUP [SMP_table14]
GO
ALTER DATABASE [bodb02] ADD FILE ( NAME = N'SMP_table14', FILENAME = N'H:\USER_DB\bodb02\SMP_table14.ndf' , SIZE = 3072KB , FILEGROWTH = 65536KB ) TO FILEGROUP [SMP_table14]
GO

USE [bodb02]
GO

CREATE TABLE [dbo].[SMP_Market14](
	[MarketId] [varchar](20) NOT NULL,
	[MatchId] [int] NOT NULL,
	[VendorId] [smallint] NOT NULL,
	[Price] [smallmoney] NOT NULL,
	[TradeStatus] [varchar](20) NOT NULL,
	[Result] [varchar](20) NULL,
	[ResultStatusId] [tinyint] NOT NULL,
	[SelectionCounts] [tinyint] NULL,
	[CreateTime] [datetime] NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_SMP_Market14] PRIMARY KEY CLUSTERED 
(
	[MatchId] ASC,
	[MarketId] ASC,
	[VendorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SMP_table14]
) ON [SMP_table14]

GO


CREATE TABLE [dbo].[SMP_MarketSelection14](
	[MarketSelectionId] [bigint] NOT NULL,
	[MarketId] [varchar](20) NOT NULL,
	[SelectionType] [int] NOT NULL,
	[Result] [varchar](20) NULL,
	[ResultStatusId] [tinyint] NOT NULL,
	[MatchId] [int] NOT NULL,
 CONSTRAINT [PK_SMP_MarketSelection14] PRIMARY KEY NONCLUSTERED 
(
	[MarketSelectionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SMP_index14]
) ON [SMP_table14]

GO

CREATE UNIQUE CLUSTERED INDEX [IXM_MatchId_MarketId] ON [dbo].[SMP_MarketSelection14] 
(
	[MatchId] ASC,
	[MarketId] ASC,
	[SelectionType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SMP_table14]
GO

------------

USE [bodb_archive]
GO

CREATE TABLE [dbo].[SMP_Market_bk](
	[MarketId] [varchar](20) NOT NULL,
	[MatchId] [int] NOT NULL,
	[VendorId] [smallint] NOT NULL,
	[Price] [smallmoney] NOT NULL,
	[TradeStatus] [varchar](20) NOT NULL,
	[Result] [varchar](20) NULL,
	[ResultStatusId] [tinyint] NOT NULL,
	[SelectionCounts] [tinyint] NULL,
	[CreateTime] [datetime] NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_SMP_Market_bk] PRIMARY KEY CLUSTERED 
(
	[MatchId] ASC,
	[MarketId] ASC,
	[VendorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]

GO


CREATE TABLE [dbo].[SMP_MarketSelection_bk](
	[MarketSelectionId] [bigint] NOT NULL,
	[MarketId] [varchar](20) NOT NULL,
	[SelectionType] [int] NOT NULL,
	[Result] [varchar](20) NULL,
	[ResultStatusId] [tinyint] NOT NULL,
	[MatchId] [int] NOT NULL,
 CONSTRAINT [PK_SMP_MarketSelection_bk] PRIMARY KEY NONCLUSTERED 
(
	[MarketSelectionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]

GO

CREATE UNIQUE CLUSTERED INDEX [IXM_MatchId_MarketId] ON [dbo].[SMP_MarketSelection_bk] 
(
	[MatchId] ASC,
	[MarketId] ASC,
	[SelectionType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
GO