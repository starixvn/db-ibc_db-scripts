USE CustDB
GO
/*
	https://nexdev.net/issues/59623
	Get MaxCustID
	Run on DBCUST
*/

SELECT MAX(custid) as MaxCustID FROM custInfo WITH(NOLOCK)

GO

