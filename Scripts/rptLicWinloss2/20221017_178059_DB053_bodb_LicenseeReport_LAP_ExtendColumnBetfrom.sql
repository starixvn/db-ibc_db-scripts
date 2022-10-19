/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/
/*
	Created: 20221017@Evan
	DB: DBLIC-bodb_LicenseeReport
	Task: LAP - Restructure betfrom storage [Redmine: #178059]
*/

USE bodb_LicenseeReport
GO

ALTER TABLE rptLicWinloss2
ALTER COLUMN betfrom	nvarchar(3) WITH (ONLINE=ON);
GO

ALTER TABLE rptLicWinlossGMT
ALTER COLUMN betfrom	nvarchar(3) WITH (ONLINE=ON);
GO
    