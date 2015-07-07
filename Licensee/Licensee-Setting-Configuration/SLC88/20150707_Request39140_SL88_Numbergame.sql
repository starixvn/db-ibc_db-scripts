 
  /*
	Task: Offer SLC88  Number game
	Redmineid: https://redmine.nexcel.vn/issues/39140
	DB: DBTXN/CustDB
	Total mem   Custid		Username	   Currency Dep_custsetting3rd
	 496		12158924	SLC88SuperRMB	13      4464
	 7		   12158888	    SLC88SuperUS$	3       63
	 3		   12158949	    SLC88SuperTB	4       27
 */
 
-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	 @currency INT
	 ,@srecommend INT	
	 ,@target VARCHAR(20)
	 ,@maxcustid int
AS
BEGIN
	SET NOCOUNT ON;

	IF ( SELECT COUNT(1)  FROM  sys.objects WHERE name IN ('Dep_Custsetting3rd','custinfo','Dep_Custsetting') AND type = 'U') <> 3
		RETURN

	DECLARE @minbet money, @maxbet money, @maxpermatch money,@maxperball money

	 
	 SELECT @minbet = CASE 
			WHEN @currency = 4 THEN 10  --TB
			WHEN @currency = 13 THEN 2  --RMB
			WHEN @currency = 3 THEN 1  --USD	
			ELSE 0
			END
		,@maxbet = CASE 
			WHEN @currency = 4 THEN 50000  --TB
			WHEN @currency = 13 THEN 10000  --RMB
			WHEN @currency = 3 THEN 150  --USD
			ELSE 0
			END
		,@maxpermatch = CASE 
			WHEN @currency = 4 THEN 250000  --TB
			WHEN @currency = 13 THEN 50000  --RMB
			WHEN @currency = 3 THEN 8000  --USD
			ELSE 0
			END
		,@maxperball = CASE 
			WHEN @currency = 4 THEN 150000  --TB
			WHEN @currency = 13 THEN 30000  --RMB
			WHEN @currency = 3 THEN 500  --USD
			ELSE 0
			END

	IF (@minbet = 0)  RETURN 
	 					
	UPDATE cs WITH(UPDLOCK,ROWLOCK)
	SET cs.maxpermatch161 = @maxpermatch,
	    cs.MaxPerBall161 = @maxperball
	FROM  Custinfo cs
	WHERE srecommend = @srecommend
	AND mrecommend NOT IN ( SELECT custid  FROM  custinfo WITH(NOLOCK)
						    WHERE username like '%Acc%' AND roleid=3)
	AND custid<=@maxcustid
		

	-- Update number game bet setting
	UPDATE newVS WITH(UPDLOCK,ROWLOCK)
	SET    newVS.minbet = @minbet
		  ,newVS.maxbet = @maxbet
	FROM  Dep_CustSetting3rd newVS 
	INNER JOIN custInfo c WITH(NOLOCK) ON c.custid=newVS.custid
	WHERE srecommend=@srecommend
	AND newVS.sporttype=161
	AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
						   WHERE username like '%Acc%' and roleid=3)
	AND newVS.custid<=@maxcustid
	

  
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


-- BEGIN STEP 2: RUN THIS SCRIPT AT DBTRANS/CustDB -----
-------------------------------------------------
CREATE TABLE #Supers (currency int , custid INT PRIMARY KEY, isfinished bit default(0))
DECLARE @currency int ,@srecommend int ,  @maxcustid int
SELECT @maxcustid= xxx --input maxcustid here

INSERT INTO #Supers(currency,custid)
SELECT currency, custid 
FROM  Dep_CustSuper WITH(NOLOCK) WHERE site = 'SLC88' and currency in (3,13,4)  ---USD, TB, RMB
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@currency = currency
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @currency = @currency, @srecommend = @srecommend, @maxcustid=@maxcustid, @target = 'REPLICATED'  		
	
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #Supers
GO

---- END of step 2

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS/CustDB -----
-------------------------------------------------
-------------------------------------------------
CREATE TABLE #Supers (currency int , custid INT PRIMARY KEY, isfinished bit default(0))
Declare @currency int ,@srecommend int ,  @maxcustid int
 SELECT @maxcustid= xxx --input maxcustid here

INSERT INTO #Supers(currency,custid)
 SELECT currency, custid 
 FROM  Dep_CustSuper WITH(NOLOCK) WHERE site = 'SLC88' and currency in (3,13,4)  ---USD, RMB, TB 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@currency = currency
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @currency = @currency, @srecommend = @srecommend, @maxcustid=@maxcustid, @target = 'DBTRANS'  		
	
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #Supers
GO