
/*
	Created: Winnie	
	Task:  Update ClosedReason on CustLoginInfo
	DB: DBCUST/CustDB
	Date: 20170719
*/ 

UPDATE c SET c.ClosedReason= t.ClosedReason
FROM dbo.CustLoginInfo c WITH (ROWLOCK, UPDLOCK)
INNER JOIN TempClosedReason t WITH(NOLOCK) ON c.CustID=t.CustID				
WHERE  t.ClosedReason=2
