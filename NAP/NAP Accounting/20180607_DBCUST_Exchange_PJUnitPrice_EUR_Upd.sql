USE [CustDB]
GO

/*
	Created: 2018-06-07
	DB: DBCUST - CustDB
	Task: Support update PJUnitPrice value of EUR currency (exchangeId = 78) [RedmineID: #96639]
*/

/*
SELECT *
FROM dbo.exchange WITH (NOLOCK)
WHERE exchangeid = 78
*/

UPDATE dbo.exchange WITH (ROWLOCK, UPDLOCK)
SET PJUnitPrice = 0.2075
WHERE exchangeid = 78
GO