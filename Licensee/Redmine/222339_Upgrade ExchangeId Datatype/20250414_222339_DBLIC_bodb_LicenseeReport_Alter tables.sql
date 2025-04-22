/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBLIC-bodb_LicenseeReport
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/


USE [bodb_LicenseeReport]
GO

--[rptCasinoTurnover]
ALTER TABLE rptCasinoTurnover ALTER COLUMN Currency SMALLINT
GO

--[rptCustomerTurnover]
ALTER TABLE rptCustomerTurnover ALTER COLUMN Currency SMALLINT
GO
