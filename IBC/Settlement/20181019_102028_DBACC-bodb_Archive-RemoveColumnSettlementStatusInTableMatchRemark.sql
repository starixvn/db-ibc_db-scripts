USE bodb_Archive
GO

/*

	Created: 20181019@Kathy
	DB: DBACC/bodb_Archive
	Task: Remove column SettlementStatus in table match_remark [Redmine:#102028]
*/

-- Remove unused column in table Match_Remark
ALTER TABLE match_remark DROP CONSTRAINT DF_match_remark_SettlementStatus
GO
ALTER TABLE match_remark DROP COLUMN SettlementStatus
GO