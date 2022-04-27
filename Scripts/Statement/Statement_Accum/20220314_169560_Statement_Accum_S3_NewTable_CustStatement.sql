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
	AccDate DATETIME
	,IsBal BIT
	,CONSTRAINT PK_BalanceDate PRIMARY KEY (AccDate)
)
GO

-- Initialize Data
;WITH CTE_Date AS (
	SELECT CONVERT(DATETIME, '2011-12-31') AS accdate
	UNION ALL
	SELECT DATEADD(DAY, 1, accdate)
	FROM CTE_Date
	WHERE accdate < '2022-04-22'
)
INSERT INTO dbo.BalanceDate (AccDate, IsBal)
SELECT AccDate, CASE
					WHEN accdate <= '2016-05-07' AND DATEPART(WEEKDAY, accdate) = 6 THEN 1 -- Saturday	- 1 to get Closing Balance
					WHEN accdate >= '2016-05-08' AND DATEPART(WEEKDAY, accdate) = 5 THEN 1 -- Friday	- 1 to get Closing Balance
					ELSE 0 END
FROM CTE_Date
OPTION (MAXRECURSION 0)
GO

INSERT INTO dbo.Cust_Statement (CustId, CreatedDate)
SELECT CustId, Creatdate FROM bodb02.dbo.Customer WITH (NOLOCK) WHERE roleid BETWEEN 1 AND 4
GO