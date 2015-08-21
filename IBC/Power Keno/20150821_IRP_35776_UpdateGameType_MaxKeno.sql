/*
	Creator: Elodie
	Date: 20150821
	DB: DBPRO/bodb02
	Task: Update GameTypeName = Max Keno in GameType table
*/
USE bodb02
GO

UPDATE GameType 
SET GameTypeName = 'Max Keno'
WHERE GameTypeID = 15
