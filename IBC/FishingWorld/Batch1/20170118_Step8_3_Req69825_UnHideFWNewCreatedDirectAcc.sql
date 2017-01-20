/*
	Created: Winnie
	Date: 20170118
	Task: UnHide  Fishing World settings for dummy account new created
	DB: DBCust/CustDB
*/
DECLARE @maxcustID INT = xxx 
	
CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY,roleid INT)
CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY,mrecommend INT,roleid INT)
CREATE TABLE #DirectMember (CustID INT PRIMARY KEY,recommend INT,mrecommend INT,roleid INT)			
CREATE TABLE #Cust_tmp(CustID INT PRIMARY KEY CLUSTERED,	roleid TINYINT	)

INSERT INTO #DirectMaster (CustID,roleid)
SELECT c.custid, c.roleid
FROM Customer c WITH(NOLOCK)
INNER JOIN custInfo ci WITH(NOLOCK) ON c.custid=ci.custid
WHERE SITE IN  ('733333','222223', '222225', '222227', '222229')	
	AND c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.roleid=3 AND c.srecommend IN (2,5,13) AND ci.Enabled=1

--- get direct agent
INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
SELECT c.custid, c.mrecommend,c.roleid
FROM Customer c WITH(NOLOCK)
INNER JOIN custInfo ci WITH(NOLOCK) ON c.custid=ci.custid
WHERE site in ('733333','222223', '222225', '222227', '222229')	
	and c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and c.mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and c.roleid=2 AND c.srecommend IN (2,5,13) AND ci.Enabled=1
	
INSERT INTO #DirectMember(CustID,recommend,mrecommend,roleid)
SELECT c.custid, c.recommend,c.mrecommend,c.roleid
FROM Customer c WITH(NOLOCK)
INNER JOIN Customer ca (nolock) on c.recommend=ca.custid 
INNER JOIN custInfo ci WITH(NOLOCK) ON c.custid=ci.custid
WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.roleid=1 AND c.srecommend IN (2,5,13)
	AND  ca.site in ('733333','222223', '222225', '222227', '222229')
	AND ci.Enabled=1
			
INSERT INTO #Cust_tmp (CustID,roleid)
SELECT CI.CustID,CI.roleid -- Direct Master & downline
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
	WHERE ci.Enabled=1
UNION 

SELECT CI.CustID,CI.roleid -- Direct Agent & downline
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent D ON CI.recommend = D.CustID 
	WHERE ci.Enabled=1

UNION 	

SELECT DISTINCT CI.CustID,CI.roleid -- Master of direct agent
FROM Customer CI WITH (NOLOCK)
	INNER JOIN #DirectAgent D ON CI.custid = D.mrecommend 
WHERE CI.roleid = 3 
UNION 

SELECT DISTINCT CI.CustID,CI.roleid -- Master of direct member
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMember D ON CI.custid = D.mrecommend 
WHERE  ci.Enabled = 1 

UNION 
SELECT DISTINCT CI.CustID,CI.roleid-- agent of direct member
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMember D ON CI.custid = D.recommend 
WHERE  ci.Enabled = 1 

UNION 
SELECT CustID, roleid
FROM #DirectMember	

DECLARE @Sporttype INT
SELECT @Sporttype=219
DECLARE @BitOrder INT
SELECT @BitOrder= bitmapOrder from ProductStatusProfile WITH(NOLOCK) where SportType=@Sporttype

UPDATE cs
SET								
	 bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden, @BitOrder,0)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #Cust_tmp CI WITH (NOLOCK) ON cs.CustID = ci.CustID	
WHERE ci.CustID > @maxcustID
