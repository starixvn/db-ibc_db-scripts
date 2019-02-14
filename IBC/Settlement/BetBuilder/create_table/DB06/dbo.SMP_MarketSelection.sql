USE [bodb02]
GO

/****** Object:  Table [dbo].[SMP_MarketSelection]    Script Date: 02/14/2019 02:54:53 ******/
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




/****** Object:  Index [IXM_MatchId_MarketId]    Script Date: 02/14/2019 02:55:07 ******/
CREATE UNIQUE CLUSTERED INDEX [IXM_MatchId_MarketId] ON [dbo].[SMP_MarketSelection] 
(
	[MatchId] ASC,
	[MarketId] ASC,
	[SelectionType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SMP_table]
GO

SET ANSI_PADDING OFF
GO