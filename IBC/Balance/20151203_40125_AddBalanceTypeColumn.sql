/*
	Created by: Elodie
	Date: 2015-12-03
	Task: Add new column BalanceType into SportBettypeMatrix table
*/ 
----------------------------------------------------------------
--Add new fields into DBPRO.bodb02.dbo.SportBettypeMatrix-------
----------------------------------------------------------------
USE bodb02
GO
ALTER TABLE SportBettypeMatrix ADD BalanceType VARCHAR(30) NULL

GO
UPDATE sb
SET sb.BalanceType = 'SportsBook'
FROM SportBettypeMatrix sb
WHERE ProductID = 1 AND (SubProduct = '' OR SubProduct IN ('BetRadar','MO', 'BT-Sold', 'BT-Bought', 'BT-Comm', 'SS'))

UPDATE sb
SET sb.BalanceType = 'Others'
FROM SportBettypeMatrix sb
WHERE (ProductID IN (2,5,3,7,8,15) AND SubProduct = '') OR (ProductID = 1 AND SubProduct = 'MG-SuperLive')

UPDATE sb
SET sb.BalanceType = 'Casino'
FROM SportBettypeMatrix sb
WHERE ProductID IN (4,6,11,12,13,14,10,17) AND SubProduct = ''