USE [bodb02]
GO
/*
	https://redmine.nexcel.vn/issues/54102
	Run on DBPRO
*/
CREATE TABLE [dbo].[AutoPayoutResult14](
	[MatchId] [int] NOT NULL,
	[CalculationType] [tinyint] NOT NULL,
	[SourceId] [tinyint] NULL,
	[HomeValue] [varchar](50) NULL,
	[AwayValue] [varchar](50) NULL,
	[StatusId] [tinyint] NULL,
	[TryCount] [tinyint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_AutoPayoutResult14] PRIMARY KEY CLUSTERED 
(
	[MatchId] ASC,
	[CalculationType] ASC
) ON [DATA]
) ON [DATA]

GO

ALTER TABLE [dbo].[AutoPayoutResult14] ADD  CONSTRAINT [DF_AutoPayoutResult14_IsCalculated]  DEFAULT ((0)) FOR [StatusId]
GO

ALTER TABLE [dbo].[AutoPayoutResult14] ADD  CONSTRAINT [DF_AutoPayoutResult14_TryCount]  DEFAULT ((0)) FOR [TryCount]
GO

ALTER TABLE [dbo].[AutoPayoutResult14] ADD  CONSTRAINT [DF_AutoPayoutResult14_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[AutoPayoutResult14] ADD  CONSTRAINT [DF_AutoPayoutResult14_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO


