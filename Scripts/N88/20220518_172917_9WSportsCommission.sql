/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220518@Percy
	DB: DBN88-bodb_N88
	Task: Add new table for 9W Sports product
*/
USE bodb_N88
GO

-- TpReport9W
CREATE TABLE dbo.TpReport9W
(
	SQ					BIGINT NOT NULL
	,userId				VARCHAR(20)
	,agentId			VARCHAR(50)
	,eventId			VARCHAR(20)
	,marketId			VARCHAR(20)
	,settledDate		DATETIME 
	,resettledDate		DATETIME
	,profitLoss			DECIMAL(20,4)
	,marketTotal		DECIMAL(20,4)
	,commission			DECIMAL(20,4)
	,agentCommission	DECIMAL(20,4)
	,stakeTotal			DECIMAL(20,4)
	,CreateTime			DATETIME
	,UpdateTime			DATETIME
	,CustId				INT
	,CurrencyId			INT
	,SiteId				INT
	,CONSTRAINT PK_TpReport9W PRIMARY KEY NONCLUSTERED (SQ)
) ON ReportData
GO

CREATE NONCLUSTERED INDEX IX_TpReport9W ON dbo.TpReport9W (userId, eventId, marketId, settledDate) ON ReportData
GO

CREATE CLUSTERED INDEX CIX_TpReport9W ON dbo.TpReport9W (settledDate, CustId) ON ReportData
GO

-- TpWager9W
CREATE TABLE dbo.TpWager9W
(
	betId				VARCHAR(50)
	,userId				VARCHAR(20)
	,agentId			VARCHAR(50)
	,eventId			VARCHAR(10)
	,marketId			VARCHAR(50)
	,matchSettledDate	DATETIME
	,settledDate		DATETIME
	,betStatus			VARCHAR(20)
	,matchStake			DECIMAL(20,4)
	,profitLoss			DECIMAL(20,4)
	,CreateTime			DATETIME
	,UpdateTime			DATETIME
	,CONSTRAINT PK_TpWager9W PRIMARY KEY (betId)
) ON ReportData
GO

CREATE NONCLUSTERED INDEX CIX_TpWager9W ON dbo.TpWager9W (userId, eventId, marketId) ON ReportData
GO