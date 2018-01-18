USE bodb_LicenseeReport
GO

/*
	Created: 20171215@Harper
	Description: Add new column for rptDepWinlost_ThirdParty table [RedmineID: #86640]
*/

ALTER TABLE dbo.rptDepWinlost_ThirdParty ADD ValidBetAmount MONEY

ALTER TABLE dbo.rptDepWinlost_ThirdParty ADD CommissionP MONEY

ALTER TABLE dbo.rptDepWinlost_ThirdParty ADD CommissionA MONEY