/*
	Created: Winnie
	Date: 2017-05-03
	Task:colossus settings: enable status for remain deposit customers
	DB: DBCUST/CustDB
*/ 

------------------------------------------------------
DECLARE @maxcustid INT
SELECT @maxcustid= xx

UPDATE custInfo WITH(ROWLOCK,UPDLOCK)	
	SET DisableColossusBet=0,HideColossusBet=0
	WHERE srecommend IN  (SELECT custid FROM Dep_CustSuper cs WITH(NOLOCK)							
							WHERE cs.site IN ('Sun988'))
	AND Enabled=1 AND custid > @maxcustid