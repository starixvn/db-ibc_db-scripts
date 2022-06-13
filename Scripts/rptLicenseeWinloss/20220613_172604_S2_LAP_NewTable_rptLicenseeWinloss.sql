/*<info serverAlias="DB053-bodb_LicenseeReport"></info>*/
/*
	Created: 20220613@Evan
	DB: DB053-bodb_LicenseeReport
	Task: New table rptLicenseeWinloss [Redmine: #172604]
	Step 2: New table
*/

USE bodb_LicenseeReport
GO

CREATE TABLE [dbo].[rptLicenseeWinloss]
(
	WinlostDate		SMALLDATETIME	NOT NULL,
	CustId			INT				NOT NULL,
	StatusID		SMALLINT		NOT NULL,
	Sporttype		SMALLINT		NOT NULL,
	Bettype			SMALLINT		NOT NULL,
	LiveIndicator	BIT				NOT NULL,
	LeagueGroupId	SMALLINT		NOT NULL,
	TicketType		TINYINT			NOT NULL,
	Betfrom			NVARCHAR(1)		NOT NULL,
	IsBA			BIT				NOT NULL,
	Recommend		INT				NOT NULL,
	BetCount		INT				NULL,
	Turnover		MONEY			NULL,
	ValidBetAmount	MONEY			NULL,
	Winlost			MONEY			NULL,
	AWinlost		MONEY			NULL,
	MWinlost		MONEY			NULL,
	SWinlost		MONEY			NULL,
	PlayerComm		MONEY			NULL,
	Comm			MONEY			NULL,
	AComm			MONEY			NULL,
	SComm			MONEY			NULL,
	APositiontaking	SMALLMONEY		NULL,
	BetEffective	MONEY			NULL,
	Amount			MONEY			NULL
) ON [PS_rptLicenseeWinloss_Monthly](WinlostDate);

GO