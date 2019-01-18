USE [bodb02]
GO
/****** Object:  Table [dbo].[SMP_Selection]    Script Date: 01/10/2019 03:35:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_SMP_SelectionName] ON [dbo].[SMP_Selection] 
(
	[SelectionName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
GO
/****** Object:  Table [dbo].[SMP_MarketSelection]    Script Date: 01/10/2019 03:35:03 ******/
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE CLUSTERED INDEX [IXM_MatchId_MarketId] ON [dbo].[SMP_MarketSelection] 
(
	[MatchId] ASC,
	[MarketId] ASC,
	[SelectionType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
GO
/****** Object:  Table [dbo].[SMP_Market]    Script Date: 01/10/2019 03:35:03 ******/
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
	[MarketId] ASC,
	[MatchId] ASC,
	[VendorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]
GO
SET ANSI_PADDING OFF
GO
