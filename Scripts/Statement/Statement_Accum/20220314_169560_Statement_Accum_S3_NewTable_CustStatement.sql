/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220314@Percy
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement_Accum [RedmineID: #169560]
		Step 3: New table Cust_Statement & BalanceDate
*/

USE bodb_Report
GO

-- Cust_Statement
CREATE TABLE dbo.Cust_Statement
(
	Id				INT IDENTITY(1, 1)
	,CustId			INT NOT NULL
	,CreatedDate	DATE
	,StartDate		DATETIME
	,EndDate		DATETIME
	,IsDiffAmt		BIT
	,IsFinished		BIT
	,CONSTRAINT PK_Cust_Statement PRIMARY KEY (CustId)
)
GO
CREATE NONCLUSTERED INDEX IX_IsFinished ON dbo.Cust_Statement (IsFinished, CreatedDate)
GO

-- BalanceDate
CREATE TABLE dbo.BalanceDate
(
	FromDate	DATETIME
	,ToDate		DATETIME
	,CONSTRAINT PK_BalanceDate PRIMARY KEY (FromDate)
)
GO