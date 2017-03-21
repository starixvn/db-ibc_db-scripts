/*
	Created: Winnie
	Date: 20170313
	Task: Delete  Fishing World settings for dummy account new created
	DB: DBCust/CustDB
*/
DECLARE @maxcustID INT = xxx 
	
CREATE TABLE #DirectMaster (CustID INT PRIMARY KEY,roleid INT)
CREATE TABLE #DirectAgent (CustID INT PRIMARY KEY,mrecommend INT,roleid INT)
CREATE TABLE #DirectMember (CustID INT PRIMARY KEY,recommend INT,mrecommend INT,roleid INT)			
CREATE TABLE #Cust_tmp(CustID INT PRIMARY KEY CLUSTERED,	roleid TINYINT	)

INSERT INTO #DirectMaster (CustID,roleid)
SELECT ci.custid, ci.roleid
FROM Customer ci with(nolock)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE SITE IN   ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
	AND ci.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND ci.srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND ci.roleid=3 
	AND (ci.srecommend <=100-- dummy acc =<100
	OR ci.srecommend IN(1469577, 21278849, 21278858))
	AND c.Enabled=1

--- get direct agent
INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
SELECT ci.custid, ci.mrecommend,ci.roleid
FROM Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE site in  ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
	and ci.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and ci.mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and ci.roleid=2 
	AND (ci.srecommend <=100-- dummy acc =<100
	OR ci.srecommend IN(1469577, 21278849, 21278858))
	AND c.Enabled=1
	
INSERT INTO #DirectMember(CustID,recommend,mrecommend,roleid)
SELECT c.custid, c.recommend,c.mrecommend,c.roleid
FROM Customer c WITH(NOLOCK)
INNER JOIN Customer ca (nolock) on c.recommend=ca.custid 
INNER JOIN custInfo ci WITH(NOLOCK) ON ci.custid=c.custid
WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.roleid=1 
	AND (ci.srecommend <=100-- dummy acc =<100
	OR ci.srecommend IN(1469577, 21278849, 21278858))
	AND  ca.site in  ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
	AND ci.Enabled=1
			
INSERT INTO #Cust_tmp (CustID,roleid)
SELECT CI.CustID,CI.roleid -- Direct Master & downline
FROM custInfo CI WITH (NOLOCK)
	INNER JOIN #DirectMaster D ON CI.mrecommend = D.CustID 
	WHERE ci.Enabled=1
UNION 

SELECT CI.CustID,CI.roleid -- Direct Agent  & downline
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
---------- For members ---------

UNION 
SELECT CustID, roleid
FROM #DirectMember	
DECLARE @Sporttype INT
SELECT @Sporttype = 219
--- PT
DELETE cg
FROM CustPTSetting3rd_Agent cg 
	INNER JOIN #Cust_tmp tmp (NOLOCK) ON tmp.custid = cg.custid
WHERE SportType = @Sporttype AND cg.CustID > @maxcustID
						
DELETE cg
FROM CustPTSetting3rd_Member cg 
	INNER JOIN #Cust_tmp tmp (NOLOCK) ON tmp.custid = cg.custid
WHERE CG.SportType = @Sporttype AND cg.CustID > @maxcustID

DELETE cg
FROM CustPTGroupSetting3rd_Member cg
	INNER JOIN #Cust_tmp CI (NOLOCK) ON CI.custid = CG.AgentID 
WHERE CG.SportType = @Sporttype AND cg.AgentID > @maxcustID

-- Winloss - limit
DELETE cg
FROM CustWinLossLimit_Agent cg 		
	INNER JOIN #Cust_tmp tmp (NOLOCK) ON tmp.custid = cg.custid
WHERE SportType = @Sporttype AND cg.CustID > @maxcustID

DELETE cg
FROM CustWinLossLimit_Member cg 		
	INNER JOIN #Cust_tmp tmp (NOLOCK) ON tmp.custid = cg.custid
WHERE CG.SportType = @Sporttype AND cg.CustID > @maxcustID

