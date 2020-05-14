USE [bodb02]
GO

/*
	Created: 20181008@Percy
	DB: DBPRO.bodb02
	Task: SportBettypeMatrix - Sportsbook - Release 4 New Sports and 5 Upcoming Sports [RedmineID: #102822]
*/

UPDATE dbo.SportBettypeMatrix WITH (ROWLOCK, UPDLOCK)
SET IsTest = 0
WHERE Sporttype IN (47,48,49,51,52,53,54,55,56)