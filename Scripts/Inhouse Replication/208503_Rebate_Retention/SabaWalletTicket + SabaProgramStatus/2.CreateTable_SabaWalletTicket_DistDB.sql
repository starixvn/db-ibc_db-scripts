/*<info serverAlias="DBRepl-ReplDB,IRS_DBTP-bodb02"></info>*/
/*
	Created: 20240911@Lewis
	DB: DBRepl-ReplDB,IRS_DBTP-bodb02
	Task: Rebate and Retention for Credit players [RedmineID: #208503]
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--=====================
-- [SabaWalletTicket]
--=====================
CREATE TABLE [dbo].[SabaWalletTicket](
	[TransId] [bigint] NOT NULL,
	[CustID] [int] NULL,
	[Recommend] [int] NULL,
	[Mrecommend] [int] NULL,
	[Srecommend] [int] NULL,
	[CurrencyID] [int] NULL,
	[ActualRate] [float] NULL,
	[Amount] [money] NULL,
	[TransDate] [datetime] NULL,
	[WinlostDate] [smalldatetime] NULL,
	[WalletID] [tinyint] NULL,
	[StatusId] [tinyint] NULL,
	[TransDesc] [nvarchar](4000) NULL,
	[ProgramId] [smallint] NULL,
	[PaymentStatus] [tinyint] NULL, 
	[APaymentDate] [date] NULL,
	[MPaymentDate] [date] NULL,
	[SPaymentDate] [date] NULL,
	[HPaymentDate] [date] NULL,
	[IsComplaint] [bit] NULL,
	[Creator] [int] NULL,
	[SiteDBGroupID] [smallint] NULL,
	[RepUpdateTime] [datetime2](7) NULL,
	[IsReversed] [bit] NULL,
	[RefNo] [bigint] NULL,
	[SId] [smallint] NULL,
	[IsDeleted] [bit] NULL,

CONSTRAINT [PK_SabaWalletTicket_TransId] PRIMARY KEY CLUSTERED 
(
	[TransId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO

ALTER TABLE [dbo].[SabaWalletTicket] ADD CONSTRAINT [DF_SabaWalletTicket_TransDate] DEFAULT (getdate()) FOR [TransDate]
GO

ALTER TABLE [dbo].[SabaWalletTicket] ADD  CONSTRAINT [DF_SabaWalletTicket_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime]
GO

CREATE NONCLUSTERED INDEX [IX_SabaWalletTicket_RepUpdateTime] ON [dbo].[SabaWalletTicket]
(
	[RepUpdateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
GO

CREATE NONCLUSTERED INDEX [IX_SabaWalletTicket_ProgramId] ON [dbo].[SabaWalletTicket]
(
	[ProgramId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
GO
