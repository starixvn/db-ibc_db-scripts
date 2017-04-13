/*
	Created: 20170413@Helen
	Task: https://nexdev.net/issues/72339
	DB: DBCUST/CUSTDB
*/

USE CustDB

GO

CREATE TABLE CustDirectAccount 
(
	CustID INT 
	, ProcessedBy VARCHAR (100)
	, Boss  VARCHAR (100)
	, RequestedBy VARCHAR(100)
	, ApprovedBy VARCHAR(100)
	, CONSTRAINT [PK_CustDirectAccount] PRIMARY KEY CLUSTERED (
	[CustID] ASC

)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [table_customer]
) ON [table_customer]

