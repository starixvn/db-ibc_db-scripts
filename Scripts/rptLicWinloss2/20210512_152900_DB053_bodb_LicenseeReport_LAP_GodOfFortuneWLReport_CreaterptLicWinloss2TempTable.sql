/*<info serverAlias="DB053-bodb_LicenseeReport"></info>*/
/*
	Created: 20210419@Kos
	DB: DB053-bodb_LicenseeReport
	Task: Create temp table rptLicWinloss2_UAT for testing [Redmine: #152900]
*/

USE bodb_LicenseeReport
GO

CREATE TABLE [dbo].[rptLicWinloss2_UAT](
	[keyid] [bigint] IDENTITY(1,1) NOT NULL,
	[winlostdate] [smalldatetime] NULL,
	[username] [nvarchar](50) NULL,
	[username2] [nvarchar](50) NULL,
	[custid] [int] NULL,
	[roleid] [int] NULL,
	[recommend] [int] NULL,
	[mrecommend] [int] NULL,
	[srecommend] [int] NULL,
	[turnover] [money] NULL,
	[winlost] [money] NULL,
	[awinlost] [money] NULL,
	[mwinlost] [money] NULL,
	[swinlost] [money] NULL,
	[playercomm] [money] NULL,
	[comm] [money] NULL,
	[acomm] [money] NULL,
	[scomm] [money] NULL,
	[winlostvirtual] [money] NULL,
	[commvirtual] [money] NULL,
	[BetCount] [int] NULL,
	[Currency] [smallint] NULL,
	[sporttype] [smallint] NOT NULL,
	[bettype] [smallint] NOT NULL,
	[statusID] [smallint] NOT NULL,
	[isBA] [bit] NOT NULL,
	[isMobile] [bit] NOT NULL,
	[betfrom] [nvarchar](1) NOT NULL,
	[BetEffective] [money] NULL,
	[BuyBackAmt] [money] NULL,
	[BABuyBackAmt] [money] NULL
)

GO

ALTER TABLE [dbo].[rptLicWinloss2_UAT] ADD  DEFAULT ('') FOR [betfrom]
GO

ALTER TABLE [dbo].[rptLicWinloss2_UAT] ADD  DEFAULT ((0)) FOR [BetEffective]
GO

CREATE CLUSTERED INDEX [CIX_Winlostdate] ON [dbo].[rptLicWinloss2_UAT]
(
	[winlostdate] ASC,
	[sporttype] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [LicenseeReport_Staging_Data]
GO

