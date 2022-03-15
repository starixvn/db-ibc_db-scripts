/*<info serverAlias="DBAFFN88-Affiliate_N88,DBAFFN8B-Affiliate_N8B,DBAFFN8G-Affiliate_N8G"></info>*/
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
ADD GroupProductId TINYINT, IsActivePlayerSum BIT 
GO

UPDATE TierSettingHistory WITH(ROWLOCK)
SET GroupProductId = 0, IsActivePlayerSum = 1
GO

UPDATE TierSetting WITH(ROWLOCK)
SET GroupProductId = 0, IsActivePlayerSum = 1
GO

ALTER TABLE dbo.TierSetting
ALTER COLUMN GroupProductId TINYINT NOT NULL 
GO

ALTER TABLE dbo.TierSettingHistory
ALTER COLUMN GroupProductId TINYINT NOT NULL
GO

ALTER TABLE dbo.TierSetting
ADD CONSTRAINT PK_TierSetting PRIMARY KEY (GroupId, GroupProductId, TierId)
GO

ALTER TABLE dbo.TierSettingHistory
ADD CONSTRAINT PK_TierSettingHistory PRIMARY KEY (GroupId, MonthDate, GroupProductId, TierId)
GO