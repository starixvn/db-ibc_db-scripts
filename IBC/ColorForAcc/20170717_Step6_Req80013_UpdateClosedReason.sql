
/*
	Created: Winnie	
	Task:  Update ClosedReason on CustLoginInfo
	DB: DBCUST/CustDB, DB06/bodb02
	Date: 20170719
*/ 

UPDATE c SET c.ClosedReason= t.ClosedReason
FROM dbo.CustLoginInfo c WITH (ROWLOCK, UPDLOCK)
INNER JOIN TempClosedReason t WITH(NOLOCK) ON c.CustID=t.CustID				
WHERE  t.CustID BETWEEN @MinCust AND @CrrCust AND t.ClosedReason=2
