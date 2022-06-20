/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220314@Percy
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement_Accum [RedmineID: #169560]
		Step 3a: Initialize data on BalanceDate
*/

USE bodb_Report
GO

-- Clean up data
DELETE dbo.BalanceDate
GO

-- Add new data
;WITH CTE_Date AS (
	SELECT CONVERT(DATETIME, '2022-05-27') AS FromDate, CONVERT(DATETIME, '2022-06-02') AS ToDate
	UNION ALL
	SELECT DATEADD(DAY, 1, ToDate), DATEADD(DAY, 7, ToDate)
	FROM CTE_Date
	WHERE DATEADD(DAY, 7, ToDate) <= '2022-06-10'
)
INSERT INTO dbo.BalanceDate (FromDate, ToDate)
SELECT FromDate, ToDate FROM CTE_Date OPTION (MAXRECURSION 0)
GO