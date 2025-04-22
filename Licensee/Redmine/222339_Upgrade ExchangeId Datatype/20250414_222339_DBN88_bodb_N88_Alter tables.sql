/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBLIC-bodb_LicenseeReportArchive
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

USE bodb_N88
GO

ALTER TABLE AdjustmentInfo ALTER COLUMN CurrencyId SMALLINT 
GO
ALTER TABLE BonusInfo ALTER COLUMN CurrencyId SMALLINT 
GO
ALTER TABLE RebateMLog ALTER COLUMN CurrencyId SMALLINT 
GO
ALTER TABLE ReferralLog ALTER COLUMN CurrencyId SMALLINT 
GO 
ALTER TABLE Customer ALTER COLUMN CurrencyId SMALLINT 
GO
ALTER TABLE DepositInfo ALTER COLUMN CurrencyId SMALLINT 
GO

ALTER TABLE WithdrawalInfo ALTER COLUMN CurrencyId SMALLINT 
GO

/****** Object:  Index [PK_PromotionSpecific]    Script Date: 4/10/2025 10:35:19 PM ******/
ALTER TABLE [dbo].[PromotionSpecific] DROP CONSTRAINT [PK_PromotionSpecific]
GO

ALTER TABLE PromotionSpecific ALTER COLUMN CurrencyId SMALLINT NOT NULL
GO

/****** Object:  Index [PK_PromotionSpecific]    Script Date: 4/10/2025 10:35:19 PM ******/
ALTER TABLE [dbo].[PromotionSpecific] ADD  CONSTRAINT [PK_PromotionSpecific] PRIMARY KEY NONCLUSTERED 
(
	[BonusCode] ASC,
	[CurrencyId] ASC,
	[SiteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [ReportData]
GO

