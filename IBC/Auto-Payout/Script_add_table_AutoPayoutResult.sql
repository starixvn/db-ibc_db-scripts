USE [bodb02]
GO
/*
	https://redmine.nexcel.vn/issues/54102
	Run on DBPRO
*/

CREATE TABLE [dbo].[AutoPayoutResult](
	[MatchId] [int] NOT NULL,
	[CalculationType] [tinyint] NOT NULL,
	[SourceId] [tinyint] NULL,
	[HomeValue] [varchar](50) NULL,
	[AwayValue] [varchar](50) NULL,
	[StatusId] [tinyint] NULL,
	[TryCount] [tinyint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_AutoPayoutResult] PRIMARY KEY CLUSTERED 
(
	[MatchId] ASC,
	[CalculationType] ASC
) ON [DATA]
) ON [DATA]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[AutoPayoutResult] ADD  CONSTRAINT [DF_AutoPayoutResult_IsCalculated]  DEFAULT ((0)) FOR [StatusId]
GO

ALTER TABLE [dbo].[AutoPayoutResult] ADD  CONSTRAINT [DF_AutoPayoutResult_TryCount]  DEFAULT ((0)) FOR [TryCount]
GO

ALTER TABLE [dbo].[AutoPayoutResult] ADD  CONSTRAINT [DF_AutoPayoutResult_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[AutoPayoutResult] ADD  CONSTRAINT [DF_AutoPayoutResult_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO


