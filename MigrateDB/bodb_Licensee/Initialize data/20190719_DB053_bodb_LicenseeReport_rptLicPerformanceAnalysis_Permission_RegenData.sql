USE bodb_LicenseeReport
GO

/*
	Created: 20190719@Percy
	DB: DB053.bodb_LicenseeReport
	Task:
		1. Grant permission on rptLicPerformanceAnalysis @DB053
		2. Re-import data from Jun 2019
*/

-- 1. Grant permission
GRANT DELETE ON dbo.rptLicPerformanceAnalysis TO bodbAdminNet AS dbo
GO

GRANT INSERT ON dbo.rptLicPerformanceAnalysis TO bodbAdminNet AS dbo
GO

-- 2. Re-import data from Jun 2019
-- 810 rows affected
SET IDENTITY_INSERT dbo.rptLicPerformanceAnalysis ON

INSERT INTO dbo.rptLicPerformanceAnalysis (RecordId,ReportDate,SiteId,ProductId,CurrencyId,Turnover,BetCount,LicenseeWinloss,LicensingFee,Discount,Rebate,TurnoverNoDraw,IsBillingCurrency,Adjustment)
SELECT RecordId,ReportDate,SiteId,ProductId,CurrencyId,Turnover,BetCount,LicenseeWinloss,LicensingFee,Discount,Rebate,TurnoverNoDraw,IsBillingCurrency,Adjustment
FROM DB052.bodb_LicenseeReport.dbo.rptLicPerformanceAnalysis WITH (NOLOCK)
WHERE ReportDate >= '2019-06-01'

SET IDENTITY_INSERT dbo.rptLicPerformanceAnalysis OFF
