---- DBPRO
USE BODB02
GO 
  
IF NOT EXISTS (SELECT TOP 1 1 FROM SportBettypeMatrix (NOLOCK) WHERE BetType =18000)
BEGIN 
	INSERT INTO SportBettypeMatrix (SportType,BetType,IsLive,ProductID,Enabled,IsTest,EventType,SubProduct)
	VALUES 
	(204, 18000, 0, 15, 1, 1, 0, '') 
END  


IF NOT EXISTS (SELECT TOP 1 1 FROM SportBettypeMatrix (NOLOCK) WHERE BetType BETWEEN 301 AND 304)
INSERT INTO SportBettypeMatrix (SportType,BetType,IsLive,ProductID,Enabled,IsTest,EventType,SubProduct)
VALUES 
(1, 301, 0, 1, 1, 1, 1, 'MO')
,(1, 302, 0, 1, 1, 1, 1, 'MO')
,(1, 303, 0, 1, 1, 1, 1, 'MO')
,(1, 304, 0, 1, 1, 1, 1, 'MO')
