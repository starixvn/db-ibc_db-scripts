USE bodb02
GO

/*

	Created: 20181019@Kathy
	DB: DBPRO/bodb02
	Task: Add new column SettlementStatus in table Match/Match14 [Redmine:#102028]
*/

-- Remove unused column in table Match_Remark
ALTER TABLE dbo.match_remark DROP CONSTRAINT DF_match_remark_SettlementStatus
GO
ALTER TABLE dbo.match_remark DROP COLUMN SettlementStatus
GO

-- Add new column in match
ALTER TABLE dbo.match ADD [SettlementStatus] [tinyint] CONSTRAINT [DF_match_SettlementStatus]  DEFAULT ((0))
GO
-- Add new column in match14
ALTER TABLE dbo.match14 ADD [SettlementStatus] [tinyint] CONSTRAINT [DF_match14_SettlementStatus]  DEFAULT ((0))
