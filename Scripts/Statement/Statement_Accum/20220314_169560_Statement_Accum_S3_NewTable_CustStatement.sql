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
	Id			INT IDENTITY(1, 1)
	,CustId		INT
	,StartDate	DATETIME
	,EndDate	DATETIME
	,IsDiffAmt	BIT CONSTRAINT DF_Cust_Statement_IsDiffAmt DEFAULT (0)
	,IsFinished	BIT CONSTRAINT DF_Cust_Statement_IsFinished DEFAULT (0)
	,CONSTRAINT PK_Cust_Statement PRIMARY KEY (CustId)
)
GO

INSERT INTO dbo.Cust_Statement (CustId)
SELECT CustId FROM bodb02.dbo.Customer WITH (NOLOCK) WHERE roleid BETWEEN 1 AND 4
GO