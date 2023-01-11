/*<info serverAlias="DBLIC-bodb_LicenseeReport,DBBAL-bodb_LicenseeReport"></info>*/
/*
	Created: 20221216@Evan
	DB: DBLIC-bodb_LicenseeReport,DBBAL-bodb_LicenseeReport
	Task: Support Cash Out WL Separate Soccer Basketball - Add column TicketType [Redmine: #179083]
*/

USE bodb_LicenseeReport
GO

ALTER TABLE rptWinlostbyLeague
ADD TicketType TINYINT

ALTER TABLE rptCustomerMatch
ADD TicketType TINYINT 
