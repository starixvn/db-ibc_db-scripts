
/*
	Created: Winnie	
	Task:  Enable and UnHide Macau + AllBet + FW + NG2 for SMA for new SMA
	DB: DBCUST/CustDB
	Date: 20170404
*/ 
DECLARE	
	@maxcustid INT	
	,@Site VARCHAR(10)
	
CREATE TABLE #tempCusts (custid int,site varchar(10))
SELECT @maxcustid = 25511000
CREATE TABLE #bitmapOrder (bitmapOrder INT,Disable BIT default(0))

DECLARE @xmlStrDisabledAndHide XML
DECLARE @StrDisabledAndHide VARCHAR(MAX)

INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(4)
INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(5)
INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(6)
INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(7)
INSERT INTO #bitmapOrder(bitmapOrder)
VALUES(8)


SET @xmlStrDisabledAndHide = (
				SELECT (
						SELECT bitmapOrder	AS '@b'
							, Disable	AS '@s'
						FROM #bitmapOrder
						FOR XML PATH('r')
							, TYPE
						)
				FOR XML PATH('root')
					, TYPE
				)						
SELECT @StrDisabledAndHide=CONVERT(VARCHAR(MAX),@xmlStrDisabledAndHide)

INSERT INTO #tempCusts(custid,site)
SELECT c.custid,s.site
FROM dbo.Customer s WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON c.srecommend=s.custid
WHERE (s.roleid = 4 	
AND s.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
AND c.custid>@maxcustid
AND c.roleid IN(2,3,4)
)
	

UPDATE cs
SET									
		bitmapIsDisabled = (select bitmap from dbo.f_GenerateProductStatus_multiple (cs.bitmapIsDisabled, @StrDisabledAndHide))	
		,bitmapIsHidden =  (select bitmap from dbo.f_GenerateProductStatus_multiple (cs.bitmapIsHidden, @StrDisabledAndHide))	
FROM CustProductStatus Cs WITH (ROWLOCK,UPDLOCK) 
INNER JOIN #tempCusts t ON cs.custid=t.custid

