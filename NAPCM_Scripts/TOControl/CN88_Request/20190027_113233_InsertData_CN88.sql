/*
	Created: 20190712@Helen
	Task: Script top update existing setting of CN88 - soccer [Redmine:113233]
	DB: DBCUST/CUSTDB
*/
USE CustDB
GO
TRUNCATE TABLE Tocontrol_LevelSetting
GO
INSERT INTO Tocontrol_LevelSetting (PercentLevel, PercentValue, IsNotified, SiteID)
VALUES 
(0,0,0,0)
,(1,5,0,0)
,(2,10,0,0)
,(3,15,0,0)
,(4,20,0,0)
,(5,25,0,0)
,(6,30,0,0)
,(7,35,0,0)
,(8,40,0,0)
,(9,45,0,0)
,(10,50,0,0)
,(11,55,0,0)
,(12,60,1,0)
,(13,65,0,0)
,(14,70,0,0)
,(15,75,0,0)
,(16,80,1,0)
,(17,85,0,0)
,(18,90,0,0)
,(19,95,0,0)
,(20,100,1,0)

GO
INSERT INTO Tocontrol_LevelSetting (PercentLevel, PercentValue, IsNotified, SiteID)
VALUES 
(0,0,0,329)
,(1,5,0,329)
,(2,10,0,329)
,(3,15,0,329)
,(4,20,0,329)
,(5,25,1,329)
,(6,30,0,329)
,(7,35,0,329)
,(8,40,0,329)
,(9,45,0,329)
,(10,50,1,329)
,(11,55,0,329)
,(12,60,0,329)
,(13,65,0,329)
,(14,70,0,329)
,(15,75,1,329)
,(16,80,0,329)
,(17,85,0,329)
,(18,90,0,329)
,(19,95,0,329)
,(20,100,1,329)
-- CHECK DATA
SELECT * FROM Tocontrol_LevelSetting WITH (NOLOCK)
