USE [bodb02]
GO

/*
	Created: 20190225@Percy
	DB: DBPRO.bodb02
	Task: Bet Builder - Insert new bettype into SportBettypeMatrix - Single Match Parlay
*/

INSERT INTO dbo.SportBettypeMatrix (SportType, BetType, IsLive, ProductID, Enabled, IsTest, EventType, SubProduct, RefTable)
VALUES (1, 38, 0, 1, 1, 0, 1, 'Bet Builder', 0)