/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20250414@Kelvin
	DB: DBLIC-bodb_LicenseeReportArchive
	Task: LAP/MPA - Upgrade ExchangeId Datatype [RedmineID: #222339]
*/

USE bodb_N88
GO
DROP INDEX [IX_RPT_WL_DepositTest] ON [dbo].[DepositInfoTest]
GO

ALTER TABLE DepositInfoTest ALTER COLUMN CurrencyId SMALLINT 
GO

CREATE NONCLUSTERED INDEX [IX_RPT_WL_DepositTest] ON [dbo].[DepositInfoTest]
(
	[Status] ASC,
	[CreateTime] ASC,
	[WinlostDate] ASC
)
INCLUDE([CustId],[CurrencyId],[SiteId],[Amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [ReportData]
GO
