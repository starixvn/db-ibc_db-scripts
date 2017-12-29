USE bodb_LicenseeReport
GO

/*
	Created: 20171215@Harper
	Description: Add new column for rpt_BettingByProduct table [RedmineID: #86640]
*/

ALTER TABLE dbo.rpt_BettingByProduct ADD ValidBetAmount MONEY
