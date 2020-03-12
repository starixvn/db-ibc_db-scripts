USE bodb02
GO

/*
	Created: 20200312@Percy
	DB: DBPRO.bodb02
	Task: Update RefTable for Virtual Games
*/

UPDATE dbo.SportBettypeMatrix WITH (ROWLOCK)
SET RefTable = 3
WHERE SportType = 245
	AND ProductID = 38