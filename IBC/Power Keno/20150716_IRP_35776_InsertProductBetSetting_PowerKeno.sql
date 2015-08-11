/*
	Created by: Elodie
	Date: 2015-07-22
	Task: insert data in ProductBetSetting for Power Keno [Redmine:#39192]	
*/ 

----------------------------------------------------------------
--Insert data into DBCUST.CustDB.dbo.ProductBetSetting-----------
----------------------------------------------------------------
USE CustDB
GO
INSERT INTO ProductBetSetting (Sporttype, Bettype, Currency, MinBet, IsDep) 
SELECT Sporttype, 1515, Currency, MinBet, IsDep
FROM ProductBetSetting wITH (NOLOCK)
WHERE Sporttype = 202 AND Bettype = 1501 AND Currency = 20

