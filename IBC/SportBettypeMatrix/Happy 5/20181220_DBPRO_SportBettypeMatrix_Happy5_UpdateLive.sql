USE [bodb02]
GO

/*
	Created: 20181220@Percy
	DB: DBPRO.bodb02
	Task: Change non-live to live bettypes of Happy 5
*/

-- 5 rows affected
UPDATE dbo.SportBettypeMatrix WITH (ROWLOCK, UPDLOCK)
SET IsLive = 1
WHERE ProductId = 3 AND SportType = 164
GO