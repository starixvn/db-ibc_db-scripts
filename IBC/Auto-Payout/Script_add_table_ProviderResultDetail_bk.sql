USE bodb_Archive
GO
/*
	https://redmine.nexcel.vn/issues/54102
	Run on DBARC
*/
CREATE TABLE [dbo].[ProviderResultDetail_bk](
	[MatchId] [int] NOT NULL,
	[SourceId] [tinyint] NOT NULL,
	[TypeId] [tinyint] NOT NULL,
	[HomeValue] [varchar](50) NULL,
	[AwayValue] [varchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProviderResultDetail_bk] PRIMARY KEY CLUSTERED 
(
	[MatchId] ASC,
	[SourceId] ASC,
	[TypeId] ASC
) ON [DATA]
) ON [DATA]

GO
ALTER TABLE [dbo].[ProviderResultDetail_bk] ADD  CONSTRAINT [DF_ProviderResultDetail_bk_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO


