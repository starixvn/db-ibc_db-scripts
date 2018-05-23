USE [bodb_Summary]
GO

/*
	Created: 20180320@Percy
	DB: DBSUM.bodb_Summary
*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[rptProgressiveGamesContribution](
	[KeyId] [bigint] IDENTITY(1,1) NOT NULL,
	[WinlostDate] [smalldatetime] NULL,
	[CustId] [int] NULL,
	[RoleId] [int] NULL,
	[Recommend] [int] NULL,
	[MRecommend] [int] NULL,
	[SRecommend] [int] NULL,
	[ProductId] [smallint] NULL,
	[GameId] [smallint] NULL,
	[Betcount] [int] NULL,
	[Turnover] [money] NULL,
	[Contribution] [money] NULL,
	[ContributionA] [money] NULL,
	[ContributionM] [money] NULL,
	[ContributionS] [money] NULL,
	CONSTRAINT [PK_rptProgressiveGamesContribution] PRIMARY KEY NONCLUSTERED 
	(
		[KeyId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

ALTER TABLE [dbo].[rptProgressiveGamesContribution] ADD  CONSTRAINT [DF_rptProgressiveGamesContribution_BetCount]  DEFAULT ((0)) FOR [Betcount]
GO

ALTER TABLE [dbo].[rptProgressiveGamesContribution] ADD  CONSTRAINT [DF_rptProgressiveGamesContribution_Turnover]  DEFAULT ((0)) FOR [Turnover]
GO

ALTER TABLE [dbo].[rptProgressiveGamesContribution] ADD  CONSTRAINT [DF_rptProgressiveGamesContribution_Contribution]  DEFAULT ((0)) FOR [Contribution]
GO

ALTER TABLE [dbo].[rptProgressiveGamesContribution] ADD  CONSTRAINT [DF_rptProgressiveGamesContribution_ContributionA]  DEFAULT ((0)) FOR [ContributionA]
GO

ALTER TABLE [dbo].[rptProgressiveGamesContribution] ADD  CONSTRAINT [DF_rptProgressiveGamesContribution_ContributionM]  DEFAULT ((0)) FOR [ContributionM]
GO

ALTER TABLE [dbo].[rptProgressiveGamesContribution] ADD  CONSTRAINT [DF_rptProgressiveGamesContribution_ContributionS]  DEFAULT ((0)) FOR [ContributionS]
GO

CREATE CLUSTERED INDEX CIX_winlostdate_SMA ON [dbo].[rptProgressiveGamesContribution] (winlostdate, srecommend, mrecommend, recommend, roleid, productId, gameId)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
GO

GRANT SELECT ON [dbo].[rptProgressiveGamesContribution] TO [bodbAdminNet] AS [dbo]
GO

GRANT SELECT ON [dbo].[rptProgressiveGamesContribution] TO [bodbDownlineNet] AS [dbo]
GO

GRANT SELECT ON [dbo].[rptProgressiveGamesContribution] TO [bodbDownlineNetView] AS [dbo]
GO

GRANT SELECT ON [dbo].[rptProgressiveGamesContribution] TO [bodbExtAccNet] AS [dbo]
GO

GRANT SELECT ON [dbo].[rptProgressiveGamesContribution] TO [bodbLicenseeNet] AS [dbo]
GO