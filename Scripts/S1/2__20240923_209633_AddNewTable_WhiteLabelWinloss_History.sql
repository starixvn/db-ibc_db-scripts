/*<info serverAlias="DBAGE-bodb02"></info>*/
/*
	Created: 20240923@Danny
	DB: DBAGE.bodb02
	Task: Add new WhiteLabelWinloss_History table RedmineId #209633
*/
USE bodb02
GO

CREATE TABLE [dbo].[WhiteLabelWinloss_History](
	[RowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustID] [int] NOT NULL,
	[Recommend] [int] NOT NULL,
	[MRecommend] [int] NOT NULL,
	[SRecommend] [int] NOT NULL,
	[WinlostDate] [smalldatetime] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[OldWinloss] [money] NULL,
	[NewWinloss] [money] NULL,
	[TypeId] [int]  NULL,
	[GameProviderCode] [varchar](16) NULL,
	[ModifiedDate] [datetime] NULL
) ON DATA
GO

ALTER TABLE [dbo].[WhiteLabelWinloss_History] ADD  DEFAULT (getdate()) FOR [ModifiedDate]


GO
CREATE CLUSTERED INDEX [CIX_WL_History_CustID] ON [dbo].[WhiteLabelWinloss_History]
(
	[CustID] ASC,
	[WinlostDate] ASC,
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
GO

ALTER TABLE WhiteLabelWinloss_History ADD CONSTRAINT PK_WhiteLabelWinlossHistory_RowID PRIMARY KEY (RowID)











