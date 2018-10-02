USE [bodb02]
GO

/*
	Created: 20181002@Percy
	DB: DBPRO.bodb02
	Task: Insert new bettypes of Gold Deluxe
*/

INSERT INTO dbo.SportBettypeMatrix (SportType, BetType, IsLive, ProductId, Enabled, IsTest, EventType, SubProduct, RefTable)
VALUES
	(255, 1704, 1, 12, 1, 0, 0, '', 3),
	(255, 1705, 1, 12, 1, 0, 0, '', 3)