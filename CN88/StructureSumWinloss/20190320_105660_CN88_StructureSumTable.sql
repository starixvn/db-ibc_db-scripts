USE [bodb_Summary]
GO

/*
Create: 20190320@Sophia
Task:  Structure Sum Winloss - CN88 [redmind: 105660]

*/



 
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
	[HeadlineId] [int] NULL,
	CONSTRAINT  [PK_CS_SumWinloss] PRIMARY KEY NONCLUSTERED
				(CustID,
				WinlostDate,				
				Sporttype,
				Bettype,
				IsLive) ON [DATA]
) ON [DATA]
GO


GRANT SELECT ON [CS_SumWinloss] TO bodbDownlineNet
GO 

GRANT SELECT ON [CS_SumWinloss] TO bodbDownlineNetView
GO
 
 
----------------3. [CS_SumCancelled]
  
CREATE TABLE [dbo].[CS_SumCancelled](
	CustID			Int
	,WinlostDate	Smalldatetime
	,ProductId		smallint
	,Sporttype		smallint
	,Bettype		smallint
	,IsLive			bit
	,CancelType     TINYINT
	,Wagers			int
	,Stake			Money
	,HeadlineId		int,
	CONSTRAINT  [PK_CS_SumCancelled] PRIMARY KEY NONCLUSTERED 
				(CustID,
				WinlostDate,
				ProductId,
				Sporttype,
				Bettype,
				IsLive,
				CancelType) ON [DATA]
	)
	ON [DATA]
GO 

GRANT SELECt ON [CS_SumCancelled] TO bodbDownlineNetView
GO

GRANT SELECt ON [CS_SumCancelled] TO bodbDownlineNet
GO

