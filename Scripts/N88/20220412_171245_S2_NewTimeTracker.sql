/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220412@Percy
	DB: DBN88-bodb_N88
	Task: Add time tracker for new table ReferralMLog
*/
USE bodb_N88
GO

INSERT INTO dbo.API_TimeTracker (DataSource, CalledTime, KeyValue)
VALUES ('ReferralMLog', '2022-04-01 00:00:00.000', '0')
GO