SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SMP_Market](
	[VendorID] [smallint] NOT NULL,
	[FixtureID] [varchar](20) NOT NULL,
	[MarketID] [varchar](20) NOT NULL,
	[Price] [smallmoney] NOT NULL,
	[TradeStatus] [varchar](20) NULL,
	[Result] [varchar](20) NULL,
	[ResultStatusID] [tinyint] NULL,
	[SelectionCounts] [tinyint] NOT NULL,
	[CreateTime] [datetime] NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_SMP_Market] PRIMARY KEY CLUSTERED 
(
	[VendorID] ASC,
	[FixtureID] ASC,
	[MarketID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]

GO

SET ANSI_PADDING OFF
GO
