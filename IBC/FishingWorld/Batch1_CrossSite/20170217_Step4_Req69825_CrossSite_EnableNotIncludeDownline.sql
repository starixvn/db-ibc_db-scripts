	/*
	Created: Winnie
	Task: Enable Fishing World CrossSite not using execrep [RedmineID: 69825]
	DB: DBCUST/CustDB
	Date: 20170217
	*/ 
	CREATE TABLE #tempcusts (custid INT PRIMARY KEY, roleId INT,IsSM BIT)
	INSERT INTO #tempcusts(custid,roleId,IsSM)
	SELECT custid,roleid,0
	FROM Customer WITH(NOLOCK) WHERE username 	
	IN('S42AH','S71H','S822M','SKHH','SPHM')
	
	DECLARE @Sporttype INT
	SELECT @Sporttype=219
	DECLARE @BitOrder INT
	SELECT @BitOrder= bitmapOrder from ProductStatusProfile WITH(NOLOCK) where SportType=@Sporttype
	
	UPDATE cs
	SET								
		 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,@BitOrder,0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #tempcusts t ON cs.CustID=t.CustID
	
	
	UPDATE cs
	SET								
		 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,@BitOrder,0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	WHERE cs.CustID IN(
	SELECT DISTINCT c.srecommend FROM #tempcusts t 
	INNER JOIN CustInfo c WITH(NOLOCK) ON t.custid=c.custid
	WHERE t.roleid=3)
	
	UPDATE cs
	SET								
		 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,@BitOrder,0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	WHERE cs.CustID IN
	(SELECT c.custid FROM #tempcusts t 
	INNER JOIN CustInfo c WITH(NOLOCK) ON t.custid=c.srecommend
	WHERE IsSM=1 AND c.roleid=3)
	
	drop table #tempcusts







	