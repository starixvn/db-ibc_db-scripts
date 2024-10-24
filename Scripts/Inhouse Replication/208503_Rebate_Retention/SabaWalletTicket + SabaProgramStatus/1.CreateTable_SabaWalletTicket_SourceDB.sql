/*<info serverAlias="DBSIC-bodb02"></info>*/
/*
	Created: 20240911@Lewis
	DB: DBSIC-bodb02
	Task: Rebate and Retention for Credit players [RedmineID: #208503]
*/
USE [bodb02]
GO

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
	[WalletId] [tinyint] NULL,
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
	[SiteDBGroupId] [smallint] NULL,
	[RepUpdateTime] [datetime2](7) NULL,
	[IsReversed] [bit] NULL,
	[RefNo] [bigint] NULL,
	[SId] [smallint] NULL,

CONSTRAINT [PK_SabaWalletTicket_TransId] PRIMARY KEY CLUSTERED
(
	[TransId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Transfer_Index]
) ON [Transfer_Table]
GO

ALTER TABLE [dbo].[SabaWalletTicket] ADD CONSTRAINT [DF_SabaWalletTicket_TransDate] DEFAULT (getdate()) FOR [TransDate]
GO

ALTER TABLE [dbo].[SabaWalletTicket] ADD CONSTRAINT [DF_SabaWalletTicket_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime]
GO

------Index
CREATE NONCLUSTERED INDEX [IX_SabaWalletTicket_RepUpdateTime] ON [dbo].[SabaWalletTicket]
(
	[RepUpdateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Transfer_Index]
GO

CREATE NONCLUSTERED INDEX [IX_SabaWalletTicket_ProgramId] ON [dbo].[SabaWalletTicket]
(
	[ProgramId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Transfer_Index]
GO

--------table_Del_Inhouse
CREATE TABLE [dbo].[SabaWalletTicket_Del_InHouse](
	[TransId] [bigint] NOT NULL,
	[RepUpdateTime] [datetime2](7) NULL) ON [Transfer_Table]
GO

ALTER TABLE [dbo].[SabaWalletTicket_Del_InHouse] ADD CONSTRAINT [DF_SabaWalletTicket_Del_InHouse_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime] 
GO

CREATE CLUSTERED INDEX CIX_SabaWalletTicket_Del_InHouse ON SabaWalletTicket_Del_InHouse([RepUpdateTime]) ON [Transfer_Index]
GO

--=====================
-- [SabaProgramStatus]
--=====================

CREATE TABLE [dbo].[SabaProgramStatus](
	[SId] [int] NOT NULL IDENTITY(1,1),
	[ProgramId] [smallint] NOT NULL,
	[SiteDBGroupId] [smallint] NOT NULL,
	[StatusId] [tinyint] NULL,
	[IsNotified] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[RepUpdateTime] [datetime2](7) NULL,
		
CONSTRAINT [PK_SabaProgramStatus_SId_SiteDBGroupId] PRIMARY KEY CLUSTERED(
	SId, SiteDBGroupId
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Transfer_Index]
) 
ON [Transfer_Table]
GO

ALTER TABLE [dbo].[SabaProgramStatus] ADD CONSTRAINT [DF_SabaProgramStatus_CreatedDate] DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[SabaProgramStatus] ADD CONSTRAINT [DF_SabaProgramStatus_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime]
GO

CREATE NONCLUSTERED INDEX [IX_SabaProgramStatus_IsNotified_ProgramId] ON [dbo].[SabaProgramStatus]
(
	[IsNotified],[ProgramId]
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Transfer_Index]
GO

--------table_Del_Inhouse
CREATE TABLE [dbo].[SabaProgramStatus_Del_InHouse](
	[SId] [int] NOT NULL,
	[SiteDBGroupId] [smallint] NOT NULL,
	[RepUpdateTime] [datetime2](7) NULL) ON [Transfer_Table]
GO

CREATE CLUSTERED INDEX CIX_SabaProgramStatus_Del_InHouse ON SabaProgramStatus_Del_InHouse([RepUpdateTime]) ON [Transfer_Index]
GO
ALTER TABLE [dbo].[SabaProgramStatus_Del_InHouse] ADD CONSTRAINT [DF_SabaProgramStatus_Del_InHouse_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime]
GO