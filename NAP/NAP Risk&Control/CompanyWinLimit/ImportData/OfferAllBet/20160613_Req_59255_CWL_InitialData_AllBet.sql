/*
	Created by: Helen
	Created Date: 20160613
	Description: Offer AllBet
	Database: DBCUST/CUSTDB 
	
*/
DELETE Winlimit_ProductSetting WHERE ProductID = 21 AND BettypeID = 2401
GO
INSERT INTO Winlimit_ProductSetting (ProductID,	BettypeID, LevelID, SettingStatus)
VALUES
(21,	2401,	1,	0)
,(21,	2401,	2,	0)
,(21,	2401,	3,	0)

GO

INSERT INTO WinLimit_ProductSettingDetail (ProductID, BetTypeID, ExchangeID, SiteID, LevelID, MaxWinLimit, IsBlockedPlaceBet, IsBlockedTransfer)
SELECT 21, 2401, ExchangeID, SiteID, LevelID, MaxWinLimit, IsBlockedPlaceBet, IsBlockedTransfer
FROM WinLimit_ProductSettingDetail (NOLOCK) 
WHERE ProductID = 13

