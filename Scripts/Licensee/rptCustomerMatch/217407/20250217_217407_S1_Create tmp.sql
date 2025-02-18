/*<info serverAlias="DBRPT-bodb_report"></info>*/
/*
	Created: 20250217@Kelvin
	DB: DBRPT-bodb_report
	Task: Regen data on rptCustomerMatch[Redmine: #217407]
		S1: Create temp table rptCustomerMatch_staging_217407
*/

USE bodb_report
GO

CREATE TABLE [dbo].[rptCustomerMatch_staging_217407](
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
	[LiveIndicator] [bit] NULL,
	[TicketType] [tinyint] NULL
)

GO

CREATE CLUSTERED INDEX [CIX_Winlostdate] ON [dbo].[rptCustomerMatch_staging_217407]
(
	[winlostdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
