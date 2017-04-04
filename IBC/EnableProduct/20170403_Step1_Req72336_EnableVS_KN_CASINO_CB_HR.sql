
/*
	Created: Winnie	
	Task:  Enable and UnHide SMA for Virtual Sports,Keno,OneRNG Casino,Colossus Bets,Racing
	DB: DBCUST/CustDB
	Date: 20170403
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
	
	IF @Site<>'imbc' AND @Site <>'789y'
	BEGIN
		UPDATE ci
		SET	ci.HideVirtualSports=0,ci.DisableVirtualSports=0
			,ci.DisableColossusBet=0,ci.HideColossusBet=0
			,ci.DisableCasino=0,ci.HideKeno=0
			,ci.DisableHorseRacing=0,ci.DisableOpenTote=0,ci.Disable151_AU=0,ci.Disable152_AU=0,ci.Disable152_UK=0,ci.Disable153_AU=0
			,ci.[DisableGoldDeluxe]=0,ci.HideGoldDeluxe=0
		FROM CustInfo CI WITH (ROWLOCK,UPDLOCK) 
		WHERE ci.custid<=@maxcustid AND ci.srecommend = @srecommend AND ci.roleid IN(2,3,4)

		UPDATE ct
		SET ct.IsDisabled=0
		FROM Custgametype ct WITH (ROWLOCK,UPDLOCK) 
		INNER JOIN CustInfo CI WITH(NOLOCK) ON ct.custid=ci.custid
		WHERE ci.custid<=@maxcustid AND ct.GameTypeID between 1 and 16 AND ci.srecommend = @srecommend AND ci.roleid IN(2,3,4)

	END
	ELSE
	BEGIN

		UPDATE ci
		SET	ci.HideVirtualSports=0,ci.DisableVirtualSports=0
			,ci.DisableColossusBet=0,ci.HideColossusBet=0
			,ci.DisableCasino=0,ci.HideKeno=0
			,ci.DisableHorseRacing=0,ci.DisableOpenTote=0,ci.Disable151_AU=0,ci.Disable152_AU=0,ci.Disable152_UK=0,ci.Disable153_AU=0	
		FROM CustInfo CI WITH (ROWLOCK,UPDLOCK) 
		WHERE  ci.custid<=@maxcustid AND ci.srecommend = @srecommend AND ci.roleid IN(2,3,4)

		UPDATE ct
		SET ct.IsDisabled=0
		FROM Custgametype ct WITH (ROWLOCK,UPDLOCK) 
		INNER JOIN CustInfo CI WITH(NOLOCK) ON ct.custid=ci.custid
		WHERE  ci.custid<=@maxcustid AND ct.GameTypeID between 1 and 16 AND ci.srecommend = @srecommend AND ci.roleid IN(2,3,4)

	END 

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

