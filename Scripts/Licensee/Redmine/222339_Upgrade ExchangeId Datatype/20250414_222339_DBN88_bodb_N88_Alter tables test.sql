/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBLIC-bodb_LicenseeReportArchive
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

USE bodb_N88
GO

ALTER TABLE DepositInfoTest ALTER COLUMN CurrencyId SMALLINT 
GO
