USE bodb02
GO

/*
	Created: 20190911@Percy
	DB: DBPRO.bodb02
	Task: Remove un-used bet type Total Corners - 11 (not have real ticket)
*/

DELETE dbo.SportBettypeMatrix WITH (ROWLOCK, UPDLOCK)
WHERE bettype = 11