/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20211028@Percy
	DB: DBN88-bodb_N88
	Task: Add new tables for Bonus Integration [RedmineId: #161048]
*/
USE bodb_N88
GO
CREATE TABLE dbo.LogAdminAdjustWallet
(
	TransferId INT
	,TransId VARCHAR(30)
	,ThirdId VARCHAR(50)
	,TpId INT
	,CustId INT
	,UserName VARCHAR(30)
	,SiteId INT
	,CurrencyId INT
	,Direction TINYINT
	,Amount DECIMAL(20,4)
	,Memo VARCHAR(200)
	,Status TINYINT
	,CreateTime DATETIME
	,Operator VARCHAR(30)
	,Remarks VARCHAR(100)
	,WinlostDate AS CONVERT(DATE, CreateTime)
	,CONSTRAINT PK_LogAdminAdjustWallet PRIMARY KEY NONCLUSTERED (TransferId)
) ON ReportData
GO

CREATE CLUSTERED INDEX CIX_LogAdminAdjustWallet ON dbo.LogAdminAdjustWallet (WinlostDate) ON ReportData
GO