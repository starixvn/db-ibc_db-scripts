/*<info serverAlias="DBRMS-bodb_RMS"></info>*/
/*
	Created: 20201102@Danny
	DB: DBRMS.bodb_RMS
	Task: PRMS - Create table structure [redmine: #145926]
*/
BEGIN

CREATE TABLE [dbo].[rmBettrans_UAT](
	[transid] [bigint] NOT NULL,
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
	[oddsspread] [smallmoney] NULL,
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
	[combo] [int] NULL,
	[odds2] [money] NULL,
	[TotalBet] [int] NULL,
	[epositiontaking] [smallmoney] NULL
)
GO

CREATE CLUSTERED INDEX [CIX_rmBettrans] ON [dbo].[rmBettrans_uat]
(
	[transid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO


CREATE NONCLUSTERED INDEX [IX_recommend] ON [dbo].[rmBettrans_uat]
(
	[recommend] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
GO


CREATE NONCLUSTERED INDEX [IX_transdate_IP] ON [dbo].[rmBettrans_uat]
(
	[transdate] ASC,
	[ip] ASC
)
INCLUDE([custid],[liveawayscore]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [IX_winlostdate_matchid_statusid] ON [dbo].[rmBettrans_uat]
(
	[winlostdate] ASC,
	[custid] ASC,
	[matchid] ASC,
	[statusID] ASC
)
INCLUDE([stake],[actualrate],[bettype],[betcheck],[hdp2],[tpositiontaking],[winlost],[actual_stake],[transid2],[currency],[betteam],[srecommend],[scomm],[Username]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
GO
---------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[rmBettrans_Old_UAT](
	[transid] [bigint] NOT NULL,
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
	[oddsspread] [smallmoney] NULL,
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
	[combo] [int] NULL,
	[odds2] [money] NULL,
	[TotalBet] [int] NULL,
	[epositiontaking] [smallmoney] NULL,
 CONSTRAINT [PK_rmBettrans_Old_UAT] PRIMARY KEY NONCLUSTERED 
(
	[transid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
) 
GO


CREATE CLUSTERED INDEX [CIX_winlostdate_bettype_statusID] ON [dbo].[rmBettrans_Old_UAT]
(
	[winlostdate] ASC,
	[bettype] ASC,
	[statusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[rmSumWinloss_UAT](
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
	) ON [rmSumWinloss]
	GO


	CREATE CLUSTERED INDEX [CIX_rmSumWinloss] ON [dbo].[rmSumWinloss_UAT]
	(
		[custid] ASC,
		[winlostdate] ASC,
		[sporttype] ASC,
		[statusid] ASC,
		[combo] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmSumWinloss]
	GO

	CREATE NONCLUSTERED INDEX [IX_recommend] ON [dbo].[rmSumWinloss_UAT]
	(
		[recommend] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	GO


	CREATE NONCLUSTERED INDEX [IX_Winlostdate] ON [dbo].[rmSumWinloss_UAT]
	(
		[winlostdate] ASC
	)
	INCLUDE([currency],[stake],[winlost],[company_stake],[company_winlost],[actualrate],[betcount],[parlaytype],[combo],[sporttype],[statusid],[custid],[username],[srecommend],[awinlost],[mwinlost],[swinlost],[actual_stake],[playercomm],[comm],[acomm]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmSumWinloss]
	GO

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
	
CREATE TABLE [dbo].[rmSumWinloss_Old_UAT](
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
) ON [rmSumWinlossOld]
GO


CREATE CLUSTERED INDEX [CIX_rmSumWinloss_OLD] ON [dbo].[rmSumWinloss_Old_UAT]
(
	[custid] ASC,
	[winlostdate] ASC,
	[sporttype] ASC,
	[statusid] ASC,
	[combo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmSumWinlossOld]
GO


CREATE NONCLUSTERED INDEX [IX_recommend] ON [dbo].[rmSumWinloss_Old_UAT]
(
	[recommend] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Winlostdate] ON [dbo].[rmSumWinloss_Old_UAT]
(
	[winlostdate] ASC
)
INCLUDE([currency],[stake],[winlost],[company_stake],[company_winlost],[actualrate],[betcount],[parlaytype],[combo],[sporttype],[statusid],[custid],[username],[srecommend],[awinlost],[mwinlost],[swinlost],[actual_stake],[playercomm],[comm],[acomm]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [rmSumWinlossOld]
GO


