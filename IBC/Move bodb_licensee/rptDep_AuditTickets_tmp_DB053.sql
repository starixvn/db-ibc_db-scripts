USE [bodb_LicenseeReportArchive]
GO

CREATE TABLE [dbo].[rptDep_AuditTickets_tmp](
	[PlayerNo] [int] NOT NULL,
	[PlayerName] [varchar](100) NULL,
	[PlayerType] [varchar](10) NULL,
	[TransactionDate] [datetime] NULL,
	[TransactionId] [bigint] NOT NULL,
	[SettlementDate] [datetime] NOT NULL,
	[Brand] [varchar](50) NULL,
	[BrandUrl] [varchar](100) NULL,
	[GameCode] [varchar](10) NULL,
	[GameName] [varchar](100) NULL,
	[GameType] [varchar](50) NOT NULL,
	[CurrencyCode] [varchar](10) NULL,
	[BetType] [varchar](100) NULL,
	[BetAmount] [money] NULL,
	[DebitAmount] [money] NULL,
	[CreditAmount] [money] NULL,
	[NetAmount] [money] NULL,
	[WinLostDate] [date] NULL,
 CONSTRAINT [PK_rptDep_AuditTickets_tmp] PRIMARY KEY NONCLUSTERED 
(
	[TransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BATrans_Index]
) ON [BATrans_Data]

GO

CREATE CLUSTERED INDEX [CIX_WinLostDate] ON [dbo].[rptDep_AuditTickets_tmp]
(
	[WinLostDate] ASC,
	[Brand] ASC,
	[CurrencyCode] ASC,
	[GameType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [BATrans_Data]
GO


