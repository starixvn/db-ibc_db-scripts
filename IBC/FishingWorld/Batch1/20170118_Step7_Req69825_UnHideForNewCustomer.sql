

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
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND Enabled=1
		-- Production
		AND ((ci.site IN ('733333','222223', '222225', '222227', '222229')	
		-- CROSS-SITE
		AND ci.custid NOT IN (674248,395075,1164457,1016771,993226,2453866,1156957,1156957,17721601,1156957,1036451,993226,1016771,324561,506057,2453866,1127269,1036451,1036451,2042873
		,2042873,1036451,796555,5005322))
		OR (ci.currency=20 AND ci.custid NOT IN(23003140,14771858,15323100,15744710,17996464,18002026,18011327,18012360,18012400,18012427,18012473,18012480,18012482,18012484,18012696
											,18362423,18524451,18829945,19000014,19295126,19392121,19562449,19562472,20269385,20660425,20669162,20786437,21005407,21005647,21005670
											,21005685,21005748,21005851,21005868,21005888,21305783,21984259,23715203,24338704,1176070)))
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

