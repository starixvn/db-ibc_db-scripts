/*
	date : 2014-12-14
	Author: Susan
	Task: Adjust betsetting Virtual Sports for iBet 
	Redmine: https://redmine.nexcel.vn/issues/27317
	DB: DBTXN/CustDB
 */
 
-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	  @srecommend INT	
	 ,@currency INT
	 ,@maxcustid INT	
	 ,@target VARCHAR(20)
AS
BEGIN
SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only

IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('Dep_Custsetting3rd','custinfo') AND type = 'U') <>2
	RETURN

DECLARE @minbet money, @maxbet money, @maxpermatch money,  @ptVALUE SMALLMONEY

	 
SELECT @minbet = CASE 
			WHEN @currency = 2 THEN 5  --RM
			WHEN @currency = 13 THEN 10  --RMB
			WHEN @currency = 15 THEN 3  --IN
			WHEN @currency = 4 THEN 45  --TB
			When @currency=51 then 30 --INH
			ELSE 0
			END
		,@maxbet = CASE 
			WHEN @currency = 2 THEN 1500  --RM
			WHEN @currency = 13 THEN 3000  --RMB
			WHEN @currency = 15 THEN 5000  --IN
			WHEN @currency = 4 THEN 15000  --TB
			When @currency=51 then 10000 --INH
			ELSE 0
			END
		,@maxpermatch = CASE 
			WHEN @currency = 2 THEN 5000  --RM
			WHEN @currency = 13 THEN 10000  --RMB
			WHEN @currency = 15 THEN 15000  --IN
			WHEN @currency = 4 THEN 50000  --TB
			When @currency=51 then 50000 --INH
			ELSE 0
			END

IF (@minbet = 0)  RETURN 

---update VS maxpermatch : 899 rows
	 					
	UPDATE  Custinfo WITH(UPDLOCK,ROWLOCK)
	SET maxpermatch180 = @maxpermatch,
	    maxpermatch181 = @maxpermatch,
		maxpermatch182 = @maxpermatch,
		maxpermatch183 = @maxpermatch,
		maxpermatch184 = @maxpermatch,
		maxpermatch185 = @maxpermatch,
		maxpermatch186 = @maxpermatch
	WHERE srecommend=@srecommend
	AND custid<=@maxcustid
		

	-- Update VS bet setting : 6293 rows
	UPDATE newVS  WITH(UPDLOCK,ROWLOCK)
	SET    newVS.minbet = @minbet,
		   newVS.maxbet = @maxbet
	FROM Dep_CustSetting3rd newVS
	INNER JOIN custInfo c WITH(NOLOCK) ON c.custid=newVS.custid
	where c.srecommend=@srecommend
	AND sporttype in (180,181,182,183,184,185,186)
	AND newVS.custid<=@maxcustid
		
 	
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


-- BEGIN STEP 2: RUN THIS SCRIPT AT DBTRANS/CustDB -----
-------------------------------------------------
CREATE TABLE #Supers ( custid INT PRIMARY KEY,currency int , isfinished bit default(0))
Declare @currency int ,@srecommend int ,@site varchar (50),@maxcustid int

select @site='ibet'
,@maxcustid=xxx   --input maxcustid here

INSERT INTO #Supers
SELECT custid,currency,  0
FROM Dep_CustSuper with(NOLOCK) where site = @site and currency <>20 ---RM, RMB, IN, TB, INH 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@currency = currency
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend,@currency= @currency, @maxcustid=@maxcustid,@target = 'REPLICATED'  	
	
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #Supers
GO

---- End of step 2
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS/CustDB -----
-------------------------------------------------
CREATE TABLE #Supers ( custid INT PRIMARY KEY,currency int , isfinished bit default(0))
Declare @currency int ,@srecommend int ,@site varchar (50),@maxcustid int

select @site='ibet'
       ,@maxcustid=xxx   --input maxcustid here

INSERT INTO #Supers
SELECT custid,currency,0
FROM Dep_CustSuper with(NOLOCK) where site = @site and currency <>20  ---RM, RMB, IN, TB, INH 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@currency = currency
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend,@currency= @currency, @maxcustid=@maxcustid,@target = 'DBTRANS'  	
	
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #Supers
GO

---- End of step 3