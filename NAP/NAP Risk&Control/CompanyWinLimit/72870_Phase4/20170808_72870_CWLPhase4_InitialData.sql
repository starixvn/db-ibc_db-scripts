/*
	Created: 20170808@Helen
	Task: CWL - phase 4 - [Redmine: 81078]
	DB: DBCUST/CUSTDB
	
*/
-- Update LevelOrder for winlimit level

UPDATE Winlimit_LevelSetting SET LevelOrder = 1 WHERE LevelID = 1
UPDATE Winlimit_LevelSetting SET LevelOrder = 2 WHERE LevelID = 2
UPDATE Winlimit_LevelSetting SET LevelOrder = 3 WHERE LevelID = 3

GO
-- Add level for loss limit
INSERT INTO Winlimit_LevelSetting (LevelID,LevelName,LevelOrder)
VALUES (101, 'Grey',101)
		, (102,'Black',102)
GO

INSERT INTO dbo.Winlimit_ProductSetting (ProductID, BettypeID, LevelID, SettingStatus)
SELECT ProductID, BettypeID, 101, 0
FROM Winlimit_ProductSetting  WITH (NOLOCK)
WHERE LevelID = 1 

GO
INSERT INTO dbo.Winlimit_ProductSetting (ProductID, BettypeID, LevelID, SettingStatus)
SELECT ProductID, BettypeID, 102, 0
FROM Winlimit_ProductSetting  WITH (NOLOCK)
WHERE LevelID = 1 