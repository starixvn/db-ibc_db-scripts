/*
	Created: 20190712@Helen
	Task: Script top update existing setting of CN88 - soccer [Redmine:113233]
	DB: DBCUST/CUSTDB
*/
USE CustDB
GO
ALTER TABLE Tocontrol_LevelSetting
DROP CONSTRAINT PK_TOControl_LevelSetting

GO
ALTER TABLE Tocontrol_LevelSetting 
ADD SiteID INT, ID INT IDENTITY (1,1)

GO
CREATE CLUSTERED INDEX CIX_Site_PercentLevel ON Tocontrol_LevelSetting (SiteID,PercentLevel)
GO

ALTER TABLE Tocontrol_LevelSetting
ADD CONSTRAINT PK_Tocontrol_LevelSetting_ID PRIMARY KEY (ID)
GO   




