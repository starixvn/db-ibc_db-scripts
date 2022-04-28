/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220428@Percy
	DB: DBN88-bodb_N88
	Task: Add column ReferralAmount into ReferralMLog [RedmineID: #171245]
*/
USE bodb_N88
GO

ALTER TABLE dbo.ReferralMLog
	ADD ReferralAmount DECIMAL(20, 4)