/*<info serverAlias="DBN88-bodb_N88" isFunction="0" isNested=""></info>*/
/*
Created: 20200710@Kos
Task: Delete time tracker to repull data [Redmine: #141062]
DB: DBN88-bodb_N88
*/

USE bodb_N88

GO

DELETE dbo.API_TimeTracker WITH (ROWLOCK)
WHERE DataSource = 'BonusInfo'

GO

DELETE dbo.API_Queue WITH (ROWLOCK)
WHERE DataSource = 'BonusInfo'

GO
