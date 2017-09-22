/*
	Created: 20170915@Helen
	Task: SMA Turnover Control - Enhancement requests from phase 2 [RedmineID:75557]
	DB: DBCUST/CUSTDB
*/
USE CustDB
GO
------------------------ TOControl_Setting ------------------------
ALTER TABLE dbo.TOControl_Setting
	DROP CONSTRAINT PK_TOControl_Setting
GO

ALTER TABLE dbo.TOControl_Setting 
ADD IsGroupHeadLine BIT

GO
UPDATE dbo.TOControl_Setting SET IsGroupHeadLine = 0
GO

ALTER TABLE dbo.TOControl_Setting 
ALTER COLUMN IsGroupHeadLine BIT NOT NULL
GO
ALTER TABLE dbo.TOControl_Setting 
ADD CONSTRAINT PK_TOControl_Setting PRIMARY KEY (CustID,matchid,IsGroupHeadLine)
GO
