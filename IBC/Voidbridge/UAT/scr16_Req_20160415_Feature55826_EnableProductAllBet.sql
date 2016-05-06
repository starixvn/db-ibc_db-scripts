/*
	Created By: Elodie
	Created Date: 2016-04-14
	Task: Update Product Profile for Voidbridge
	Database:DBCust/CustDB 
*/

UPDATE ProductSettingDetail 
SET SettingStatus = 0	
WHERE ProductID = 22 -- Voidbridge

INSERT INTO LossLimit_GlobalSetting(ProductId, ExchangeId, MinLossLimit, DefaultLossLimit)
SELECT 22,ExchangeId, MinLossLimit, DefaultLossLimit 
FROM LossLimit_GlobalSetting WITH (NOLOCK)
WHERE ProductId = 6