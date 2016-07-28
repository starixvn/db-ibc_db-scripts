/*
	Created By: Helen
	Created Date: 20162007
	Task: Currency Setting Initialization for CWL
	
	DB: DBCust/CUSTDB
	
	We have 181 SITE, 25 CURRENCY, 4 PRODUCT, 3 LEVEL --> SELECT 181*25*4 * 3= 56472 rows to be inserted
*/

USE CustDB
GO
TRUNCATE TABLE WinLimit_ProductSettingDetail
GO
CREATE TABLE #CurrencySetting_LiveCasino_13 (ExchangeID INT, Orange MONEY, Yellow MONEY, Red MONEY)

CREATE TABLE #CurrencySetting_RNG_6_17_22 (ExchangeID INT, Orange MONEY, Yellow MONEY, Red MONEY)

INSERT INTO #CurrencySetting_LiveCasino_13
VALUES 
	--UUS ----
	(20,0,0,0),
	---- OTHERS: source from excel file 
	(2,50000,300000,500000),
	(35,12400,74800,124800),
	(3,12400,74800,124800),
	(64,12400,74800,124800),
	(40,12400,74800,124800),
	(17,12400,74800,124800),
	(16,12400,74800,124800),
	(6,11300,67800,113000),
	(5,96700,580600,967700),
	(67,96700,580600,967700),
	(13,83500,501000,835000),
	(43,434500,2607500,4345900),
	(47,161200,967700,1612900),
	(33,161200,967700,1612900),
	(34,161200,967700,1612900),
	(15,161200,967700,1612900),
	(22,161200,967700,1612900),
	(45,14204500,85227200,142045400),
	(70,14600,87700,146100),
	(69,14600,87700,146100),
	(1,16800,100800,168000),
	(12,9400,56700,94600),
	(4,434500,2607500,4345900),
	(51,277700,1666600,2777700),
	(61,835200,5011600,8352800)

INSERT INTO #CurrencySetting_RNG_6_17_22
VALUES 
	--UUS ----
	(20,0,0,0),
	---- OTHERS: source from excel file
	(2,5000,30000,100000),
	(35,1200,7400,24900),
	(3,1200,7400,24900),
	(64,1200,7400,24900),
	(40,1200,7400,24900),
	(17,1200,7400,24900),
	(16,1200,7400,24900),
	(6,1100,6700,22600),
	(5,9600,58000,193500),
	(67,9600,58000,193500),
	(13,8300,50100,167000),
	(43,43400,260700,869100),
	(47,16100,96700,322500),
	(33,16100,96700,322500),
	(34,16100,96700,322500),
	(15,16100,96700,322500),
	(22,16100,96700,322500),
	(45,1420400,8522700,28409000),
	(70,1400,8700,29200),
	(69,1400,8700,29200),
	(1,1600,10000,33600),
	(12,900,5600,18900),
	(4,43400,260700,869100),
	(51,27700,166600,555500),
	(61,83500,501100,1670500)
	

INSERT INTO WinLimit_ProductSettingDetail (ProductID, BettypeID, ExchangeID, SiteID, LevelID, MaxWinLimit, IsBlockedPlaceBet, IsBlockedTransfer)

SELECT DISTINCT 13, 2001, A.ExchangeID, S.SiteID, A.LevelID, A.MaxWinLimit AS MaxWinLimit, 0 IsBlockedPlaceBet
		, 0 AS IsBlockedTransfer
FROM #CurrencySetting_LiveCasino_13 cs
	INNER JOIN exchange e WITH (NOLOCK) ON cs.ExchangeID = e.exchangeid
	CROSS APPLY ( VALUES (1,cs.ExchangeID,Orange),
					  (2,cs.ExchangeID,Yellow),
					  (3,cs.ExchangeID,Red) )
			AS A (LevelID,ExchangeID,MaxWinLimit)	
	CROSS JOIN (SELECT siteid,isLicensee FROM Site WITH (NOLOCK) WHERE isActive = 1) AS S
WHERE e.currency NOT IN('H', 'C') 


INSERT INTO WinLimit_ProductSettingDetail (ProductID, BettypeID, ExchangeID, SiteID, LevelID, MaxWinLimit, IsBlockedPlaceBet, IsBlockedTransfer)

SELECT DISTINCT B.ProductID, B.BettypeID, A.ExchangeID, S.SiteID, A.LevelID, A.MaxWinLimit AS MaxWinLimit, 0 IsBlockedPlaceBet
		, CASE WHEN A.LevelID = 3 AND S.isLicensee = 1 THEN 1 ELSE 0 END AS IsBlockedTransfer
FROM #CurrencySetting_RNG_6_17_22 cs
	INNER JOIN exchange e WITH (NOLOCK) ON cs.ExchangeID = e.exchangeid
	CROSS APPLY ( VALUES (1,cs.ExchangeID,Orange),
					  (2,cs.ExchangeID,Yellow),
					  (3,cs.ExchangeID,Red) )
			AS A (LevelID,ExchangeID,MaxWinLimit)	
	CROSS JOIN (SELECT DISTINCT ps.ProductID,ps.BettypeID
				FROM Winlimit_ProductSetting ps WITH (NOLOCK)
				WHERE ProductID IN (6,17,22)
				) AS B			
	CROSS JOIN (SELECT siteid,isLicensee FROM Site WITH (NOLOCK) WHERE isActive = 1) AS S
WHERE e.currency NOT IN('H', 'C') 

DROP TABLE #CurrencySetting_LiveCasino_13

DROP TABLE #CurrencySetting_RNG_6_17_22
