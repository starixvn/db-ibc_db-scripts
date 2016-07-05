/*
	Created by: Elodie
	Created Date: 20160630
	Description: Bet Monitoring tool
	Database: DBACC/bodb_ACC
	
	Local Test: D:\DB233\IBC_DB\CustDB
	Local Dev: D:\SQLSERVER2008R2\IBC_DB\CustDB
	Production: H:\USER_DB\CustDB
		
*/
USE bodb_ACC
GO

CREATE TABLE [dbo].[BetMonitoring_Setting](
	[SettingID] [tinyint] NOT NULL,
	[SettingName] [varchar](50) NOT NULL,
	[Value] [VARCHAR](200) NOT NULL
 CONSTRAINT [PK_BetMonitoring_Setting] PRIMARY KEY CLUSTERED 
(
	[SettingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [accData]
) ON [accData]

GO
CREATE TABLE [dbo].[BetMonitoring_CustTotalBet](
	[CustID] [int] NOT NULL,
	[SportType] [tinyint] NOT NULL,
	[BetCount] [int] NOT NULL,
	[ModifiedDate] [smalldatetime] NOT NULL,
	[tstamp] [TIMESTAMP] NOT NULL
 CONSTRAINT [PK_BetMonitoring_CustTotalBet] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [accData]
) ON [accData]

GO
CREATE TABLE [dbo].[BetMonitoring_CustTotalBet_History](
	[CustID] [int] NOT NULL,
	[SportType] [tinyint] NOT NULL,
	[BetCount] [int] NOT NULL,
	[TotalBet] [int] NOT NULL,
	[Threshold] [tinyint] NOT NULL,
	[NotifiedStatus] [TINYINT] NOT NULL,
	[ModifiedDate] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_BetMonitoring_CustTotalBet_History] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[SportType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [accData]
) ON [accData]

GO

CREATE NONCLUSTERED INDEX IX_BetMonitoring_CustTotalBet_NotifiedStatus ON BetMonitoring_CustTotalBet_History (NotifiedStatus) INCLUDE (CustID, SportType)