/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220314@Percy
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement_Accum [RedmineID: #169560]
		Step 3: Add new table Cust_Statement to store customer info
*/

USE bodb_Report
GO

-- Clean up data
DELETE dbo.Cust_Statement
GO

-- Add new data
CREATE TABLE #__CustStatement (CustId INT)

INSERT INTO #__CustStatement (CustId)
SELECT CustId
FROM dbo.Statement_Accum WITH (NOLOCK)
WHERE AccDate = '2022-06-10'

INSERT INTO dbo.Cust_Statement (CustId, CreatedDate)
SELECT c.CustId, '2022-05-27'
FROM #__CustStatement c
	LEFT JOIN bodb02.dbo.Transfer t WITH (NOLOCK)
		ON c.CustId = t.CustId
			AND t.Bettype = 20000
			AND t.WinlostDate = '2022-06-10'
WHERE t.CustId IS NULL

INSERT INTO dbo.Cust_Statement (CustId, CreatedDate)
SELECT t.CustId, '2022-05-27'
FROM bodb02.dbo.Transfer t WITH (NOLOCK)
	LEFT JOIN #__CustStatement c
		ON t.CustId = c.CustId
WHERE t.Bettype = 20000
	AND t.WinlostDate = '2022-06-10'
	AND c.CustId IS NULL

DROP TABLE #__CustStatement