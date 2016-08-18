/*
	Created By: Elodie
	Created Date: 2016-02-26
	Task: Update Product Profile for AllBet
	Database:DBCust/CustDB 
*/

UPDATE ProductSettingDetail 
SET SettingStatus = 0	
WHERE ProductID = 21 -- AllBet

--DELETE LossLimit_GlobalSetting WHERE ProductID = 21 -- AllBet
/*
INSERT INTO LossLimit_GlobalSetting(ProductId, ExchangeId, MinLossLimit, DefaultLossLimit)
SELECT 21, ExchangeId, 1, 0
FROM dbo.exchange WITH (NOLOCK)
*/