

/*
	Created: Winnie	
	Task: Enable and UnHide FW for SMA
	DB: DBCUST/CustDB
	Date: 20170405
*/ 
ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)	
AS
BEGIN
	SET NOCOUNT ON
	
	--IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	--IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustProductStatus') = 1	
	   )
		RETURN		
	CREATE TABLE #temp (CustID INT PRIMARY KEY)
	INSERT INTO #temp(CustID)
	SELECT cs.CustID
	FROM [dbo].[CustProductStatus] cs WITH(NOLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON cs.CustID = ci.CustID
	WHERE cs.CustID<=@maxcustid AND ci.srecommend = @srecommend AND ci.roleid BETWEEN 2 AND 4	AND ci.Enabled=1
	AND (SELECT * FROM dbo.f_CustSetting_ProductStatusSel  (cs.bitmapIsHidden,8)) = 0 AND (SELECT * FROM dbo.f_CustSetting_ProductStatusSel  (cs.bitmapIsDisabled,8)) = 1
	 AND (SELECT * FROM dbo.f_CustSetting_ProductStatusSel  (cs.bitmapHasSynced,8)) = 1
	-- FW	
	UPDATE cs
	SET				
		 bitmapIsDisabled =dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,8,0) 	
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN #temp t ON cs.CustID=t.CustID

END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE  @srecommend INT,@max_custid INT
SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
AND ci.site='733333'
)
AND ci.custid NOT IN (SELECT cu.custid FROM custaccount cu WITH  (NOLOCK)
inner join custinfo c WITH (NOLOCK) ON cu.custid=c.custid
WHERE groupid=515 and c.roleid=4) --THAUS
AND ci.custid NOT IN (select cd.custid from Acc_CustDirect cd WITH(NOLOCK)
where cd.roleid=4)
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'	
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,isfinished bit default(0))

DECLARE  @srecommend INT,@max_custid INT
SELECT @max_custid = xxx

INSERT INTO #supers(custid)
SELECT ci.custid
FROM dbo.Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
AND ci.site='733333'
)
AND ci.custid NOT IN (SELECT cu.custid FROM custaccount cu WITH  (NOLOCK)
inner join custinfo c WITH (NOLOCK) ON cu.custid=c.custid
WHERE groupid=515 and c.roleid=4) --THAUS
AND ci.custid NOT IN (select cd.custid from Acc_CustDirect cd WITH(NOLOCK)
where cd.roleid=4)
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'		
						
	waitfor delay '00:00:0.280'
END

