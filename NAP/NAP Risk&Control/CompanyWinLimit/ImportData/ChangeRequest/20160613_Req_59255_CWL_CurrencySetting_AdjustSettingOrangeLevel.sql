/*
	Created By: Helen
	Created Date: 20160831
	Task: Adjust Orange Currency Setting for CWL - https://nexdev.net/issues/63203
	
	DB: DBCust/CUSTDB
	Only adjust for these products:
		Microgaming - RNG Casino : ProductID = 17
		Macau Games: ProductID = 22
		One RNG Casino: ProductID = 6

*/

USE CustDB

CREATE TABLE #CurrencySetting_OrangeLevel (ExchangeID INT, Orange MONEY)

INSERT INTO #CurrencySetting_OrangeLevel
VALUES 
	(2,10000),
	(35,2400),
	(3,2400),
	(64,2400),
	(40,2400),
	(17,2400),
	(16,2400),
	(6,2200),
	(5,19100),
	(67,19100),
	(13,16500),
	(43,85400),
	(47,33300),
	(33,33300),
	(34,33300),
	(15,33300),
	(22,33300),
	(45,2770000),
	(70,2900),
	(69,2900),
	(1,3300),
	(12,1800),
	(4,85400),
	(51,55500),
	(61,165800)

UPDATE T
	SET MaxWinLimit = T1.Orange
FROM WinLimit_ProductSettingDetail T
	INNER JOIN #CurrencySetting_OrangeLevel T1 ON T1.ExchangeID = T.ExchangeID 
WHERE T.ProductID IN (6,17,22)	AND T.LevelID = 1

DROP TABLE #CurrencySetting_OrangeLevel