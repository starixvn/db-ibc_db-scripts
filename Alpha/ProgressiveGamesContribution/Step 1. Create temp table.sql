USE [bodb_Summary]
GO

/*
	Created: 20180530@Percy
	Task: Regen data for rptProgressiveGamesContribution [Redmine: #96053]
	DB: DBSUM.bodb_Summary

	Step 1: Create temp table
*/

CREATE TABLE [dbo].[rptProgressiveGamesContribution_tmp](
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
) ON [DATA]
GO

CREATE NONCLUSTERED INDEX IX_Winlostdate_CustId_ProductId_GameId
	ON [dbo].[rptProgressiveGamesContribution_tmp] (Winlostdate, CustId, ProductId, GameId)