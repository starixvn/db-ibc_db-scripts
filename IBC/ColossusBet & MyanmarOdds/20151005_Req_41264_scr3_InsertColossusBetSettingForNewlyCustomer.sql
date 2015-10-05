/*
	Created: Elodie
	Date: 2015-10-05
	Task: Add ColossusBet settings for newly customers
	DB: DBCUST/CustDB
	Runtime: UM
*/ 
--STEP 1: Add settings for newly created credit customers
CREATE TABLE #supers (custid int)

INSERT INTO #supers(custid)
SELECT custid
FROM custinfo WITH(NOLOCK)
WHERE custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND roleid = 4
GO

DECLARE @maxcustid INT 
SELECT @maxcustid = xx --lastest custid

INSERT INTO dbo.AgentCommRate WITH (ROWLOCK) (CustID,SportType,BetType,CommRate) 
SELECT custid,204,18001,0 FROM CustInfo WITH (NOLOCK) WHERE srecommend IN (SELECT custid FROM #supers) and roleid IN (2,3,4) AND custid > @maxcustid
UNION ALL 
SELECT custid,204,18002,0 FROM CustInfo WITH (NOLOCK) WHERE srecommend IN (SELECT custid FROM #supers) and roleid IN (2,3,4) AND custid > @maxcustid

INSERT INTO dbo.CustCommRate WITH (ROWLOCK) (CustID,SportType,BetType,sdiscount,adiscount,discount,playerdiscount) 
SELECT custid,204,18001,0,0,0,0 FROM CustInfo WITH (NOLOCK) WHERE srecommend IN (SELECT custid FROM #supers) and roleid = 1 AND custid > @maxcustid
UNION ALL 
SELECT custid,204,18002,0,0,0,0 FROM CustInfo WITH (NOLOCK) WHERE srecommend IN (SELECT custid FROM #supers) and roleid = 1 AND custid > @maxcustid
	
GO		 
