USE [bodb02]
GO
/*
	https://redmine.nexcel.vn/issues/54102
	Run on DBPRO
*/
CREATE TABLE [dbo].[ProviderResultDetail14](
	[MatchId] [int] NOT NULL,
	[SourceId] [tinyint] NOT NULL,
	[TypeId] [tinyint] NOT NULL,
	[HomeValue] [varchar](50) NULL,
	[AwayValue] [varchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProviderResultDetail14] PRIMARY KEY CLUSTERED 
(
	[MatchId] ASC,
	[SourceId] ASC,
	[TypeId] ASC
) ON [DATA]
) ON [DATA]

GO

ALTER TABLE [dbo].[ProviderResultDetail14] ADD  CONSTRAINT [DF_ProviderResultDetail14_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO


