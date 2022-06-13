/*<info serverAlias="DB053-bodb_LicenseeReport"></info>*/
/*
	Created: 20220613@Evan
	DB: DB053-bodb_LicenseeReport
	Task: New table rptLicenseeWinloss [Redmine: #172604]
	Step 2: New table
*/

USE bodb_LicenseeReport
GO

CREATE TABLE [dbo].[rptLicenseeWinloss](
	WinlostDate	smalldatetime	NOT NULL,
	CustId	int	NOT NULL,
	StatusID	smallint	NOT NULL,
	Sporttype	smallint	NOT NULL,
	Bettype	smallint	NOT NULL,
	LiveIndicator	bit	NOT NULL,
	LeagueGroupId	smallint	NOT NULL,
	TicketType	tinyint	NOT NULL,
	Betfrom	nvarchar(1)	NOT NULL,
	IsBA	bit	NOT NULL,
	Recommend	int	NOT NULL,
	BetCount	int	NULL,
	Turnover	money	NULL,
	ValidBetAmount	money	NULL,
	Winlost	money	NULL,
	AWinlost	money	NULL,
	MWinlost	money	NULL,
	SWinlost	money	NULL,
	PlayerComm	money	NULL,
	Comm	money	NULL,
	AComm	money	NULL,
	SComm	money	NULL,
	BetEffective	money	NULL,
	BuyBackAmt	money	NULL,
	BABuyBackAmt	money	NULL,
	APositiontaking	smallmoney	NULL)
	ON [PS_rptLicenseeWinloss_Yearly](WinlostDate)
GO