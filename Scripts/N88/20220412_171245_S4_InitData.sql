/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220412@Percy
	DB: DBN88-bodb_N88
	Task: Initialize data for job import CustBonusSummary [RedmineID: #171245]
*/
USE bodb_N88
GO

-- AdjustmentInfo
INSERT INTO dbo.BonusImportStatus (DataSource, WinlostDate)
SELECT DISTINCT 'AdjustmentInfo', WinlostDate FROM dbo.AdjustmentInfo WITH (NOLOCK)

-- BonusInfo
INSERT INTO dbo.BonusImportStatus (DataSource, WinlostDate)
SELECT DISTINCT 'BonusInfo', WinlostDate FROM dbo.BonusInfo WITH (NOLOCK)

-- CustVerificationReward
INSERT INTO dbo.BonusImportStatus (DataSource, WinlostDate)
SELECT DISTINCT 'CustVerificationReward', WinlostDate FROM dbo.CustVerificationRewardDetail WITH (NOLOCK)

-- DrawLog
INSERT INTO dbo.BonusImportStatus (DataSource, WinlostDate)
SELECT DISTINCT 'DrawLog', WinlostDate FROM dbo.DrawLog WITH (NOLOCK)

-- LogAdminAdjustWallet
INSERT INTO dbo.BonusImportStatus (DataSource, WinlostDate)
SELECT DISTINCT 'LogAdminAdjustWallet', WinlostDate FROM dbo.LogAdminAdjustWallet WITH (NOLOCK)

-- RebateMLog
INSERT INTO dbo.BonusImportStatus (DataSource, WinlostDate)
SELECT DISTINCT 'RebateMLog', WinlostDate FROM dbo.RebateMLog WITH (NOLOCK)

-- ReferralMLog
INSERT INTO dbo.BonusImportStatus (DataSource, WinlostDate)
SELECT DISTINCT 'ReferralMLog', WinlostDate FROM dbo.ReferralMLog WITH (NOLOCK)

-- VipUpgradeReview
INSERT INTO dbo.BonusImportStatus (DataSource, WinlostDate)
SELECT DISTINCT 'VipUpgradeReview', WinlostDate FROM dbo.VipUpgradeReview WITH (NOLOCK)