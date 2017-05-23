
/*
	Created: Winnie	
	Task:  Update WalletFlag
	DB: DBCUST/CustDB
	Date: 20170522
*/ 

DECLARE  @max_custid INT
SELECT @max_custid = xxx
UPDATE ci
SET	
	ci.WalletFlag=0
FROM CustInfo CI WITH (ROWLOCK,UPDLOCK) 
WHERE custid>@max_custid AND roleid=1
AND srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))


