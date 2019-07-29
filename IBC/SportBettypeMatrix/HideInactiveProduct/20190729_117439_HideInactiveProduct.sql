
---DBPRO 
USE bodb02
GO 
/*
Create : 20190729@Sophia
Task: Hide inactive product [redmine: 117439]
DB: DBPRO.bodb02
*/



UPDATE Products
SET EndOfSupportDate = '2019-04-16',   
	Enabled = 0 
WHERE ProductID = 33   ---Poker Games

UPDATE Products
SET EndOfSupportDate = '2018-04-26',   
	Enabled = 0 
WHERE ProductID = 26   ---Lucky 3

UPDATE Products
SET EndOfSupportDate = '2018-03-01',   
	Enabled = 0 
WHERE ProductID = 30   ---Bullfighting

 
UPDATE Products
SET EndOfSupportDate = '2018-03-01',   
	Enabled = 0 
WHERE ProductID = 15   ---Colossus Bet
