/*
	Created: 20200703@Kathy
	DB: DBTXN/bodb02
	Task: Add new column [Redmine:#135846]
*/
USE bodb02
GO

ALTER TABLE dbo.SettlementSpecialBettypeProfile ADD RefResourceId VARCHAR(20)
GO
