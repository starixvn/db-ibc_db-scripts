/*<info serverAlias="DBRPT-bodb_report"></info>*/
/*
	Created: 20221017@Evan
	DB: DBRPT-bodb_report
	Task: LAP - Restructure betfrom storage [Redmine: #178059]
*/

USE bodb_report
GO

ALTER TABLE rptLicWinlossGMTTmp
ALTER COLUMN betfrom	nvarchar(3) WITH (ONLINE=ON);
GO
