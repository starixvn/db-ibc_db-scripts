/*
	Created: 20190315@Kathy
	DB: DBTXN/bodb02
	Task: BetBuilder: Extend datatype [Redmine:#106903]
*/

USE bodb02
GO

ALTER TABLE Settled_Message ALTER COLUMN Message VARCHAR(MAX)