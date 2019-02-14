/*
	Created: Vicky
	Task: Betbuilder
	DB: DB06/bodb02
	Date: 20190130
*/
USE [bodb_archive]
GO

CREATE TABLE [dbo].[SMP_MarketSelection_bk](
	[MarketSelectionId] [BIGINT] NOT NULL,
	[MarketId] [VARCHAR](20) NOT NULL,
	[SelectionType] [INT] NOT NULL,
	[Result] [VARCHAR](20) NULL,
	[ResultStatusId] [TINYINT] NOT NULL,
	[MatchId] [INT] NOT NULL,
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