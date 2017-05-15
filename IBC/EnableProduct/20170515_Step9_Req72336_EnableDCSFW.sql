

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
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustProductStatus') = 1	
	   )
		RETURN		
	
	-- FW	
	UPDATE cs
	SET				
		 bitmapIsDisabled =dbo.f_GenerateProductStatus (cs.bitmapIsDisabled,8,0) 	
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	INNER JOIN custInfo CI WITH (NOLOCK) ON cs.CustID = ci.CustID
	WHERE cs.CustID<=@maxcustid AND ci.srecommend = @srecommend AND ci.roleid IN(2,3,4)	AND ci.Enabled=1
	AND (SELECT * FROM dbo.f_CustSetting_ProductStatusSel  (cs.bitmapIsHidden,8)) = 0 AND (SELECT * FROM dbo.f_CustSetting_ProductStatusSel  (cs.bitmapIsDisabled,8)) = 1

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
)
AND ci.custid NOT IN (24095164,24095167,24187839,24187891,24187893,24187896,24187897,24187898,24187900,24187902,24187903,24187904,24191062,24191172,24191175,24191178,24191182,24191185
,24191189,24191194,19475714,19475729,19475733,19609304,19609353) --THAUS
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
)
AND ci.custid NOT IN (24095164,24095167,24187839,24187891,24187893,24187896,24187897,24187898,24187900,24187902,24187903,24187904,24191062,24191172,24191175,24191178,24191182,24191185
,24191189,24191194,19475714,19475729,19475733,19609304,19609353) --THAUS
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

