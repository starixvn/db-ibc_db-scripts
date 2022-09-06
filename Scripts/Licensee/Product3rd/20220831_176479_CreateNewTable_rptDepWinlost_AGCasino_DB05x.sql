/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20220831@Sol
	DB: DBLIC-bodb_LicenseeReport
	Task: Create new table rptDepWinlost_AGCasino in DB05x - [RedmineID: #176479]
*/

USE bodb_LicenseeReport

GO

CREATE TABLE [dbo].[rptDepWinlost_AGCasino](
  [Winlostdate] [datetime] NOT NULL,
  [Custid] [int] NOT NULL,
  [Sporttype] [smallint] NOT NULL,
  [Turnover] [money] NULL,
  [DrawTO] [money] NULL,
  [Winlost] [money] NULL,
  [Playercomm] [money] NULL,
  [BetCount] [int] NULL,
  [DrawBetCount] [int] NULL,
  [IsVIPGame] [bit] NOT NULL,
  [currency] [int] NULL,
 CONSTRAINT [CIX_rptDepWinlost_AGCasino] PRIMARY KEY CLUSTERED 
	(
	  [Custid] ASC,
	  [Winlostdate] ASC,
	  [Sporttype] ASC,
	  [IsVIPGame] ASC
	)
)
GO