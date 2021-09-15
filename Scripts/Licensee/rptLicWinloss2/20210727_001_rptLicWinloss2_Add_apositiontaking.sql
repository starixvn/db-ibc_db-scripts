/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20210727@Percy
	DB: DBLIC-bodb_LicenseeReport
	Task: rptLicWinloss2 - Add column apositiontaking
	https://nexdev.net/issues/155593

	Step 1: Add column apositiontaking
*/
use bodb_LicenseeReport
go

alter table dbo.rptLicWinloss2
	add apositiontaking smallmoney
go