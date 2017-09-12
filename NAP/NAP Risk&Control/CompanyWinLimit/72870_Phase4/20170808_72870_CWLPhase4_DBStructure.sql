/*
	Created: 20170808@Helen
	Task: CWL - phase 4 - [Redmine: 81078]
	DB: DBCUST/CUSTDB - DB06 - DBMNL
	
	WinLimit_CustGameMonitoring: 5541 rows
	WinLimit_CustGameMonitoring_History: 6371 rows

*/

USE CustDB
GO

---------------Change Primary Key, Create New Column BettypeIDList and remove column BettypeID FOR TABLE WinLimit_CustGameMonitoring --------------------------------
/* Step 1:  RUN ON DBCUST, DB06, DBMNL */
ALTER TABLE dbo.WinLimit_CustGameMonitoring
	DROP CONSTRAINT PK_WinLimit_CustGameMonitoring
GO

ALTER TABLE dbo.WinLimit_CustGameMonitoring 
ALTER COLUMN GroupID INT NOT NULL

GO

ALTER TABLE dbo.WinLimit_CustGameMonitoring 
ADD CONSTRAINT PK_WinLimit_CustGameMonitoring PRIMARY KEY (CustID, ProductID,GroupID,WinlostDate)

GO

ALTER TABLE dbo.WinLimit_CustGameMonitoring ADD BettypeIDList VARCHAR(500)

GO

ALTER TABLE dbo.WinLimit_CustGameMonitoring DROP COLUMN BettypeID

GO
ALTER TABLE dbo.Winlimit_LevelSetting ADD LevelOrder TINYINT
GO
--------------- Change Primary Key, Create New Column BettypeIDList and remove column BettypeID FOR TABLE WinLimit_CustGameMonitoring_History --------------------------------
/* Step 2: ONLY RUN ON DBCUST */
ALTER TABLE dbo.WinLimit_CustGameMonitoring_History
	DROP CONSTRAINT PK_WinLimit_CustGameMonitoring_History
GO

ALTER TABLE dbo.WinLimit_CustGameMonitoring_History 
ALTER COLUMN GroupID INT NOT NULL

GO

DROP INDEX dbo.WinLimit_CustGameMonitoring_History.CIX_CustID_ProductID_BetTypeID_WinlostDate

GO

CREATE CLUSTERED INDEX CIX_CustID_ProductID_BetTypeID_WinlostDate ON dbo.WinLimit_CustGameMonitoring_History (CustID, ProductID,GroupID,WinlostDate)

GO

ALTER TABLE dbo.WinLimit_CustGameMonitoring_History ADD BettypeIDList VARCHAR(500)

GO

ALTER TABLE dbo.WinLimit_CustGameMonitoring_History DROP COLUMN BettypeID

GO

