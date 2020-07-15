/*<info serverAlias="DBLIC-bodb_LicenseeReport"></info>*/

/*
	Created: 20200715@Percy
	DB: DBLIC-bodb_LicenseeReport
	Task: Add new column AWinloss for PP - Jackpot Contribution
*/

USE bodb_LicenseeReport
GO

ALTER TABLE dbo.rpt_ThirdPartyWL_ExtraGMT
	ADD AWinloss MONEY CONSTRAINT DF_rpt_ThirdPartyWL_ExtraGMT_AWinloss DEFAULT ((0))
GO