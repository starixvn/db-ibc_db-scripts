/*
	Created: Helen
	Task: Update commission - Remine: https://nexdev.net/issues/66192
	DB: DBCUST/CustDB
	Date: 20161125	
*/ 

UPDATE GS
	SET Maxsdiscount = 0.009
FROM ProductGlobalSetting gs  (rowlock)
WHERE sporttype = 255 AND bettype = 1701

UPDATE T
	SET MaxDiscount = 0.009
FROM ProductSettingDetail T (rowlock)
WHERE ProductID = 21 AND BetType = 2401 AND SettingType = 3