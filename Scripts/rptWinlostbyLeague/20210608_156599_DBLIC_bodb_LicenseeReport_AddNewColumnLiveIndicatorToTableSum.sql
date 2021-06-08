/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20210511@Kos
	DB: DBLIC-bodb_LicenseeReport
	Task: Add new column LiveIndicator BIT to table rptWinlostbyLeague and rptCustomerMatch [Redmine: #156599]
*/

USE bodb_LicenseeReport
GO

ALTER TABLE rptWinlostbyLeague ADD LiveIndicator BIT NULL
GO

ALTER TABLE rptCustomerMatch ADD LiveIndicator BIT NULL
GO