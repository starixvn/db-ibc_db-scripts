/*<info serverAlias="DBRPT-bodb_report"></info>*/
/*
	Created: 20210726@Kos
	DB: DBRPT-bodb_report
	Task: Create temp table rptWinlostbyLeague_UAT for testing [Redmine: #151151]
*/

USE bodb_report
GO

CREATE TABLE [dbo].[rptWinlostbyLeague_UAT](
	[winlostdate] [smalldatetime] NULL,
	[matchid] [int] NOT NULL,
	[oddsid] [int] NULL,
	[odds] [smallmoney] NOT NULL,
	[oddstype] [smallint] NULL,
	[bettype] [smallint] NULL,
	[stake] [money] NOT NULL,
	[winlost] [money] NULL,
	[awinlost] [money] NULL,
	[comm] [money] NULL,
	[playercomm] [money] NULL,
	[recommend] [int] NULL,
	[leagueid] [int] NULL,
	[statusID] [tinyint] NULL,
	[isBA] [tinyint] NULL,
	[currency] [int] NULL,
	[betcount] [int] NULL,
	[LiveIndicator] [BIT] NULL
)

GO

CREATE CLUSTERED INDEX [CIX_Winlostdate] ON [dbo].[rptWinlostbyLeague_UAT]
(
	[winlostdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
