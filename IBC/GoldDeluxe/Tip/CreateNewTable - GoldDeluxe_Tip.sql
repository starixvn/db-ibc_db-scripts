USE [bodb_PlaytechCS]
GO

/*
	Created: 20181001@Percy
	DB: DB052, DB053, DB054
	Task: Create new table to store raw data of Gold Deluxe Tip
	https://nexdev.net/issues/102624
*/

CREATE TABLE [dbo].[GoldDeluxe_Tip]
(
	[TipId] [varchar](50) NOT NULL,
	[IBCCustId] [int] NULL,
	[Deposit_CustId] [int] NULL,
	[PlayerName] [varchar](50) NULL,
	[TipTime] [datetime] NULL,
	[Amount] [decimal](18, 3) NULL,
	[Currency] [smallint] NULL,
	[AnchorId] [int] NULL,
	[recommend] [int] NULL,
	[mrecommend] [int] NULL,
	[srecommend] [int] NULL,
	[winlostdate] [smalldatetime] NULL,
	CONSTRAINT [PK_GoldDeluxe_Tip] PRIMARY KEY NONCLUSTERED 
	(
		[TipId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PlaytechCS_Data]
) ON [PlaytechCS_Data]

GO

CREATE CLUSTERED INDEX CIX_WinlostDate ON [dbo].[GoldDeluxe_Tip] (winlostdate)
GO