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
SELECT @ProductID,ExchangeId, 1, 2000 FROM LossLimit_GlobalSetting WHERE ProductId = 6 AND ExchangeId NOT IN (20,2,3,34)