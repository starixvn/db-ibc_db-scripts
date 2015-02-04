CREATE TABLE [dbo].[mcCustBettingMonthly](
	[rptYear] [smallint] NOT NULL,
	[rptMonth] [tinyint] NOT NULL,
	[CustID] [int] NOT NULL,
	[SiteID] [smallint] NOT NULL,
	[Currency] [tinyint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[LeagueID] [int] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[WinlossIBC] [money] NULL,
	[Winloss100] [money] NULL,
	[WinlossIBCVirtual] [money] NULL,
	[TurnoverIBC] [money] NULL,
	[Turnover100] [money] NULL,
	[TurnoverIBCVirtual] [money] NULL,
	[CommissionS] [money] NULL,
	[CommissionSVirtual] [money] NULL,
	[BetCount] [int] NULL,
 CONSTRAINT [PK_mcCustBettingMonthly] PRIMARY KEY CLUSTERED 
(
	[rptYear] ASC,
	[rptMonth] ASC,
	[CustID] ASC,
	[SiteID] ASC,
	[Currency] ASC,
	[BetType] ASC,
	[LeagueID] ASC,
	[IsLive] ASC,
	[Status] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [mcCustBettingMonthLy]
) ON [mcCustBettingMonthLy]

GO


