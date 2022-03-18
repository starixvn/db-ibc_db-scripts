/*<info serverAlias="DBRPT-bodb_Report"></info>*/
/*
	Created: 20220314@Percy
	DB: DBRPT-bodb_Report
	Task: New table Statement_Accum [RedmineID: #169560]
		Step 2: New table
*/

USE bodb_Report
GO

CREATE TABLE dbo.Statement_Accum
(
	CustId		INT
	,AccDate	DATETIME
	,TotalAmt	MONEY
	,CONSTRAINT PK_Statement_Accum PRIMARY KEY CLUSTERED
	(
		AccDate ASC
		,CustId ASC
	)
) ON PS_Statement_Accum_Yearly (AccDate)
GO