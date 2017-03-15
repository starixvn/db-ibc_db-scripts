

/*
	Created: Winnie
	Task: UnHide for newly created customer
	DB: DBCUST/CustDB
	Date: 20170313
*/ 
		
DECLARE @maxcustid INT, @exchangeid INT
	
SELECT @maxcustid = xxx
	
CREATE TABLE #supers (custid int,exchangeid INT)
	
INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
FROM dbo.Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
AND ci.site IN  ('611111','722222','766666','789y', '7aa666', 'XYZbet', 'Best-odds'))	
-- CROSS-SITE
OR ci.custid IN (674248,395075,1164457,17721601,1016771,324561,1127269,938136)	

CREATE TABLE #CustTemp
(
	CustID INT PRIMARY KEY CLUSTERED
)
	
INSERT INTO #CustTemp (CustID)
SELECT custid
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid = 1  AND Enabled = 1 AND custid > @maxcustid
	
INSERT INTO #CustTemp (CustID)
SELECT custid
FROM Custinfo WITH (NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers) AND roleid IN (2,3,4) AND Enabled = 1 AND custid > @maxcustid 

DECLARE @Sporttype INT
SELECT @Sporttype=219
DECLARE @BitOrder INT
SELECT @BitOrder= bitmapOrder from ProductStatusProfile WITH(NOLOCK) where SportType=@Sporttype
	
	
UPDATE cs
SET								
	 bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden,@BitOrder,0)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #CustTemp CI WITH (NOLOCK) ON cs.CustID = ci.CustID	

		  
DROP TABLE #CustTemp
DROP TABLE #supers

