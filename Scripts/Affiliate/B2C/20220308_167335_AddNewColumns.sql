/*<info serverAlias="DBAFFN88-Affiliate_N88"></info>*/
/*
	Created: 20220308@Malcolm
	DB: DBAFFN88-Affiliate_N88
	Task: add new columns
*/

ALTER TABLE dbo.TierSetting
DROP CONSTRAINT PK_TierSetting
GO

ALTER TABLE dbo.TierSettingHistory
DROP CONSTRAINT PK_TierSettingHistory
GO

ALTER TABLE dbo.TierSetting
ADD GroupProductId TINYINT , IsActivePlayerSum BIT
GO

ALTER TABLE dbo.TierSettingHistory
ADD GroupProductId TINYINT NOT NULL, IsActivePlayerSum BIT
GO

UPDATE TierSettingHistory
SET GroupProductId = 0, IsActivePlayerSum = 1
GO

UPDATE TierSetting
SET GroupProductId = 0, IsActivePlayerSum = 1
GO

ALTER TABLE dbo.TierSetting
ALTER COLUMN GroupProductId TINYINT NOT NULL 
GO

ALTER TABLE dbo.TierSettingHistory
ALTER COLUMN GroupProductId TINYINT NOT NULL
GO

ALTER TABLE dbo.TierSetting
ADD CONSTRAINT PK_TierSetting PRIMARY KEY (GroupId, TierId, GroupProductId)
GO

ALTER TABLE dbo.TierSettingHistory
ADD CONSTRAINT PK_TierSettingHistory PRIMARY KEY (GroupId, MonthDate, TierId, GroupProductId)
GO