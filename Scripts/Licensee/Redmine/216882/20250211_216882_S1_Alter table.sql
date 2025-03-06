/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created by: 20250211@Kelvin
	DB: DBLIC-bodb_LicenseeReport
	Task: BA Admin & LAP - Drop BA functions [RedmineID:: #216882]
*/



ALTER TABLE dbo.rptLicWinloss2
ADD CONSTRAINT DF_rptLicWinloss2_isBA DEFAULT 0 for isBA
