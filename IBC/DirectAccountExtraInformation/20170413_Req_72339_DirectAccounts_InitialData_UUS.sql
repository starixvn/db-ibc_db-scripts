/*
	Created: 20170413@Helen
	Task: https://nexdev.net/issues/72339
	DB: DBCUST/CUSTDB
*/
USE CustDB
GO
DELETE FROM CustDirectAccount
GO

INSERT INTO Acc_CustDirect (custid,roleid)
SELECT CI.custid,CI.roleid
FROM custInfo CI WITH (NOLOCK)
WHERE CI.custid < 100 AND NOT EXISTS (SELECT 1 FROM Acc_CustDirect CD WITH (NOLOCK) WHERE CD.custid =  CI.custid)
	AND CI.currency = 20
-- SUPER
INSERT INTO CustDirectAccount (CustID,ApprovedBy,Boss,ProcessedBy, RequestedBy)
SELECT ci.custid,'','','',''
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN CustSuper CS WITH (NOLOCK)  ON CI.srecommend = CS.custid AND CS.IsInternal = 0
WHERE ci.roleid = 4 
	AND ci.Custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND ci.Enabled = 1
	AND CI.currency = 20
-- DIRECT MASTER
INSERT INTO CustDirectAccount (CustID,ApprovedBy,Boss,ProcessedBy, RequestedBy)
SELECT ci.custid,'','','',''
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN CustSuper CS WITH (NOLOCK)  ON CI.srecommend = CS.custid AND CS.IsInternal = 0
WHERE ci.Custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and ci.srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and ci.roleid=3
	AND CI.currency = 20
-- DIRECT AGENT
INSERT INTO CustDirectAccount (CustID,ApprovedBy,Boss,ProcessedBy, RequestedBy)
SELECT ci.custid,'','','',''
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN CustSuper CS WITH (NOLOCK)  ON CI.srecommend = CS.custid AND CS.IsInternal = 0
WHERE ci.Custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND roleid=2
	AND CI.currency = 20
		
-- DIRECT MEMBER
INSERT INTO CustDirectAccount (CustID,ApprovedBy,Boss,ProcessedBy, RequestedBy)
SELECT ci.custid,'','','',''
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN CustSuper CS WITH (NOLOCK)  ON CI.srecommend = CS.custid AND CS.IsInternal = 0
WHERE ci.Custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND ci.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND ci.roleid=1	
	AND CI.currency = 20


