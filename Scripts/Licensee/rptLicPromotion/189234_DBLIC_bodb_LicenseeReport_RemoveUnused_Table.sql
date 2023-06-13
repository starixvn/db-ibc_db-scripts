/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20230612@Evan
	DB: DBLIC-bodb_LicenseeReport
	Task: Drop code related to Saba Promotion -- Remove unused table
	https://nexdev.net/issues/189234
*/

USE bodb_LicenseeReport
GO
EXEC sp_rename 'rptLicPromotion','DEL_rptLicPromotion'
