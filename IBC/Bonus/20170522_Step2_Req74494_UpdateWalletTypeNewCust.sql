
/*
	Created: Winnie	
	Task:  Update BonusWalletFlag
	DB: DBCUST/CustDB
	Date: 20171011
*/ 

DECLARE  @max_custid INT
SELECT @max_custid = xxx
UPDATE ci
SET	
	ci.BonusWalletFlag=0
FROM CustInfo CI WITH (ROWLOCK,UPDLOCK) 
WHERE custid>@max_custid AND roleid=1
AND srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))


