/*
	Creator: Elodie
	Date: 20150716
	DB: DBPRO/bodb02
	Task: Insert new bettype Power Keno into SportBettypeMatrix	
*/
USE bodb02
GO

INSERT INTO SportBettypeMatrix (
  SportType,
  BetType,
  IsLive,
  ProductID,
  Enabled,
  IsTest,
  EventType,
  SubProduct)

VALUES (202, 1515, 0, 8, 1, 1, 0,'')