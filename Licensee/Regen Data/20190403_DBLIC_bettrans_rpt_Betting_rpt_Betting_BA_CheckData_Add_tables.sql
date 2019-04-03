USE [bodb_LicenseeReport]
GO

/*
	Created: 20190403@Percy
	DB: DBLIC.bodb_LicenseeReport
	Task: Create tables for troubleshoot data issue
		bettrans (staging)
		rpt_Betting
		rpt_Betting_BA
*/

-- bettrans_CheckData
CREATE TABLE [dbo].[bettrans_CheckData]
(
	[transid] [bigint] NOT NULL,
	[custid] [int] NOT NULL,
	[stake] [money] NOT NULL,
	[statusid] [tinyint] NULL,
	[status] [nvarchar](15) NULL,
	[winlost] [money] NULL,
	[awinlost] [money] NULL,
	[mwinlost] [money] NULL,
	[playercomm] [money] NULL,
	[comm] [money] NULL,
	[acomm] [money] NULL,
	[apositiontaking] [smallmoney] NULL,
	[mpositiontaking] [smallmoney] NULL,
	[tpositiontaking] [smallmoney] NULL,
	[liveindicator] [bit] NULL,
	[betteam] [nvarchar](10) NULL,
	[winlostdate] [smalldatetime] NULL,
	[betfrom] [nvarchar](1) NULL,
	[actualrate] [float] NULL,
	[matchid] [int] NULL,
	[recommend] [int] NOT NULL,
	[mrecommend] [int] NOT NULL,
	[actual_stake] [money] NULL,
	[currency] [tinyint] NULL,
	[scomm] [money] NULL,
	[spositiontaking] [smallmoney] NULL,
	[swinlost] [money] NULL,
	[srecommend] [int] NOT NULL,
	[refno] [bigint] NULL,
	[transdate] [datetime] NULL,
	[bettype] [smallint] NULL,
	[virtualrate] [float] NULL,
	[isBA] [bit] NULL,
	[discount] [decimal](9, 8) NULL,
	[customercategory] [smallint] NULL,
	[site] [varchar](10) NULL,
	[CashInAmount] [money] NULL,
	[WinPrizeAmount] [money] NULL,
	[CashOutAmount] [money] NULL,
	[oddsspread] [money] NULL,
	[ExtraInfo] [varchar](1000) NULL,
	[betdaqid] [bigint] NULL,
	[hdp2] [smallmoney] NULL,
	[TicketType] [tinyint] NULL,
	CONSTRAINT [PK_bettrans_CheckData] PRIMARY KEY CLUSTERED 
	(
		[transid] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [LicenseeReport_Staging_Data]
) ON [LicenseeReport_Staging_Data]
GO

-- rpt_Betting_CheckData
CREATE TABLE [dbo].[rpt_Betting_CheckData]
(
	[RecordID] [bigint] NOT NULL,
	[rptDate] [datetime] NOT NULL,
	[SiteID] [int] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[LeagueID] [int] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[Status] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[BetCount] [int] NULL,
	[MemberCount] [int] NULL,
	[Turnover] [money] NULL,
	[WinLoss] [money] NULL,
	[WinLossA] [money] NULL,
	[WinLossM] [money] NULL,
	[WinLossS] [money] NULL,
	[CommissionP] [money] NULL,
	[CommissionA] [money] NULL,
	[CommissionM] [money] NULL,
	[CommissionS] [money] NULL,
	[WinLossVirtual] [money] NULL,
	[CommissionSVirtual] [money] NULL,
	[CustomerCategory] [smallint] NULL,
	[BuyBackAmount] [money] NULL,
	[WinPrizeAmount] [money] NULL,
	[CashOutAmount] [money] NULL,
	[oddsspread] [money] NULL,
	[ExtraAmount] [money] NULL,
	[TicketType] [tinyint] NULL
)
GO

-- rpt_Betting_BA_CheckData
CREATE TABLE [dbo].[rpt_Betting_BA_CheckData]
(
	[RecordID] [bigint] NOT NULL,
	[rptDate] [datetime] NOT NULL,
	[SiteID] [int] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[LeagueID] [int] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[Status] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[BetCount] [int] NULL,
	[MemberCount] [int] NULL,
	[Turnover] [money] NULL,
	[WinLoss] [money] NULL,
	[WinLossA] [money] NULL,
	[WinLossM] [money] NULL,
	[WinLossS] [money] NULL,
	[CommissionP] [money] NULL,
	[CommissionA] [money] NULL,
	[CommissionM] [money] NULL,
	[CommissionS] [money] NULL,
	[WinLossVirtual] [money] NULL,
	[CommissionSVirtual] [money] NULL,
	[BuyBackAmount] [money] NULL,
	[CustomerCategory] [smallint] NULL,
	[TicketPayout] [money] NULL,
	[ExtraAmount] [money] NULL,
	[TicketType] [tinyint] NULL
) ON [rptBetting_ba_Data]
GO