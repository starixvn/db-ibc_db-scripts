USE [bodb02]
GO

/****** Object:  Table [dbo].[SMP_Market14]    Script Date: 02/14/2019 02:34:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
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

SET ANSI_PADDING OFF
GO


