/*<info serverAlias="DBWLB-bodb_WhiteLabel"></info>*/
/*
	Created: 20240923@Danny
	DB: DBWLB.bodb_WhiteLabel
	Task: Add new WhiteLableWinloss table RedmineId #209633
*/
USE bodb_WhiteLabel
GO

CREATE TABLE [dbo].[WhiteLabelWinloss](
	[RowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustID] [int] NOT NULL,
	[Recommend] [int] NOT NULL,
	[MRecommend] [int] NOT NULL,
	[SRecommend] [int] NOT NULL,
	[WinlostDate] [smalldatetime] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[Winloss] DECIMAL(20,6) NULL,
	[TypeId] [int] NULL,
	[GameProviderCode] [varchar](45) NULL,
	[ModifiedDate] [datetime] NULL
) ON DATA WITH
(
DATA_COMPRESSION = PAGE
)
GO

 ALTER TABLE [dbo].[WhiteLabelWinloss] ADD CONSTRAINT [DF_WhiteLabelWinloss_ModifiedDate]  DEFAULT getdate() FOR [ModifiedDate]

GO

ALTER TABLE [dbo].[WhiteLabelWinloss] ADD CONSTRAINT [DF_WhiteLabelWinloss_TypeId]  DEFAULT ((0)) FOR [TypeId]
GO

CREATE CLUSTERED INDEX [CIX_WhiteLabelCustID] ON [dbo].[WhiteLabelWinloss]
(
	[CustID] ASC,
	[WinlostDate] ASC,
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [INDEX]
GO

ALTER TABLE WhiteLabelWinloss ADD CONSTRAINT PK_WhiteLabelWinloss_RowID PRIMARY KEY (RowID)










