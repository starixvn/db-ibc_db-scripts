USE [master]
GO
ALTER DATABASE [bodb_Account] ADD FILEGROUP [mcCustNumGameDaily]
GO
ALTER DATABASE [bodb_Account] ADD FILE ( NAME = N'mcCustNumGameDaily', FILENAME = N'D:\IBC_DB\bodb_Account\mcCustNumGameDaily.ndf' , SIZE = 1048576KB , FILEGROWTH = 32768KB ) TO FILEGROUP [mcCustNumGameDaily]
GO

USE [bodb_Account]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[mcCustNumGameDaily_tmp](
	[rptDate] [date] NOT NULL,
	[CustID] [int] NOT NULL,
	[recommend] [int] NOT NULL,
	[mrecommend] [int] NOT NULL,
	[srecommend] [int] NOT NULL,
	[SiteID] [smallint] NOT NULL,
	[currency] [tinyint] NOT NULL,
	[isLive] [bit] NOT NULL,
	[bettype] [smallint] NOT NULL,
	[leagueid] [int] NOT NULL,
	[matchid] [int] NOT NULL,
	[status] [tinyint] NOT NULL,
	[Actual_Stake] [money] NULL,
	[Stake] [money] NULL,
	[StakeH] [money] NULL,
	[StakeA] [money] NULL,
	[WinlossIBC] [money] NULL,
	[WinlossS] [money] NULL,
	[WinlossM] [money] NULL,
	[WinlossA] [money] NULL,
	[WinlossP] [money] NULL,
	[WinlossIBCVirtual] [money] NULL,
	[WinlossPVirtual] [money] NULL,
	[TurnoverIBC] [money] NULL,
	[TurnoverS] [money] NULL,
	[TurnoverM] [money] NULL,
	[TurnoverA] [money] NULL,
	[TurnoverIBCVirtual] [money] NULL,
	[CommissionS] [money] NULL,
	[CommissionM] [money] NULL,
	[CommissionA] [money] NULL,
	[CommissionP] [money] NULL,
	[CommissionSVirtual] [money] NULL,
	[BetCount] [int] NULL,
	[BetCountH] [int] NULL,
	[BetCountA] [int] NULL,
 CONSTRAINT [PK_mcCustNumGameDaily] PRIMARY KEY CLUSTERED 
(
	[rptDate] ASC,
	[CustID] ASC,
	[recommend] ASC,
	[mrecommend] ASC,
	[srecommend] ASC,
	[SiteID] ASC,
	[currency] ASC,
	[isLive] ASC,
	[bettype] ASC,
	[leagueid] ASC,
	[matchid] ASC,
	[status] ASC
)WITH (DATA_COMPRESSION = PAGE , PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [mcCustNumGameDaily]
) ON [mcCustNumGameDaily]

GO


