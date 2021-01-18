/*<info serverAlias="DBARC-bodb_Archive" isFunction="0" isNested=""></info>*/
/*
	Created: 2021018@Danny
	DB: DBARC.bodb_Archive
	Task: PRMS - Create staging table structure 
*/

	
CREATE TABLE [dbo].[rmSumWinloss_Old](
	[winlostdate] [smalldatetime] NOT NULL,
	[custid] [int] NOT NULL,
	[sporttype] [smallint] NULL,
	[statusid] [tinyint] NOT NULL,
	[combo] [tinyint] NOT NULL,
	[username] [varchar](30) NOT NULL,
	[currency] [tinyint] NULL,
	[stake] [money] NULL,
	[winlost] [money] NULL,
	[company_stake] [money] NULL,
	[company_winlost] [money] NULL,
	[actualrate] [float] NULL,
	[odds] [smallmoney] NULL,
	[betcount] [int] NULL,
	[recommend] [int] NULL,
	[parlaytype] [tinyint] NULL,
	[scomm] [money] NULL,
	[Extra_comm] [money] NULL,
	[Extra_stake] [money] NULL,
	[Extra_winlost] [money] NULL,
	[mrecommend] [int] NULL,
	[srecommend] [int] NULL,
	[awinlost] [money] NULL,
	[mwinlost] [money] NULL,
	[swinlost] [money] NULL,
	[actual_stake] [money] NULL,
	[playercomm] [money] NULL,
	[comm] [money] NULL,
	[acomm] [money] NULL
) --ON [rmSumWinlossOld]



CREATE CLUSTERED INDEX [CIX_rmSumWinloss_OLD] ON [dbo].[rmSumWinloss_Old]
(
	[custid] ASC,
	[winlostdate] ASC,
	[sporttype] ASC,
	[statusid] ASC,
	[combo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) --ON [rmSumWinlossOld]
GO


CREATE NONCLUSTERED INDEX [IX_Winlostdate] ON [dbo].[rmSumWinloss_Old]
(
	[winlostdate] ASC
)
INCLUDE([currency],[stake],[winlost],[company_stake],[company_winlost],[actualrate],[betcount],[parlaytype],[combo],[sporttype],[statusid],[custid],[username],[srecommend],[awinlost],[mwinlost],[swinlost],[actual_stake],[playercomm],[comm],[acomm]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) --ON [rmSumWinlossOld]
GO

