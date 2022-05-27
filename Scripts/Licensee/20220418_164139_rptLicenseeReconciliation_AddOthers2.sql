/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20220418@Percy
	DB: DBLIC-bodb_LicenseeReport
	Task: Add new column into rptLicenseeReconciliation table: Others2: Credit Note for Setup Fee & AMF [RedmineID: #164139]
*/

USE bodb_LicenseeReport
GO

ALTER TABLE dbo.rptLicenseeReconciliation
	ADD Others2 MONEY NULL
GO