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

CREATE TABLE #CurrencySetting (ExchangeID INT, Orange MONEY, Yellow MONEY, Red MONEY)
INSERT INTO #CurrencySetting
VALUES (2,5000,30000,100000),
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
	(45,1400,8500,28400),
	(70,1400,8700,29200),
	(69,1400,8700,29200),
	(1,1600,10000,33600),
	(12,900,5600,18900),
	(4,43400,260700,869100),
	(51,27700,166600,555500),
	(61,83500,501100,1670500)


INSERT INTO WinLimit_ProductSettingDetail (ProductID, BettypeID, ExchangeID, SiteID, LevelID, MaxWinLimit, IsBlockedPlaceBet, IsBlockedTransfer)

SELECT DISTINCT B.ProductID, B.BettypeID, A.ExchangeID, S.SiteID, A.LevelID, 0 AS MaxWinLimit, 0 IsBlockedPlaceBet
		,  0 AS IsBlockedTransfer
FROM #CurrencySetting cs
	INNER JOIN exchange e WITH (NOLOCK) ON cs.ExchangeID = e.exchangeid
	CROSS APPLY ( VALUES (1,cs.ExchangeID,Orange),
					  (2,cs.ExchangeID,Yellow),
					  (3,cs.ExchangeID,Red) )
			AS A (LevelID,ExchangeID,MaxWinLimit)	
	CROSS JOIN (SELECT DISTINCT ps.ProductID,ps.BettypeID
				FROM Winlimit_ProductSetting ps WITH (NOLOCK)) AS B			
	CROSS JOIN (SELECT siteid,isLicensee FROM Site WITH (NOLOCK) WHERE isActive = 1) AS S
	
WHERE e.currency NOT IN('H', 'C') AND B.ProductID IN (6,13,17,22)




