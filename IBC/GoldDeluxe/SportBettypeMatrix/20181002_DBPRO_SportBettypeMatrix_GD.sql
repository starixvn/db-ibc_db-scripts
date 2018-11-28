USE [bodb02]
GO

/*
	Created: 20181002@Percy
	DB: DBPRO.bodb02
	Task: GoldDeluxe
		- Add new bettypes
			+ For credit: 1704, 1705  (translog --> bettrans): refTable = 3
			+ For deposit: 1706 (bettrans): refTable = 0
		- Correct refTable of 1700 (deposit only)
*/

-- New bettypes of GD
INSERT INTO dbo.SportBettypeMatrix (SportType, Bettype, IsLive, ProductID, Enabled, IsTest, EventType, SubProduct, RefTable)
VALUES
	(255, 1704, 1, 12, 1, 0, 0, '', 3),
	(255, 1705, 1, 12, 1, 0, 0, '', 3),
	(255, 1706, 0, 12, 1, 0, 0, '', 0)


-- Correct RefTable of 1700 (ticket sum of API ticket)
UPDATE dbo.SportBettypeMatrix WITH (ROWLOCK, UPDLOCK)
SET RefTable = 0 -- insert data direct into bettrans
WHERE ProductId = 12 AND Bettype = 1700