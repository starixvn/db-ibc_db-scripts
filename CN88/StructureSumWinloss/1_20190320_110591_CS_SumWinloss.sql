USE [bodb_Summary]
GO

/*
Create: 20190320@Sophia
Task:  Structure Sum Winloss CS_SumWinloss - CN88 [redmind: 105660]

*/

ALTER DATABASE bodb_Summary ADD filegroup [CS_SumWinloss]

ALTER DATABASE bodb_Summary ADD FILE (name = 'CS_SumWinloss', filename ='D:\IBC_DB\bodb_Summary\CS_SumWinloss\CS_SumWinloss.ndf', 
SIZE = 1 MB ,FILEGROWTH = 16 MB ) TO filegroup [CS_SumWinloss]
 
-----------1. [CS_SumWinloss]

CREATE TABLE [dbo].[CS_SumWinloss](
	[CustID] [int] NOT NULL,
	[WinlostDate] [smalldatetime] NOT NULL,
	[ProductId] [smallint] NOT NULL,
	[Sporttype] [smallint] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[Wagers] [int] NULL,
	[Stake] [money] NULL,
	[ValidStake] [money] NULL,
	[MemberWinloss] [money] NULL,
	[MemberComm] [money] NULL,
	[Agent] [money] NULL,
	[AgentWinloss] [money] NULL,
	[AgentComm] [money] NULL,
	[AgentStock] [money] NULL,
	[AgentResultA] [money] NULL,
	[Master] [money] NULL,
	[MasterWinloss] [money] NULL,
	[MasterComm] [money] NULL,
	[MasterStock] [money] NULL,
	[Super] [money] NULL,
	[SuperWinloss] [money] NULL,
	[SuperComm] [money] NULL,
	[SuperStock] [money] NULL,
	[HeadlineWinloss] [money] NULL,
	[HeadlineComm] [money] NULL,
	[HeadlineStock] [money] NULL,
	[HeadlineId] [int] NULL
) ON [CS_SumWinloss]
GO

 
CREATE CLUSTERED INDEX [CIX_CS_SumWinloss] ON [dbo].[CS_SumWinloss]
(
	CustID ASC,
	WinlostDate ASC,				
	Sporttype ASC,
	Bettype ASC,
	IsLive ASC
) ON [CS_SumWinloss]
GO
 
			

GRANT SELECT ON [CS_SumWinloss] TO bodbDownlineNet
GO 

GRANT SELECT ON [CS_SumWinloss] TO bodbDownlineNetView
GO
  

