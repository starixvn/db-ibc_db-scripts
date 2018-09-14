USE [bodb_Archive]
GO

/*
	Created: 20180914@Percy
	DB: DBARC.bodb_Archive
	Task: Regen data sum_winloss_old - Step 1: Create temp table
*/

CREATE TABLE dbo.sum_winloss_old_GrossComm
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
	[BetCount] [int] NULL CONSTRAINT [DF_sum_winloss_old_GrossComm_BetCount]  DEFAULT ((0)),
	[grosscomm] [money] NULL CONSTRAINT [DF_sum_winloss_old_GrossComm_grosscomm]  DEFAULT ((0)),
	[sporttype] [smallint] NOT NULL CONSTRAINT [DF_sum_winloss_old_GrossComm_sporttype]  DEFAULT ((0)),
	[bettype] [smallint] NOT NULL CONSTRAINT [DF_sum_winloss_old_GrossComm_bettype]  DEFAULT ((0)),
	[netTurnover] [money] NULL,
	[TunroverNoDraw] [money] NULL
)