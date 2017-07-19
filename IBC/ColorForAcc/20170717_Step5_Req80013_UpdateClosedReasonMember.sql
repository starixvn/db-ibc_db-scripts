
/*
	Created: Winnie	
	Task:  Update ClosedReason on CustLoginInfoMember
	DB: DBCUST/CustDB
	Date: 20170717
*/ 

  UPDATE c SET c.ClosedReason= t.ClosedReason
  FROM dbo.CustLoginInfo_Member c WITH (ROWLOCK, UPDLOCK)
  INNER JOIN TempClosedReasonMember t WITH(NOLOCK) ON c.CustID=t.CustID    
  WHERE t.ClosedReason=2
