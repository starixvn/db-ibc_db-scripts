USE bodb02
GO
/*
	https://nexdev.net/issues/60809
	Get MaxCustID
	Run on DB06
*/

SELECT MAX(custid) as MaxCustID FROM custInfo WITH(NOLOCK)

GO

