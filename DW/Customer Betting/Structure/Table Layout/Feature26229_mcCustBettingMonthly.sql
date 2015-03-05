/*
	DBDW.bodb_Account
	DBDW2.bodb_Account
*/
USE bodb_Account

--Add file group 
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.filegroups where name='mcCustBettingMonthly')
BEGIN
	ALTER DATABASE bodb_Account
	ADD FILEGROUP mcCustBettingMonthly;
END
GO

--Add file to filegroup
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_files where name='mcCustBettingMonthly-1')
BEGIN
ALTER DATABASE bodb_Account 
ADD FILE 
(
	NAME = 'mcCustBettingMonthly-1',
	FILENAME = 'D:\IBC_DB\bodb_Account\mcCustBettingMonthly-1.NDF'
)
TO FILEGROUP mcCustBettingMonthly;
END
GO

--Create monthly table
IF OBJECT_ID('dbo.mcCustBettingMonthly', 'U') IS NULL
BEGIN
	CREATE TABLE [dbo].[mcCustBettingMonthly](
		[rptYear] [smallint] NOT NULL,
		[rptMonth] [tinyint] NOT NULL,
		[CustID] [int] NOT NULL,
		[SiteID] [smallint] NOT NULL,
		[Currency] [tinyint] NOT NULL,
		[BetType] [smallint] NOT NULL,
		[LeagueID] [int] NOT NULL,
		[IsLive] [bit] NOT NULL,
		[Status] [tinyint] NOT NULL,
		[WinlossIBC] [money] NULL,
		[Winloss100] [money] NULL,
		[WinlossIBCVirtual] [money] NULL,
		[TurnoverIBC] [money] NULL,
		[Turnover100] [money] NULL,
		[TurnoverIBCVirtual] [money] NULL,
		[CommissionS] [money] NULL,
		[CommissionSVirtual] [money] NULL,
		[BetCount] [int] NULL,
	 CONSTRAINT [PK_mcCustBettingMonthly] PRIMARY KEY CLUSTERED 
	(
		[rptYear] ASC,
		[rptMonth] ASC,
		[CustID] ASC,
		[SiteID] ASC,
		[Currency] ASC,
		[BetType] ASC,
		[LeagueID] ASC,
		[IsLive] ASC,
		[Status] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [mcCustBettingMonthLy]
	) ON [mcCustBettingMonthLy]

END
GO


/*
	DBDW.bodb_Staging
	DBDW2.bodb_Staging
*/
USE bodb_Staging
GO
--Create monthly table
IF OBJECT_ID('dbo.mcCustBettingMonthly', 'U') IS NULL
BEGIN
	CREATE TABLE [dbo].[mcCustBettingMonthly](
		[rptYear] [smallint] NOT NULL,
		[rptMonth] [tinyint] NOT NULL,
		[CustID] [int] NOT NULL,
		[SiteID] [smallint] NOT NULL,
		[Currency] [tinyint] NOT NULL,
		[BetType] [smallint] NOT NULL,
		[LeagueID] [int] NOT NULL,
		[IsLive] [bit] NOT NULL,
		[Status] [tinyint] NOT NULL,
		[WinlossIBC] [money] NULL,
		[Winloss100] [money] NULL,
		[WinlossIBCVirtual] [money] NULL,
		[TurnoverIBC] [money] NULL,
		[Turnover100] [money] NULL,
		[TurnoverIBCVirtual] [money] NULL,
		[CommissionS] [money] NULL,
		[CommissionSVirtual] [money] NULL,
		[BetCount] [int] NULL)
	 ON [PRIMARY]

END
GO
