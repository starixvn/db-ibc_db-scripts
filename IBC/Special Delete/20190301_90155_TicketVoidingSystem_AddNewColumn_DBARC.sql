/*
	Created: 20190301@Kathy
	DB: DBARC.bodb_archive
	Task: add new column for ticket voiding system [Redmine:#90155]
*/


USE bodb_archive
GO

ALTER TABLE dbo.zzzbettrans ADD VoidingHistoryId INT
GO