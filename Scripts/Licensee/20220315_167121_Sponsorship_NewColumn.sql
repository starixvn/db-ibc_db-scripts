/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20220315@Percy
	DB: DBLIC-bodb_LicenseeReport
	Task: LA - rptLicenseeReconciliation - Add new column: Sponsorship
*/
USE bodb_LicenseeReport
GO

ALTER TABLE dbo.rptLicenseeReconciliation
	ADD Sponsorship MONEY NULL
GO