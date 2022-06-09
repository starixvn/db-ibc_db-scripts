/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220314@Percy
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement_Accum [RedmineID: #169560]
		Step 3: Add new table Cust_Statement to store customer info
*/

USE bodb_Report
GO

CREATE TABLE dbo.Cust_Statement
(
	Id				INT IDENTITY(1, 1)
	,CustId			INT
	,CreatedDate	DATE
	,StartDate		DATETIME
	,EndDate		DATETIME
	,IsDiffAmt		BIT CONSTRAINT DF_Cust_Statement_IsDiffAmt DEFAULT (0)
	,IsFinished		BIT CONSTRAINT DF_Cust_Statement_IsFinished DEFAULT (0)
	,CONSTRAINT PK_Cust_Statement PRIMARY KEY (CustId)
)
GO

CREATE INDEX IX_IsFinished ON dbo.Cust_Statement (IsFinished, CreatedDate)
GO

CREATE TABLE dbo.BalanceDate
(
	FromDate	DATETIME
	,ToDate		DATETIME
	,CONSTRAINT PK_BalanceDate PRIMARY KEY (FromDate)
)
GO

-- Initialize Data
;WITH CTE_Date AS (
	SELECT CONVERT(DATETIME, '2022-04-29') AS FromDate, CONVERT(DATETIME, '2022-05-05') AS ToDate
	UNION ALL
	SELECT DATEADD(DAY, 1, ToDate), DATEADD(DAY, 7, ToDate)
	FROM CTE_Date
	WHERE DATEADD(DAY, 7, ToDate) <= '2022-05-27'
)
INSERT INTO dbo.BalanceDate (FromDate, ToDate)
SELECT FromDate, ToDate FROM CTE_Date OPTION (MAXRECURSION 0)
GO

-- 6,670,765 rows
INSERT INTO dbo.Cust_Statement (CustId, CreatedDate)
SELECT CustId, '2022-04-29' FROM dbo.Statement_Accum WITH (NOLOCK) WHERE AccDate = '2022-05-06'
GO