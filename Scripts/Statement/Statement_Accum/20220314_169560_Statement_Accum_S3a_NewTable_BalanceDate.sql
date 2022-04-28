/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220314@Percy
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement_Accum [RedmineID: #169560]
		Step 3a: Change column on BalanceDate
*/

USE bodb_Report
GO

DROP TABLE BalanceDate
GO

CREATE TABLE dbo.BalanceDate
(
	FromDate	DATETIME
	,ToDate		DATETIME
	,CONSTRAINT PK_BalanceDate PRIMARY KEY (FromDate)
)
GO

-- Initialize Data
	-- BU on Saturday
	;WITH CTE_Date AS (
		SELECT CONVERT(DATETIME, '2011-12-31') AS FromDate, CONVERT(DATETIME, '2012-01-06') AS ToDate
		UNION ALL
		SELECT DATEADD(DAY, 1, ToDate), DATEADD(DAY, 7, ToDate)
		FROM CTE_Date
		WHERE DATEADD(DAY, 7, ToDate) <= '2016-05-13'
	)
	INSERT INTO dbo.BalanceDate (FromDate, ToDate)
	SELECT FromDate, ToDate FROM CTE_Date OPTION (MAXRECURSION 0)
	GO

	UPDATE dbo.BalanceDate WITH (ROWLOCK) SET ToDate = '2016-05-12' WHERE FromDate = '2016-05-07'
	GO

	-- BU on Friday
	;WITH CTE_Date AS (
		SELECT CONVERT(DATETIME, '2016-05-13') AS FromDate, CONVERT(DATETIME, '2016-05-19') AS ToDate
		UNION ALL
		SELECT DATEADD(DAY, 1, ToDate), DATEADD(DAY, 7, ToDate)
		FROM CTE_Date
		WHERE DATEADD(DAY, 7, ToDate) <= '2022-04-22'
	)
	INSERT INTO dbo.BalanceDate (FromDate, ToDate)
	SELECT FromDate, ToDate FROM CTE_Date OPTION (MAXRECURSION 0)
	GO