/*
	Created: Winnie	
	Task:  Enable and UnHide Keno for SMA
	DB: DBCUST/CustDB
	Date: 20170515
*/ 
ALTER PROCEDURE [dbo].Acc_CustSetting_19
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
	,@Site VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 AND dbo.f_CheckRepTable('Custgametype') = 1   )
		RETURN	
	CREATE TABLE #Temp (CustID INT,GameTypeID INT, PRIMARY KEY(CustID,GameTypeID))
	INSERT INTO #Temp(CustID,GameTypeID)
	SELECT ct.CustID,ct.GameTypeID
	FROM Custgametype ct WITH (NOLOCK) 
	INNER JOIN CustInfo CI WITH(NOLOCK) ON ct.custid=ci.custid
	WHERE  ci.custid<=@maxcustid AND ct.GameTypeID between 1 and 16 AND ci.srecommend = @srecommend AND ci.roleid BETWEEN 2 AND 4	AND ci.Enabled=1
	AND ct.IsDisabled=1 AND Ci.HideKeno=0

	UPDATE ct
	SET ct.IsDisabled=0
	FROM Custgametype ct WITH (ROWLOCK,UPDLOCK) 
	INNER JOIN #Temp t ON ct.CustID=t.CustID AND ct.GameTypeID=t.GameTypeID

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
		,@site=Site	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_CustSetting_19 @srecommend = @srecommend
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
		,@site=Site	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_CustSetting_19 @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
			,@Site=@site
						
	waitfor delay '00:00:0.280'
END