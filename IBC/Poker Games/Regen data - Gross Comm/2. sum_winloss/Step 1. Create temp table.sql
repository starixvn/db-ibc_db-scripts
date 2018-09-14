USE [bodb02]
GO

/*
	Created: 20180914@Percy
	DB: DBTXN.bodb02
	Task: Regen data sum_winloss - Step 1: Create temp table
*/

CREATE TABLE dbo.sum_winloss_GrossComm
(
	[winlostdate] [smalldatetime] NULL,
	[username] [nvarchar](50) NULL,
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
	[BetCount] [int] NULL CONSTRAINT [DF_sum_winloss_GrossComm_BetCount]  DEFAULT ((0)),
	[grosscomm] [money] NULL,
	[sporttype] [smallint] NOT NULL CONSTRAINT [DF_sum_winloss_GrossComm_sporttype]  DEFAULT ((0)),
	[bettype] [smallint] NOT NULL CONSTRAINT [DF_sum_winloss_GrossComm_bettype]  DEFAULT ((0)),
	[netTurnover] [money] NULL,
	[TunroverNoDraw] [money] NULL
)