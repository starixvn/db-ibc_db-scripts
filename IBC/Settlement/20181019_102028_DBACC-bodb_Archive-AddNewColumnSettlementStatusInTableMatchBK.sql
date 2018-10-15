USE bodb_Archive
GO

/*

	Created: 20181019@Kathy
	DB: DBACC/bodb_Archive
	Task: Add new column SettlementStatus in table match_bk [Redmine:#102028]
*/

-- Remove unused column in table Match_Remark
ALTER TABLE match_remark DROP CONSTRAINT DF_match_remark_SettlementStatus
GO
ALTER TABLE match_remark DROP COLUMN SettlementStatus
GO

-- Add new column in match
ALTER TABLE dbo.match_bk ADD [SettlementStatus] [tinyint] CONSTRAINT [DF_match_bk_SettlementStatus]  DEFAULT ((0))