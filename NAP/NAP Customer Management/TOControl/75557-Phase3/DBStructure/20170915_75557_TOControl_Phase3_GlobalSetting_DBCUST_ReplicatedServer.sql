/*
	Created: 20170915@Helen
	Task: SMA Turnover Control - Enhancement requests from phase 2 [RedmineID:75557]
	DB: DBCUST/CUSTDB & Replicated server
*/

----------------------- TOControl_GlobalSetting ----------------
ALTER TABLE dbo.TOControl_GlobalSetting
	DROP CONSTRAINT PK_TO_ControlglobalSetting
GO

ALTER TABLE dbo.TOControl_GlobalSetting 
ADD Sporttype SMALLINT

GO

ALTER TABLE dbo.TOControl_GlobalSetting 
ADD IsGroupHeadLine BIT
GO

UPDATE TOControl_GlobalSetting SET Sporttype = 1, IsGroupHeadline = 0

GO

ALTER TABLE dbo.TOControl_GlobalSetting 
ALTER COLUMN Sporttype SMALLINT NOT NULL

GO

ALTER TABLE dbo.TOControl_GlobalSetting 
ALTER COLUMN IsGroupHeadLine BIT NOT NULL

GO

ALTER TABLE dbo.TOControl_GlobalSetting 
ADD CONSTRAINT PK_TO_ControlglobalSetting PRIMARY KEY (CustID,Sporttype,IsGroupHeadLine)


GO
