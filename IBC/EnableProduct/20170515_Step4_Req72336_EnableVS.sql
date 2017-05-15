/*
	Created: Winnie	
	Task:  Enable and UnHide Virtual Sports for SMA
	DB: DBCUST/CustDB
	Date: 20170515
*/ 
ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
	,@Site VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1  
			AND dbo.f_CheckRepTable('Custgametype') = 1   )
		RETURN		

	UPDATE ci
	SET	ci.DisableVirtualSports=0	
	FROM CustInfo CI WITH (ROWLOCK,UPDLOCK) 
	WHERE  ci.custid<=@maxcustid AND ci.srecommend = @srecommend AND ci.roleid IN(2,3,4)
	AND ci.HideVirtualSports=0 AND ci.DisableVirtualSports=1

END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,site varchar(10),isfinished bit default(0))

DECLARE  @srecommend INT,@max_custid INT,@site varchar(10)
SELECT @max_custid = xxx

INSERT INTO #supers(custid,site)
SELECT ci.custid,ci.site
FROM dbo.Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
)
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid
		,@site=Site	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			,@Site=@site
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int,site varchar(10),isfinished bit default(0))

DECLARE  @srecommend INT,@max_custid INT,@site varchar(10)
SELECT @max_custid = xxx

INSERT INTO #supers(custid,site)
SELECT ci.custid,ci.site
FROM dbo.Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE (ci.roleid = 4 	
AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
		,@site=Site	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_DynamicCustomerInfo_09 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
			,@Site=@site
						
	waitfor delay '00:00:0.280'
END