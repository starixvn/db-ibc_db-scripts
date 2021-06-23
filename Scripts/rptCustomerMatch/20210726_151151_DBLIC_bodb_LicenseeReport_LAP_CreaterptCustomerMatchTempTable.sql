/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20210622@Kos
	DB: DBLIC-bodb_LicenseeReport
	Task: Create temp table rptCustomerMatch_UAT for testing [Redmine: #151151]
*/

USE bodb_LicenseeReport
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
