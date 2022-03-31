/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220315@Percy
	DB: DBN88-bodb_N88
	Task: Add time tracker for new table CustVerificationReward
*/
USE bodb_N88
GO

INSERT INTO dbo.API_TimeTracker (DataSource, CalledTime, KeyValue)
VALUES ('CustVerificationReward', '2021-01-01 00:00:00.000', '2021-01-01 00:00:00.000')
GO