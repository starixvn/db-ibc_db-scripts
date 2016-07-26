use bodb_LicenseeReport
go
/*
	Task: rpt_Betting_BA table:
		- Create table schema
*/

DECLARE @SqlCmd VARCHAR(MAX), @Prefix VARCHAR(50)
	, @FileGroupName VARCHAR(100), @PathFile VARCHAR(255)

SELECT @PathFile = 'E:\IBC_DB\bodb_LicenseeReport\'
	, @Prefix = 'rptBetting_ba'

--create max group file
SET @FileGroupName = @Prefix + '_Data'
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILEGROUP ' + @FileGroupName
PRINT @SqlCmd
EXEC (@SqlCmd)

SET @SqlCmd = ''
SELECT @SqlCmd = 'ALTER DATABASE bodb_LicenseeReport ADD FILE (NAME = N''' + @FileGroupName 
	+ ''', FILENAME = N''' + @PathFile + @FileGroupName + '.ndf''
	, SIZE = 512KB , MAXSIZE = UNLIMITED, FILEGROWTH = 32768KB) TO FILEGROUP ' + @FileGroupName
PRINT @SqlCmd
EXEC (@SqlCmd)

GO

CREATE TABLE [dbo].[rpt_Betting_BA](
	[RecordID] [bigint] IDENTITY(1,1) NOT NULL,
	[rptDate] [datetime] NOT NULL,
	[SiteID] [int] NOT NULL,
	[Bettype] [smallint] NOT NULL,
	[LeagueID] [int] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[Status] [smallint] NOT NULL,
	[IsLive] [bit] NOT NULL,
	[BetCount] [int] NULL,
	[MemberCount] [int] NULL,
	[Turnover] [money] NULL,
	[WinLoss] [money] NULL,
	[WinLossA] [money] NULL,
	[WinLossM] [money] NULL,
	[WinLossS] [money] NULL,
	[CommissionP] [money] NULL,
	[CommissionA] [money] NULL,
	[CommissionM] [money] NULL,
	[CommissionS] [money] NULL,
	[WinLossVirtual] [money] NULL,
	[CommissionSVirtual] [money] NULL,
	[BuyBackAmount] [money] NULL,
	[CustomerCategory] [smallint] NULL
) ON [rptBetting_ba_Data]

GO

CREATE CLUSTERED INDEX [CIX_rpt_Betting_BA] ON [dbo].[rpt_Betting_BA] 
(
	[rptDate] ASC,
	[SiteID] ASC,
	[Bettype] ASC,
	[LeagueID] ASC,
	[CurrencyID] ASC,
	[Status] ASC,
	[IsLive] ASC
) ON [rptBetting_ba_Data]
GO
