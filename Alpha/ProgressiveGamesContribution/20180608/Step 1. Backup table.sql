USE [bodb_Summary]
GO

/*
	Created: 20180608@Percy
	Task: Regen data for rptProgressiveGamesContribution [Redmine: #96053]
	DB: DBSUM.bodb_Summary

	Step 1: Backup table
*/

SELECT *
INTO dbo.rptProgressiveGamesContribution_20180608_bk
FROM dbo.rptProgressiveGamesContribution WITH (NOLOCK)