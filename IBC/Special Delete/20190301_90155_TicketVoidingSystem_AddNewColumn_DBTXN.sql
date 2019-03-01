/*
	Created: 20190301@Kathy
	DB: DBTXN.bodb02
	Task: add new column for ticket voiding system [Redmine:#90155]
*/
USE bodb02
GO

ALTER TABLE dbo.zzzbettrans ADD VoidingHistoryId INT
GO
ALTER TABLE dbo.zzzbettransm ADD VoidingHistoryId INT
GO