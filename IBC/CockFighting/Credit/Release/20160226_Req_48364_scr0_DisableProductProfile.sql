/*
	Created By: Dominic
	Created Date: 2016-02-26
	Task: Update Product Profile for Cock Fighting
	Database:DBCust/CustDB 
*/

UPDATE ProductSettingDetail 
SET SettingStatus = 2
	,MaxPT = 90
	,IsHidden = 0
	,IsDisabled = 0
WHERE ProductID = 19 -- Cock Fighting
