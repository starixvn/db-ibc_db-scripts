/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220412@Percy
	DB: DBN88-bodb_N88
	Task: New tables
		- ReferralMLog for new bonus
		- CustBonusSummary for SUM bonus
		- BonusImportStatus for job import SUM
*/
USE bodb_N88
GO

CREATE TABLE dbo.ReferralMLog
(
	Id				INT
	,CustId			INT
	,CurrencyId		INT
	,Username		VARCHAR(50)
	,SiteId			INT
	,RefferalAmount	DECIMAL(20,4)
	,Memo			VARCHAR(200)
	,RelId			BIGINT
	,CreateTime		DATETIME
	,WinlostDate	AS CONVERT(DATE, CreateTime)
	,CONSTRAINT PK_ReferralMLog PRIMARY KEY NONCLUSTERED (Id)
) ON ReportData
GO

CREATE CLUSTERED INDEX CIX_ReferralMLog ON dbo.ReferralMLog (WinlostDate, SiteId) ON ReportData
GO

CREATE TABLE dbo.CustBonusSummary
(
	Id				INT IDENTITY(1, 1) NOT NULL
	,CustId			INT
	,CurrencyId		INT
	,SiteId			INT
	,DataSource		VARCHAR(128)
	,BonusType		SMALLINT
	,BonusStatus	TINYINT CONSTRAINT DF_CustBonusSummary_BonusStatus DEFAULT(0)
	,BonusCode		VARCHAR(50)
	,BonusTime		DATETIME
	,BonusAmount	MONEY
	,CONSTRAINT PK_CustBonusSummary PRIMARY KEY NONCLUSTERED (Id)
) ON ReportData
GO

CREATE CLUSTERED INDEX CIX_CustBonusSummary ON dbo.CustBonusSummary (BonusTime, SiteId)
GO

CREATE TABLE dbo.BonusImportStatus
(
	DataSource		VARCHAR(128)
	,WinlostDate	DATE
	,CheckInTime	DATETIME CONSTRAINT DF_BonusImportStatus_CheckInTime DEFAULT(GETDATE())
	,Status			VARCHAR(10) CONSTRAINT DF_BonusImportStatus_Status DEFAULT('running')
	,FinishedTime	DATETIME
) ON ReportData
GO

CREATE CLUSTERED INDEX CIX_BonusImportStatus ON dbo.BonusImportStatus (Status, CheckInTime) ON ReportData
GO