

/*
	Created: Winnie
	Task: UnHide for newly created customer
	DB: DBCUST/CustDB
	Date: 20170118
*/ 
		
DECLARE @maxcustid INT, @exchangeid INT
	
SELECT @maxcustid = xxx
	
CREATE TABLE #supers (custid int,exchangeid INT)
	
INSERT INTO #supers(custid,exchangeid)
SELECT ci.custid,ci.currency
FROM dbo.Customer ci WITH(NOLOCK)
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		-- Production
		AND ((ci.site IN ('733333','222223', '222225', '222227', '222229')	
		-- CROSS-SITE
		AND ci.custid NOT IN (674248,395075,1164457,1016771,993226,2453866,1156957,1156957,17721601,1156957,1036451,993226,1016771,324561,506057,2453866,1127269,1036451,1036451,2042873
		,2042873,1036451,796555,5005322))
		OR ci.currency = 20)
		)	

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

UPDATE cs
SET								
	 bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden, 8,0)
FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #CustTemp CI WITH (NOLOCK) ON cs.CustID = ci.CustID	

		  
DROP TABLE #CustTemp
DROP TABLE #supers

