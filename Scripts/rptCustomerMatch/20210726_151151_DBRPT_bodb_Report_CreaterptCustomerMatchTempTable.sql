/*<info serverAlias="DBRPT-bodb_report"></info>*/
/*
	Created: 20210726@Kos
	DB: DBRPT-bodb_report
	Task: Create temp table rptCustomerMatch_UAT for testing [Redmine: #151151]
*/

USE bodb_report
GO

CREATE TABLE [dbo].[rptCustomerMatch_UAT](
	[custid] [int] NOT NULL,
	[matchid] [int] NULL,
	[oddsid] [int] NULL,
	[Leagueid] [int] NULL,
	[bettype] [smallint] NULL,
	[odds] [money] NULL,
	[oddstype] [tinyint] NULL,
	[statusid] [tinyint] NULL,
	[stake] [money] NULL,
	[winlost] [money] NULL,
	[winlostdate] [datetime] NULL,
	[awinlost] [money] NULL,
	[comm] [money] NULL,
	[playercomm] [money] NULL,
	[recommend] [int] NULL,
	[isBA] [bit] NULL,
	[betcount] [smallint] NULL,
	[currency] [int] NULL,
	[LiveIndicator] [bit] NULL
)
GO

CREATE CLUSTERED INDEX [CIX_Winlostdate] ON [dbo].[rptCustomerMatch_UAT]
(
	[winlostdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
