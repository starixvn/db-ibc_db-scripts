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
SELECT custid, roleid
FROM Customer with(nolock)
WHERE SITE IN  ('733333','222223', '222225', '222227', '222229')	
	AND custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND roleid=3 AND srecommend IN (2,3,4,5,12,13,15)

--- get direct agent
INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
SELECT custid, mrecommend,roleid
FROM Customer WITH(NOLOCK)
WHERE site in ('733333','222223', '222225', '222227', '222229')	
	and custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and roleid=2 AND srecommend IN (2,3,4,5,12,13,15)
	
INSERT INTO #DirectMember(CustID,recommend,mrecommend,roleid)
SELECT c.custid, c.recommend,c.mrecommend,c.roleid
FROM Customer c WITH(NOLOCK)
INNER JOIN Customer ca (nolock) on c.recommend=ca.custid 
WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.roleid=1 AND c.srecommend IN (2,3,4,5,12,13,15)  
	AND  ca.site in ('733333','222223', '222225', '222227', '222229')
			
INSERT INTO #Cust_tmp (CustID,roleid)
SELECT CI.CustID,CI.roleid -- Direct Master 
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
UNION 

SELECT CI.CustID,CI.roleid -- Direct Agent
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectAgent D ON CI.recommend = D.CustID 

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

UPDATE cs
SET								
	 bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden, 8,0)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #Cust_tmp CI WITH (NOLOCK) ON cs.CustID = ci.CustID	
WHERE ci.CustID > @maxcustID
