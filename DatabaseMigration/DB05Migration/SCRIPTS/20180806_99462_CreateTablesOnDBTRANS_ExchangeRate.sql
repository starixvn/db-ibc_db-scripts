/*
	Created: 20180806@Helen
	Task: DB05.DBPOLICY migration - [Redmine:99462]
	SERVER: DBTXN/bodb02
*/
USE [bodb02]
GO
CREATE TABLE [dbo].[Acc_ExchangeRate](
	[FromExchangeID] [int] NOT NULL,
	[ToExchangeID] [int] NOT NULL,
	[MinActualRate] [smallmoney] NOT NULL,
	[MaxActualRate] [smallmoney] NOT NULL,
	[Creator] [int] NOT NULL,
	[LastUpdate] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_Acc_ExchangeRate] PRIMARY KEY CLUSTERED 
(
	[FromExchangeID] ASC,
	[ToExchangeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
ALTER TABLE [dbo].[Acc_ExchangeRate] ADD  CONSTRAINT [DF_Acc_ExchangeRate_lastupdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO

CREATE TABLE [dbo].[Acc_ExchangeRate_History](
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[ActionDate] [datetime] NOT NULL,
	[ActionType] [smallint] NOT NULL,
	[UserID] [int] NOT NULL,
	[FromExchangeID] [int] NOT NULL,
	[ToExchangeID] [int] NOT NULL,
	[MinActualRate] [smallmoney] NOT NULL,
	[MaxActualRate] [smallmoney] NOT NULL,
 CONSTRAINT [PK_Acc_ExchangeRate_history] PRIMARY KEY CLUSTERED 
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: insert, 2: update, 3: delete' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Acc_ExchangeRate_History', @level2type=N'COLUMN',@level2name=N'ActionType'
GO
CREATE TABLE [dbo].[Acc_ExchangeRate_InvalidTransfer](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[TransDate] [datetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[FromCust] [int] NOT NULL,
	[ToCust] [int] NOT NULL,
	[FromExchangeID] [int] NOT NULL,
	[ToExchangeID] [int] NOT NULL,
	[Rate] [float] NOT NULL,
	[MinExRate] [float] NOT NULL,
	[MaxExRate] [float] NOT NULL,
	[ExRate] [float] NOT NULL,
	[Amount] [money] NOT NULL,
	[RefNo] [bigint] NOT NULL,
	[IsDeleted] [bit] NOT NULL
) ON [DATA]

GO
ALTER TABLE [dbo].[Acc_ExchangeRate_InvalidTransfer] ADD  CONSTRAINT [DF_Acc_ExchangeRate_InvalidTransfer_TransDate]  DEFAULT (getdate()) FOR [TransDate]
GO
ALTER TABLE [dbo].[Acc_ExchangeRate_InvalidTransfer] ADD  CONSTRAINT [DF_Acc_ExchangeRate_InvalidTransfer_RefNo]  DEFAULT ((0)) FOR [RefNo]
GO
ALTER TABLE [dbo].[Acc_ExchangeRate_InvalidTransfer] ADD  CONSTRAINT [DF_Acc_ExchangeRate_InvalidTransfer_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO




