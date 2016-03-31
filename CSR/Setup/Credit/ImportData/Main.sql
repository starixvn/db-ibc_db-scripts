CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid = 1
FROM CustInfo ci WITH(NOLOCK)

INSERT INTO #supers
SELECT ci.custid
FROM CustInfo ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND custid <= @max_custid 
	AND ci.currency = 20
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustSetting_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
			
	EXEC dbo.Acc_DynamicCustSetting_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
	
	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			
	waitfor delay '00:00:0.888'
END