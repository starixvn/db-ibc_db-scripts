/*<info serverAlias="DBN88-bodb_N88"></info>*/
/*
	Created: 20220315@Percy
	DB: DBN88-bodb_N88
	Task: New table CustVerificationReward/CustVerificationRewardDetail for new bonus
*/
USE bodb_N88
GO

CREATE TABLE dbo.CustVerificationReward
(
	CustId INT NOT NULL
	,SiteId INT NOT NULL
	,CurrencyId INT
	,PhoneReward DECIMAL(20, 4)
	,PhoneRewardTime DATETIME
	,EmailReward DECIMAL(20, 4)
	,EmailRewardTime DATETIME
	,CONSTRAINT PK_CustVerificationReward PRIMARY KEY (CustId)
) ON ReportData
GO


CREATE TABLE dbo.CustVerificationRewardDetail
(
	CustId INT NOT NULL
	,SiteId INT NOT NULL
	,CurrencyId INT
	,RewardType TINYINT
	,RewardAmount MONEY
	,RewardTime DATETIME
	,WinlostDate AS CONVERT(DATE, RewardTime)
	,CONSTRAINT PK_CustVerificationRewardDetail PRIMARY KEY NONCLUSTERED (CustId, RewardType)
) ON ReportData
GO

CREATE CLUSTERED INDEX CIX_CustVerificationRewardDetail ON dbo.CustVerificationRewardDetail (WinlostDate, SiteId) ON ReportData
GO