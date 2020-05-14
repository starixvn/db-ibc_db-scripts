USE [bodb02]
GO

/*
	Created: 20190318@Percy
	DB: DBPRO.bodb02
	Task: SportBettypeMatrix - Insert new bettype of Allbet - 2406: Win 3 Cards
	RedmineID: 109344
*/

INSERT INTO dbo.SportBettypeMatrix (SportType, BetType, IsLive, ProductID, Enabled, IsTest, EventType, SubProduct, RefTable)
VALUES (211, 2406, 1, 21, 1, 0, 0, '', 2)