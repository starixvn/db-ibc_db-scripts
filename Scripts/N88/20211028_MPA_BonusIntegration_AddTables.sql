/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20211028@Percy
	DB: DBN88-bodb_N88
	Task: Add new tables for Bonus Integration [RedmineId: #161048]
*/
USE bodb_N88
GO

CREATE TABLE dbo.DrawLog
(
	Id				BIGINT
	,EventId		INT
	,PrizeId		INT
	,PrizeName		VARCHAR(100)
	,CustId			INT
	,SiteId			INT
	,CurrencyId		INT
	,Amount			DECIMAL(20, 4)
	,DrawEventDate	DATETIME
	,DrawTime		DATETIME
	,WinlostDate	AS CONVERT(DATE, DrawTime)
	,CONSTRAINT PK_DrawLog PRIMARY KEY NONCLUSTERED (Id)
) ON ReportData
GO

CREATE CLUSTERED INDEX CIX_DrawLog ON dbo.DrawLog (WinlostDate, SiteId) ON ReportData
GO

CREATE TABLE dbo.EventDraw
(
	EventId		INT
	,EventName	VARCHAR(100)
	,SiteId		INT
	,EventType	TINYINT
	,StartTime	DATETIME
	,EndTime	DATETIME
	,TimeZone	VARCHAR(10)
	,ResetDate	DATE
	,CreateTime	DATETIME
	,UpdateTime	DATETIME
	,CONSTRAINT PK_EventDraw PRIMARY KEY (EventId)
) ON ReportData
GO

CREATE TABLE dbo.VipUpgradeReview
(
	CustId				INT
	,CalculateMonth		DATE
	,UserName			VARCHAR(50)
	,SiteId				INT
	,CurrentVipLevel	TINYINT
	,UpgradeVipLevel	TINYINT
	,CurrencyId			INT
	,DepositAmount		DECIMAL(20, 4)
	,UpgradeAmount		DECIMAL(20, 4)
	,Status				TINYINT
	,CreateTime			DATETIME
	,SettleTime			DATETIME
	,LastUpdateTime		DATETIME
	,LastUpdateUser		VARCHAR
	,WinlostDate		AS CONVERT(DATE, SettleTime)
	,CONSTRAINT PK_VipUpgradeReview PRIMARY KEY NONCLUSTERED (CustId, CalculateMonth)
) ON ReportData
GO

CREATE CLUSTERED INDEX CIX_VipUpgradeReview ON dbo.VipUpgradeReview (WinlostDate, SiteId) ON ReportData
GO