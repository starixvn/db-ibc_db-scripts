USE [bodb_Summary]
GO

/*
	Created: 20180607@Percy
	DB: DBSUM - bodb_Summary
	Task: Change data type of Contribution column: MONEY to DECIMAL(19,8)
*/

ALTER TABLE [dbo].[rptProgressiveGamesContribution]
	DROP CONSTRAINT [DF_rptProgressiveGamesContribution_Contribution]

ALTER TABLE [dbo].[rptProgressiveGamesContribution]
	ALTER COLUMN Contribution DECIMAL (19,8) NULL

ALTER TABLE [dbo].[rptProgressiveGamesContribution]
	ADD CONSTRAINT [DF_rptProgressiveGamesContribution_Contribution] DEFAULT ((0)) FOR Contribution


----- tmp table
ALTER TABLE [dbo].[rptProgressiveGamesContribution_tmp]
	ALTER COLUMN Contribution DECIMAL (19,8) NULL