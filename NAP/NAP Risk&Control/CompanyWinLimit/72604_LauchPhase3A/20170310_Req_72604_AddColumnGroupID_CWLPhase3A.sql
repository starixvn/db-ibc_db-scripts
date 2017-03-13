/*
	Created: 20170310@Helen
	Task: CWL Phase 3a - Amendments of phase 3 - https://nexdev.net/issues/72604
	DB:DBCUST/custdb
*/
USE CustDB
GO
ALTER TABLE dbo.WinLimit_CustGameMonitoring ADD GroupID INT
GO
ALTER TABLE dbo.WinLimit_CustGameMonitoring_History ADD GroupID INT