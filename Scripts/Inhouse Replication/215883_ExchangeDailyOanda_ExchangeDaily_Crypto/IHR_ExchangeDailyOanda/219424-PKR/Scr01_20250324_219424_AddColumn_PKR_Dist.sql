/*<info serverAlias="DBCustRepl-ReplCustDB"></info>*/
/*
	Created: 20250324@Tacy
	DB: DBCustRepl-ReplCustDB
	Task : LAP - Support based PKR (RedmineID: #219424)
*/
USE ReplCustDB
GO

ALTER TABLE ExchangeDailyOanda
ADD [PKR] FLOAT NULL;