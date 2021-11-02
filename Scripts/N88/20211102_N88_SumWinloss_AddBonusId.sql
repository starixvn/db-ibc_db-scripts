/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20211102@Percy
	DB: DBN88-bodb_N88
	Task: Add BonusId
	https://nexdev.net/issues/164141
*/
USE bodb_N88
GO

ALTER TABLE dbo.N88_SumWinloss
	ADD BonusId INT
GO