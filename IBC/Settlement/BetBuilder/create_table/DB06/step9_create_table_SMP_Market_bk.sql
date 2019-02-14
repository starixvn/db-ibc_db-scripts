/*
	Created: Vicky
	Task: Betbuilder
	DB: DB06/bodb02
	Date: 20190130
*/
USE [bodb_archive]
GO

CREATE TABLE [dbo].[SMP_Market_bk](
	[MarketId] [VARCHAR](20) NOT NULL,
	[MatchId] [INT] NOT NULL,
	[VendorId] [SMALLINT] NOT NULL,
	[Price] [SMALLMONEY] NOT NULL,
	[TradeStatus] [VARCHAR](20) NOT NULL,
	[Result] [VARCHAR](20) NULL,
	[ResultStatusId] [TINYINT] NOT NULL,
	[SelectionCounts] [TINYINT] NULL,
	[CreateTime] [DATETIME] NOT NULL,
	[UpdateTime] [DATETIME] NOT NULL,
 CONSTRAINT [PK_SMP_Market_bk] PRIMARY KEY CLUSTERED 
(
	[MatchId] ASC,
	[MarketId] ASC,
	[VendorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]

GO
