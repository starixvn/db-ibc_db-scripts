USE [bodb02]
GO


/*
Create: 20191023@Sophia
DB: DB061.bodb02
Task: Add bettrans_test for UAt test [redmine: 117863]


*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
CREATE TABLE [dbo].[bettrans_test](
	[transid] [bigint] IDENTITY(333242000,1)  NOT NULL,
	[custid] [int] NOT NULL,
	[transdate] [datetime] NOT NULL,
	[oddsid] [int] NOT NULL,
	[hdp1] [smallmoney] NULL,
	[hdp2] [smallmoney] NULL,
	[odds] [smallmoney] NULL,
	[stake] [money] NOT NULL,
	[status] [nvarchar](10) NULL,
	[winlost] [money] NULL,
	[awinlost] [money] NULL,
	[mwinlost] [money] NULL,
	[playercomm] [money] NULL,
	[comm] [money] NULL,
	[acomm] [money] NULL,
	[apositiontaking] [smallmoney] NULL,
	[mpositiontaking] [smallmoney] NULL,
	[tpositiontaking] [smallmoney] NULL,
	[playerdiscount] [decimal](9, 8) NULL,
	[discount] [decimal](9, 8) NULL,
	[adiscount] [decimal](9, 8) NULL,
	[livehomescore] [smallint] NULL,
	[liveawayscore] [smallint] NULL,
	[liveindicator] [bit] NULL,
	[betteam] [nvarchar](10) NULL,
	[creator] [int] NOT NULL,
	[refno] [bigint] NOT NULL,
	[comstatus] [nvarchar](20) NULL,
	[winlostdate] [smalldatetime] NULL,
	[betfrom] [nvarchar](1) NULL,
	[betcheck] [nvarchar](50) NULL,
	[checktime] [datetime] NULL,
	[oddsspread] [money] NULL,
	[actualrate] [float] NULL,
	[matchid] [int] NULL,
	[recommend] [int] NOT NULL,
	[mrecommend] [int] NOT NULL,
	[ruben] [tinyint] NULL,
	[betid] [bigint] NULL,
	[statuswinlost] [tinyint] NULL,
	[modds] [smallmoney] NULL,
	[bettype] [smallint] NULL,
	[betdaqid] [bigint] NULL,
	[tstamp] [timestamp] NULL,
	[actual_stake] [money] NULL,
	[currency] [tinyint] NULL,
	[ip] [nvarchar](15) NULL,
	[transdesc] [nvarchar](1000) NULL,
	[sdiscount] [decimal](9, 8) NULL,
	[scomm] [money] NULL,
	[spositiontaking] [smallmoney] NULL,
	[swinlost] [money] NULL,
	[srecommend] [int] NOT NULL,
	[Username] [nvarchar](50) NULL,
	[CurrencyName] [nvarchar](50) NULL,
	[virtualrate] [float] NOT NULL,
	[oddstype] [tinyint] NULL,
	[statusID] [tinyint] NULL,
	[currency2] [tinyint] NULL,
	[balance] [money] NULL,
	[SecAcceptFlag] [bit] NULL,
	[transid2] [bigint] NULL,
	[RecommDate] [datetime] NULL,
	[ExtraInfo] [varchar](1000) NULL,
	[WalletType] [tinyint] NULL,
	[BonusID] [int] NULL,
	[RefCode] [bigint] NULL,
	[SettlementTime] [datetime] NULL,
	[epositiontaking] [smallmoney] NULL,
 CONSTRAINT [PK_bettrans_test_test] PRIMARY KEY NONCLUSTERED 
(
	[transid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [Bettrans_index3]
) ON [Bettrans_table]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_transdate]  DEFAULT (getdate()) FOR [transdate]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_oddsid]  DEFAULT ((0)) FOR [oddsid]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_hdp1]  DEFAULT ((0)) FOR [hdp1]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_hdp2]  DEFAULT ((0)) FOR [hdp2]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_odds]  DEFAULT ((0)) FOR [odds]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_stake]  DEFAULT ((0)) FOR [stake]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_winlost]  DEFAULT ((0)) FOR [winlost]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_awinlost]  DEFAULT ((0)) FOR [awinlost]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_mwinlost]  DEFAULT ((0)) FOR [mwinlost]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_playercomm]  DEFAULT ((0)) FOR [playercomm]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_comm]  DEFAULT ((0)) FOR [comm]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_acomm]  DEFAULT ((0)) FOR [acomm]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_apositiontaking]  DEFAULT ((0)) FOR [apositiontaking]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_mpositiontaking]  DEFAULT ((0)) FOR [mpositiontaking]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_tpositiontaking]  DEFAULT ((0)) FOR [tpositiontaking]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_playerdiscount]  DEFAULT ((0)) FOR [playerdiscount]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_discount]  DEFAULT ((0)) FOR [discount]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_adiscount]  DEFAULT ((0)) FOR [adiscount]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_livehomescore]  DEFAULT ((0)) FOR [livehomescore]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_liveawayscore]  DEFAULT ((0)) FOR [liveawayscore]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_liveindicator]  DEFAULT ((0)) FOR [liveindicator]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_creator]  DEFAULT ((0)) FOR [creator]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_comstatus]  DEFAULT ('s') FOR [comstatus]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_winlostdate]  DEFAULT (getdate()) FOR [winlostdate]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_betfrom]  DEFAULT ('i') FOR [betfrom]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_betcheck]  DEFAULT ((0)) FOR [betcheck]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_ruben]  DEFAULT ((0)) FOR [ruben]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_modds]  DEFAULT ((1)) FOR [modds]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_actual_stake]  DEFAULT ((0)) FOR [actual_stake]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_scomm]  DEFAULT ((0)) FOR [scomm]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_spositiontaking]  DEFAULT ((0)) FOR [spositiontaking]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_swinlost]  DEFAULT ((0)) FOR [swinlost]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_virtualrate]  DEFAULT ((0)) FOR [virtualrate]
GO

ALTER TABLE [dbo].[bettrans_test] ADD  CONSTRAINT [DF_bettrans_test_epositiontaking]  DEFAULT ((0)) FOR [epositiontaking]
GO


