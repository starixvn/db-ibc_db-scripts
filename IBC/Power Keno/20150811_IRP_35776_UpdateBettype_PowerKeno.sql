/*
	Creator: Elodie
	Date: 20150811
	DB: DBPRO/bodb02
	Task: Update IsTest = 0 for new bettype Power Keno into SportBettypeMatrix	
*/
USE bodb02
GO

UPDATE SportBettypeMatrix
SET IsTest = 0
WHERE SportType = 202 AND BetType = 1515