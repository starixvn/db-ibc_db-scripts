USE bodb_LicenseeReport
GO

/*
	Created: 20190510@Percy
	DB: DB053.bodb_LicenseeReport
	Task: Initialize data on DB053 bodb_LicenseeReport for web service
*/

SET IDENTITY_INSERT dbo.rptLicPerformanceAnalysis ON

INSERT INTO dbo.rptLicPerformanceAnalysis (RecordId,ReportDate,SiteId,ProductId,CurrencyId,Turnover,BetCount,LicenseeWinloss,LicensingFee,Discount,Rebate,TurnoverNoDraw,IsBillingCurrency,Adjustment)
SELECT RecordId,ReportDate,SiteId,ProductId,CurrencyId,Turnover,BetCount,LicenseeWinloss,LicensingFee,Discount,Rebate,TurnoverNoDraw,IsBillingCurrency,Adjustment
FROM DB052.bodb_LicenseeReport.dbo.rptLicPerformanceAnalysis WITH (NOLOCK)

SET IDENTITY_INSERT dbo.rptLicPerformanceAnalysis OFF