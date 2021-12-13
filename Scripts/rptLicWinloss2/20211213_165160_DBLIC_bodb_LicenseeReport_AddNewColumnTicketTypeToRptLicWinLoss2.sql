/*<info serverAlias="DBLIC-bodb_LicenseeReport,DBBAL-bodb_LicenseeReport"></info>*/
/*
	Created: 20211213@Kos
	DB: DBLIC-bodb_LicenseeReport
	Task: Add new column TicketType TINYINT to table rptLicWinLoss2 [Redmine: #165160]
*/

USE bodb_LicenseeReport
GO

ALTER TABLE rptLicWinLoss2 ADD TicketType TINYINT NULL
GO