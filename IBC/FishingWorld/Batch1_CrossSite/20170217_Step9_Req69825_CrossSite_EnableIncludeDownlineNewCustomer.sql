/*
	Created: Winnie
	Task: Enable Fishing World  using execrep crosssite new customer [RedmineID: 69825]
	DB: DBCUST/CustDB
	Date: 20170217
*/ 
	DECLARE @maxcustID INT
	SELECT @maxcustID=xxx		
	
	DECLARE @Sporttype INT
	SELECT @Sporttype=219
	DECLARE @BitOrder INT
	SELECT @BitOrder= bitmapOrder from ProductStatusProfile WITH(NOLOCK) where SportType=@Sporttype	

	UPDATE cs
	SET								
		 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,@BitOrder,0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN CustInfo c WITH(NOLOCK) ON c.custid=cs.custid
	WHERE c.custid>@maxcustid AND c.srecommend IN(5005322,506057,2453866)and c.mrecommend NOT IN(60349,167860,63971) AND c.recommend <>104769

