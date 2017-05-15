
/*
	Created: Winnie	
	Task:  Enable and UnHide Macau + AllBet + FW + NG2 for SMA for new SMA
	DB: DBCUST/CustDB
	Date: 20170515
*/ 
DECLARE	
	@maxcustid INT	
	,@Site VARCHAR(10)
	
CREATE TABLE #tempCusts (custid int,site varchar(10))
SELECT @maxcustid = xxx

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
	-- FW	
	UPDATE cs
	SET				
		 bitmapIsDisabled =dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,8,0) 
		 ,bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden,8,0)		
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	INNER JOIN #tempCusts t ON cs.custid=t.custid
	WHERE dbo.f_getProductStatus (cs.bitmapHasSynced,8) = 1 AND dbo.f_getProductStatus (cs.bitmapIsDisabled,8) = 1
			
	-- Allbet
	UPDATE cs
	SET				
		 bitmapIsDisabled = dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,6,0) 
		 ,bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden,6,0)		
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #tempCusts t ON cs.custid=t.custid
	WHERE dbo.f_getProductStatus (cs.bitmapHasSynced,6) = 1 AND dbo.f_getProductStatus (cs.bitmapIsDisabled,6) = 1

	UPDATE cs
	SET				
		 bitmapIsDisabled =dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,7,0) 
		 ,bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden,7,0)		
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #tempCusts t ON cs.custid=t.custid
	WHERE dbo.f_getProductStatus (cs.bitmapHasSynced,7) = 1 AND dbo.f_getProductStatus (cs.bitmapIsDisabled,7) = 1			
	
	-- Macau
	UPDATE cs
	SET				
		 bitmapIsDisabled = dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,5,0) 
		 ,bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden,5,0)		
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #tempCusts t ON cs.custid=t.custid	
	WHERE dbo.f_getProductStatus (cs.bitmapHasSynced,5) = 1 AND dbo.f_getProductStatus (cs.bitmapIsDisabled,5) = 1
	 --NG2
	UPDATE cs
	SET				
		 bitmapIsDisabled =dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,4,0) 
		 ,bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden,4,0)		
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #tempCusts t ON cs.custid=t.custid	
	WHERE  dbo.f_getProductStatus (cs.bitmapHasSynced,4) = 1 AND dbo.f_getProductStatus (cs.bitmapIsDisabled,4) = 1				

