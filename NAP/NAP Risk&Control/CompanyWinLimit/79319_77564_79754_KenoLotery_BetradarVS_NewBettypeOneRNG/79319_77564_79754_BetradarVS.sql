
/*
	Created: 20170710@Helen
	Task: https://nexdev.net/issues/77567
	DB: DBCUST/CUSTDB
*/
USE CustDB
GO

CREATE TABLE #Currency_Deposit (siteid INT, exchangeid INT, PRIMARY KEY (siteid,exchangeid))

INSERT INTO #Currency_Deposit
SELECT DISTINCT  s.siteid,ex.exchangeid AS Id
FROM DBLIC.bodb_licensee.dbo.LicenseeCust lc WITH (NOLOCK)
  INNER JOIN DBLIC.bodb_licensee.dbo.Licensees l WITH (NOLOCK) ON l.LicenseeID = lc.LicenseeID
  INNER JOIN dbo.exchange ex WITH (NOLOCK) ON lc.Currency = ex.exchangeid
  INNER JOIN dbo.site s WITH (NOLOCK) ON s.site = l.LicenseeName  AND S.isActive = 1
WHERE ex.currency NOT IN('H', 'C')
             
CREATE TABLE #Temp (ProductID INT, BetTypeID INT,GroupID INT,GroupName VARCHAR(200),Level1 MONEY, Level2 MONEY,Level3 MONEY)

INSERT INTO #Temp (ProductID,BetTypeID,GroupID,GroupName,Level1,Level2,Level3)
VALUES 
(27,2701,12,'Betradar Virtual Sports',100000,300000,500000),
(27,2702,12,'Betradar Virtual Sports',100000,300000,500000),
(27,2703,12,'Betradar Virtual Sports',100000,300000,500000),
(27,2704,12,'Betradar Virtual Sports',100000,300000,500000),
(27,2705,12,'Betradar Virtual Sports',100000,300000,500000),
(27,2706,12,'Betradar Virtual Sports',100000,300000,500000),
(27,2707,12,'Betradar Virtual Sports',100000,300000,500000),
(27,2799,12,'Betradar Virtual Sports',100000,300000,500000)

INSERT INTO Winlimit_Group(GroupID, GroupName)
SELECT DISTINCT GroupID,GroupName
FROM #Temp

INSERT INTO dbo.Winlimit_GameGroupSetting (ProductID, BetTypeID, GroupID)
SELECT DISTINCT ProductID, BetTypeID, GroupID
FROM #Temp

INSERT INTO WinLimit_ProductSettingDetail (ProductID, GroupID, ExchangeID, SiteID, LevelID,  IsBlockedPlaceBet, IsBlockedTransfer, MaxWinLimit_RM)
SELECT DISTINCT T.ProductID, GroupID, ExchangeID, s.SiteID, 1, 0, 0,t.Level1 MaxWinLimit_RM
FROM #Temp t
	CROSS JOIN EXCHANGE E (NOLOCK) 
	CROSS JOIN (SELECT siteid,isLicensee FROM Site WITH (NOLOCK) WHERE isActive = 1) AS S
WHERE e.currency NOT IN('H', 'C') 
	AND ((S.isLicensee = 1 AND E.exchangeid IN (SELECT exchangeid FROM #Currency_Deposit WHERE siteid= S.siteid))
		 OR (S.isLicensee = 0 AND E.exchangeid IN (2,35,3,64,40,17,16,6,5,67,13,43,47,33,34,15,22,45,70,69,1,12,4,51,61,20,72)))
	
UNION ALL

SELECT DISTINCT ProductID, GroupID, ExchangeID, s.SiteID, 2, 0, 0,t.Level2 MaxWinLimit_RM
FROM #Temp t
	CROSS JOIN EXCHANGE E (NOLOCK) 
	CROSS JOIN (SELECT siteid,isLicensee FROM Site WITH (NOLOCK) WHERE isActive = 1) AS S
WHERE e.currency NOT IN('H', 'C') 
	AND ( (S.isLicensee = 1 AND E.exchangeid IN (SELECT exchangeid FROM #Currency_Deposit WHERE siteid= S.siteid))
		 OR (S.isLicensee = 0 AND E.exchangeid IN (2,35,3,64,40,17,16,6,5,67,13,43,47,33,34,15,22,45,70,69,1,12,4,51,61,20,72)))
	
UNION ALL

SELECT DISTINCT T.ProductID, GroupID, ExchangeID, s.SiteID, 3, 0 IsBlockedPlaceBet
		, 0 IsBlockedTransfer
		,t.Level3 MaxWinLimit_RM
FROM #Temp t
	CROSS JOIN EXCHANGE E (NOLOCK) 
	CROSS JOIN (SELECT siteid,isLicensee FROM Site WITH (NOLOCK) WHERE isActive = 1) AS S	
WHERE e.currency NOT IN('H', 'C') 
	AND ((S.isLicensee = 1 AND E.exchangeid IN (SELECT exchangeid FROM #Currency_Deposit WHERE siteid= S.siteid))
		 OR (S.isLicensee = 0 AND E.exchangeid IN (2,35,3,64,40,17,16,6,5,67,13,43,47,33,34,15,22,45,70,69,1,12,4,51,61,20,72)))
	
INSERT INTO Winlimit_productsetting (ProductID,BettypeID,LevelID,SettingStatus)
SELECT DISTINCT ProductID,MIN(BettypeID),T.LevelID,0
FROM #Temp t1
	CROSS JOIN (SELECT LEVELID FROM winlimit_levelSetting WITH (NOLOCK)) AS T
WHERE NOT EXISTS (SELECT 1 FROM winlimit_productsetting t2 WITH (NOLOCK) WHERE T1.ProductID = T2.ProductID)
GROUP BY ProductID,T.LevelID

