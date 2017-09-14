/*
	Created: 20170821@Helen
	Task: CWL - SETTING - PHASE 4 - [redmine:72870]
	DB: DBCUST/CUSTDB
	
	Unlimited setting for existing player: LOSS LIMIT 
*/

-- Grey Level setting
INSERT INTO WinLimit_CustGameSetting (CustID, ProductID, GroupID, LevelID, MaxWinLimit, MaxWinLimit_RM)
SELECT CustID, ProductID, GroupID, 101, 0, 0
FROM WinLimit_CustGameSetting psd WITH (NOLOCK)
WHERE LevelID = 1 
	AND NOT EXISTS (SELECT 1 FROM WinLimit_CustGameSetting psd1 WITH (NOLOCK) 
					WHERE psd1.CustID = psd.CustID 
						AND psd1.GroupID = psd.GroupID 
						AND psd.ProductID = psd1.ProductID 
						AND psd1.LevelID = 101)

-- Black Level Setting
INSERT INTO WinLimit_CustGameSetting (CustID, ProductID, GroupID, LevelID, MaxWinLimit, MaxWinLimit_RM)
SELECT CustID, ProductID, GroupID, 102, 0, 0
FROM WinLimit_CustGameSetting psd WITH (NOLOCK)
WHERE LevelID = 1 
	AND NOT EXISTS (SELECT 1 FROM WinLimit_CustGameSetting psd1 WITH (NOLOCK) 
					WHERE psd1.CustID = psd.CustID 
						AND psd1.GroupID = psd.GroupID 
						AND psd.ProductID = psd1.ProductID 
						AND psd1.LevelID = 102)



	