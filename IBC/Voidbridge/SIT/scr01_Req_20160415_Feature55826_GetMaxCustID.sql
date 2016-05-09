USE CustDB
GO
/*
	https://redmine.nexcel.vn/issues/55826
	Get MaxCustID
	Run on DBCUST
*/

SELECT MAX(custid) as MaxCustID FROM custInfo WITH(NOLOCK)

GO