/*
    Created: 20200108@Malcolm
	Task: Separate setting and notification into Live/Non-Live and bettypes - [Redmine: #126348]
	DB: bodb02 - Replicated Server FOR CustDB_ExchangeDaily 
*/
USE BODB02
GO
TRUNCATE TABLE TOControl_GlobalSetting
GO
ALTER TABLE TOControl_GlobalSetting DROP COLUMN ProfileID
GO
ALTER TABLE [dbo].TOControl_GlobalSetting ADD ProfileID SMALLINT NOT NULL
GO
ALTER TABLE [dbo].[TOControl_GlobalSetting] 
DROP CONSTRAINT  [PK_TO_ControlglobalSetting]
ALTER TABLE [dbo].[TOControl_GlobalSetting] 
ADD CONSTRAINT [PK_TO_ControlglobalSetting] 
PRIMARY KEY ([CustID],[Sporttype],[IsGroupHeadLine],[ProfileID]) 
