/*
	Created: 20170808@Helen
	Task: CWL - phase 4 - [Redmine: 81078]
	DB: DBCUST/CUSTDB
*/

USE CustDB
GO

---------------Change Primary Key, Create New Column BettypeIDList and remove column BettypeID FOR TABLE WinLimit_CustGameMonitoring --------------------------------
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
--------------- Change Primary Key, Create New Column BettypeIDList and remove column BettypeID FOR TABLE WinLimit_CustGameMonitoring_History --------------------------------
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

