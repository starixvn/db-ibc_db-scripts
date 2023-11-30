/*<info serverAlias="DBPTCS-bodb_PlaytechCS" executers="" viewers="" ></info>*/
/*
	Created: 20231130@Evan
	DB: DBLIC-bodb_PlaytechCS
	Task: Create table bettrans_AGCasino_Temp for check data only

*/

USE [bodb_PlaytechCS]
GO

CREATE TABLE [dbo].[bettrans_AGCasino_Temp](
	[TicketID] [bigint] NOT NULL,
	[CustID] [int] NULL,
	[Transdate] [datetime] NULL,
	[GameType] [varchar](10) NULL,
	[Stake] [money] NULL,
	[Actual_Stake] [money] NULL,
	[Winlost] [money] NULL,
	[Status] [nvarchar](10) NULL,
	[StatusID] [int] NULL,
	[PlayType] [smallint] NULL,
	[Winlostdate] [datetime] NULL,
	[Username] [varchar](50) NULL,
	[IP] [varchar](45) NULL,
	[recommend] [int] NULL,
	[mrecommend] [int] NULL,
	[srecommend] [int] NULL,
	[Currency] [tinyint] NULL,
	[tstamp] [timestamp] NULL,
	[IsVIPGame] [bit] NULL,
	[GameCode] [varchar](50) NULL,
 CONSTRAINT [PK_AGCasinoNew_TicketID] PRIMARY KEY CLUSTERED 
(
	[TicketID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PlaytechCS_Data]
) ON [PlaytechCS_Data]
GO


