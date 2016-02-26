USE CustDB
GO
/*
	https://redmine.nexcel.vn/issues/51753
	get maxcustid
	run on dbcust
*/

SELECT MAX(custid) as MaxCustID FROM custInfo WITH (NOLOCK)

GO