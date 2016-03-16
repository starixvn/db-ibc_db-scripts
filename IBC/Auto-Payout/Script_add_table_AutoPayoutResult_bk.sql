USE bodb_Archive
GO
/*
	https://redmine.nexcel.vn/issues/54102
	Run on DBARC
*/
CREATE TABLE [dbo].[AutoPayoutResult_bk](
	[MatchId] [int] NOT NULL,
	[CalculationType] [tinyint] NOT NULL,
	[SourceId] [tinyint] NULL,
	[HomeValue] [varchar](50) NULL,
	[AwayValue] [varchar](50) NULL,
	[StatusId] [tinyint] NULL,
	[TryCount] [tinyint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_AutoPayoutResult_bk] PRIMARY KEY CLUSTERED 
(
	[MatchId] ASC,
	[CalculationType] ASC
) ON [DATA]
) ON [DATA]

GO

ALTER TABLE [dbo].[AutoPayoutResult_bk] ADD  CONSTRAINT [DF_AutoPayoutResult_bk_IsCalculated]  DEFAULT ((0)) FOR [StatusId]
GO

ALTER TABLE [dbo].[AutoPayoutResult_bk] ADD  CONSTRAINT [DF_AutoPayoutResult_bk_TryCount]  DEFAULT ((0)) FOR [TryCount]
GO

ALTER TABLE [dbo].[AutoPayoutResult_bk] ADD  CONSTRAINT [DF_AutoPayoutResult_bk_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[AutoPayoutResult_bk] ADD  CONSTRAINT [DF_AutoPayoutResult_bk_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO


