/*<info serverAlias="DBARC-bodb_Archive"></info>*/

/*
Create: 20200717@Sophia
Task: Create table sum_winloss_old_tmp  [Redmine: #137604]
DB: DBARC.bodb_Archive

*/


USE [bodb_Archive]
GO
 
CREATE TABLE [dbo].[sum_winloss_old_tmp](
	[keyid] [bigint] IDENTITY(1,1) NOT NULL,
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
	[BetCount] [int] NULL CONSTRAINT [DF_sum_winloss_old2_BetCount]  DEFAULT ((0)),
	[grosscomm] [money] NULL CONSTRAINT [DF_sum_winloss_old2_grosscomm]  DEFAULT ((0)),
	[sporttype] [smallint] NOT NULL CONSTRAINT [DF_sum_winloss_old2_sporttype]  DEFAULT ((0)),
	[bettype] [smallint] NOT NULL CONSTRAINT [DF_sum_winloss_old2_bettype]  DEFAULT ((0)),
	[netTurnover] [money] NULL,
	[TunroverNoDraw] [money] NULL
)

GO


