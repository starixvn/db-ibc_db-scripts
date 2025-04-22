/*<info serverAlias="DBLIC-bodb_LicenseeReportArchive"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBLIC-bodb_LicenseeReportArchive
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/


USE [bodb_LicenseeReportArchive]
GO

--[rptCustomerTurnover_bk]
ALTER TABLE rptCustomerTurnover_bk ALTER COLUMN Currency SMALLINT
GO
