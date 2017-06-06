/*
	Created: 201706082Elodie
	Task: Update setting type of AllBet, Macau
	DB: DBCUST/CustDB
*/
USE CustDB
GO

UPDATE ps
SET SettingType = 13
FROM dbo.ProductSettingDetail ps WITH (ROWLOCK, UPDLOCK)
WHERE ProductID IN (21,22) 
	AND SettingType = 4

--SELECT *
--FROM dbo.ProductSettingDetail WITH (ROWLOCK, UPDLOCK)
--WHERE ProductID IN (21,22) 
--	AND SettingType = 13