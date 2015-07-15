 
  /*
	Task: Offer SLC88  Virtual Sports 
	Redmineid: https://redmine.nexcel.vn/issues/39140
	DB: DBTXN/CustDB
	Total mem   Custid		Username	   Currency
	 496		12158924	SLC88SuperRMB	13      
	 7		   12158888	    SLC88SuperUS$	3       
	 3		   12158949	    SLC88SuperTB	4       
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

	IF (SELECT COUNT(1)  FROM  sys.objects WHERE name IN ('Dep_Custsetting3rd','custinfo','Dep_Custsetting') AND type = 'U') <> 3
		RETURN

	DECLARE @minbet money, @maxbet money, @maxpermatch money,  @ptVALUE SMALLMONEY
	
	 SELECT @ptVALUE = 0.85  --Virtual sports PT 
	 
	 SELECT @minbet = CASE 
			WHEN @currency = 4 THEN 10  --TB
			WHEN @currency = 13 THEN 2  --RMB
			WHEN @currency = 3 THEN 1  --USD	
			ELSE 0
			END
		,@maxbet = CASE 
			WHEN @currency = 4 THEN 15000  --TB
			WHEN @currency = 13 THEN 3000  --RMB
			WHEN @currency = 3 THEN 500  --USD
			ELSE 0
			END
		,@maxpermatch = CASE 
			WHEN @currency = 4 THEN 50000  --TB
			WHEN @currency = 13 THEN 10000  --RMB
			WHEN @currency = 3 THEN 1500  --USD
			ELSE 0
			END

	IF (@minbet = 0)  RETURN 
	 					
	UPDATE cs WITH(UPDLOCK,ROWLOCK)
	SET cs.maxpermatch180 = @maxpermatch,
	    cs.maxpermatch181 = @maxpermatch,
		cs.maxpermatch182 = @maxpermatch,
		cs.maxpermatch183 = @maxpermatch,
		cs.maxpermatch184 = @maxpermatch,
		cs.maxpermatch185 = @maxpermatch,
		cs.maxpermatch186 = @maxpermatch,
		DisableVirtualSports = 0,
		HideVirtualSports = 0
	 FROM  Custinfo cs
	WHERE srecommend = @srecommend
	AND custid<=@maxcustid
		

   -- create temp table containing all accounts belong to super
	CREATE TABLE #tblCust (custid int, roleid int, sporttype int, bettype int)
	
	INSERT INTO #tblCust (custid,roleid, sporttype,bettype)
		 SELECT custid,roleid, sporttype, bettype
		 FROM  custinfo WITH (nolock)
		CROSS JOIN (
					 SELECT 180 as sporttype, 1201 as bettype 
					UNION ALL  SELECT 181 as sporttype, 1231 as bettype 
					UNION ALL  SELECT 182 as sporttype, 1231 as bettype 
					UNION ALL  SELECT 183 as sporttype, 1231 as bettype 
					UNION ALL  SELECT 184 as sporttype, 1231 as bettype 
					UNION ALL  SELECT 185 as sporttype, 1231 as bettype 
					UNION ALL  SELECT 186 as sporttype, 1220 as bettype 
				) t
	    WHERE srecommend = @srecommend
		AND custid<=@maxcustid

	-- Update VS bet setting
	UPDATE newVS WITH(UPDLOCK,ROWLOCK)
	SET     newVS.spositiontaking = CASE WHEN roleid = 4 THEN @ptVALUE ELSE 0 END 
			, newVS.mpositiontaking = CASE WHEN roleid in (4,3)  THEN @ptVALUE ELSE 0 END 
			, newVS.apositiontaking = CASE WHEN roleid = 3  THEN 0 ELSE @ptVALUE END 
			, newVS.sdiscount = 0
			, newVS.adiscount = 0
			, newVS.discount = 0
			, newVS.playerdiscount = 0
			, newVS.minbet = @minbet
			, newVS.maxbet = @maxbet
	 FROM  Dep_CustSetting3rd newVS 
	INNER JOIN #tblCust t ON newVS.custid = t.custid and newVS.sporttype = t.sporttype and newVS.bettype = t.bettype
	AND newVS.custid<=@maxcustid
	

    -- Remove Virtual sport that having setting in Dep_CustSetting3rd
	 DELETE t 
	  FROM  #tblCust t 
	 INNER JOIN Dep_CustSetting3rd cs ON t.custid = cs.custid and t.sporttype = cs.sporttype and t.bettype = cs.bettype 
	 
	--Insert  missing data into dep_custsetting3rd 	
	INSERT INTO [dbo].[Dep_CustSetting3rd]
			   ([custid]
			   ,[bettype]
			   ,[sporttype]
			   ,[islive]
			   ,[apositiontaking]
			   ,[mpositiontaking]
			   ,[spositiontaking]
			   ,[playerdiscount]
			   ,[discount]
			   ,[adiscount]
			   ,[sdiscount]
			   ,[minbet]
			   ,[maxbet])
	 SELECT  custid
		   ,bettype as [bettype]
		   ,sporttype as [sporttype]
		   ,0 [islive]
		   ,case when roleid = 3  THEN 0 ELSE @ptVALUE END as [apositiontaking]
		   ,case when roleid in (4,3)  THEN @ptVALUE ELSE 0 END as [mpositiontaking]
		   ,case when roleid = 4 THEN @ptVALUE ELSE 0 END as [spositiontaking]
		   ,0 as [playerdiscount]
		   ,0 as [discount]
		   ,0 as [adiscount]
		   ,0 as [sdiscount]
		   ,@minbet
		   ,@maxbet
	 FROM  #tblCust 
	
	DROP TABLE #tblCust
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


-- BEGIN STEP 2: RUN THIS SCRIPT AT DBTRANS/CustDB -----
-------------------------------------------------
CREATE TABLE #Supers (currency int , custid INT PRIMARY KEY, isfinished bit default(0))
Declare @currency int ,@srecommend int ,  @maxcustid int
 SELECT @maxcustid= xxx --input maxcustid here

INSERT INTO #Supers(currency,custid)
 SELECT currency, custid 
 FROM  Dep_CustSuper WITH(NOLOCK)where site = 'SLC88' and currency in (3,13,4)  ---US$, EURO, AUD, IN ENTER Site and Currency 

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
 FROM  Dep_CustSuper WITH(NOLOCK)where site = 'SLC88' and currency in (3,13,4)  ---US$, RMB, TB 

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