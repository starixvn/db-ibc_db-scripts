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
	StatusId		SMALLINT		NOT NULL,
	ProductId		TINYINT			NOT NULL,
	Sporttype		SMALLINT		NOT NULL,
	Bettype			SMALLINT		NOT NULL,
	LiveIndicator	BIT				NOT NULL,
	LeagueGroupId	SMALLINT		NOT NULL,
	TicketType		TINYINT			NOT NULL,
	Betfrom			NVARCHAR(1)		NOT NULL,
	IsBA			BIT				NOT NULL,
	Recommend		INT				NOT NULL,
	APositiontaking	SMALLMONEY		NOT NULL,
	BetCount		INT				NULL,
	Turnover		MONEY			NULL,
	ValidBetAmount	MONEY			NULL,
	Winlost			MONEY			NULL,
	AWinlost		MONEY			NULL,
	MWinlost		MONEY			NULL,
	SWinlost		MONEY			NULL,
	PComm			MONEY			NULL,
	AComm			MONEY			NULL,
	MComm			MONEY			NULL,
	SComm			MONEY			NULL,
	BetEffective	MONEY			NULL,
	Amount			MONEY			NULL
) ON [PS_rptLicenseeWinloss_Monthly](WinlostDate);

GO