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
INSERT INTO dbo.Cust_Statement (CustId, CreatedDate)
SELECT DISTINCT CustId, '2022-04-29' FROM dbo.Statement_Accum WITH (NOLOCK) WHERE AccDate BETWEEN '2022-04-29' AND '2022-06-03'
GO