/*
	Created: Winnie
	Date: 20170313
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
WHERE SITE IN   ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
	AND c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.srecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.roleid=3 AND c.srecommend IN (1,2,3,4,5,6,9,12,13,15,16,22,30,32,33,34,35,36,41,42,1469577,3259509,3259514,3259527,3259546,3259599,3259606,3259614,4042341,4054997,6911902,7178173,7178174,7178175
		,7178176,7178177,7178178,7178179,7178180,7178181,7205490,7216595,7662761,14174238,17996553,18906414,19354890,21278849,21278858)  AND ci.Enabled=1

--- get direct agent
INSERT INTO #DirectAgent (CustID,mrecommend,roleid)
SELECT c.custid, c.mrecommend,c.roleid
FROM Customer c WITH(NOLOCK)
INNER JOIN custInfo ci WITH(NOLOCK) ON c.custid=ci.custid
WHERE site in   ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
	and c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and c.mrecommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	and c.roleid=2 AND c.srecommend IN (1,2,3,4,5,6,9,12,13,15,16,22,30,32,33,34,35,36,41,42,1469577,3259509,3259514,3259527,3259546,3259599,3259606,3259614,4042341,4054997,6911902,7178173,7178174,7178175
		,7178176,7178177,7178178,7178179,7178180,7178181,7205490,7216595,7662761,14174238,17996553,18906414,19354890,21278849,21278858)  AND ci.Enabled=1
	
INSERT INTO #DirectMember(CustID,recommend,mrecommend,roleid)
SELECT c.custid, c.recommend,c.mrecommend,c.roleid
FROM Customer c WITH(NOLOCK)
INNER JOIN Customer ca (nolock) on c.recommend=ca.custid 
INNER JOIN custInfo ci WITH(NOLOCK) ON c.custid=ci.custid
WHERE c.custid NOT IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.recommend IN (SELECT custid from Acc_CustDirect WITH(NOLOCK))
	AND c.roleid=1 AND c.srecommend IN (1,2,3,4,5,6,9,12,13,15,16,22,30,32,33,34,35,36,41,42,1469577,3259509,3259514,3259527,3259546,3259599,3259606,3259614,4042341,4054997,6911902,7178173,7178174,7178175
		,7178176,7178177,7178178,7178179,7178180,7178181,7205490,7216595,7662761,14174238,17996553,18906414,19354890,21278849,21278858) 
	AND  ca.site in   ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds')	
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
