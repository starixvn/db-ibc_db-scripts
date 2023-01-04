/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220504@Percy
	DB: DBRPT-bodb_Report
	Task: Gen data for Statement_Accum [RedmineID: #169560]
		Step 6: Add date range
*/
USE bodb_Report 
GO

/*
	SELECT TOP 10 * FROM dbo.BalanceDate WITH (NOLOCK)
	ORDER BY FromDate DESC
*/

INSERT INTO dbo.BalanceDate (FromDate, ToDate)
VALUES ('2022-04-22', '2022-04-28')