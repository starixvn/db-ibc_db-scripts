 
  /*
	Task: Offer BE7  Virtual Sports 
	Create date: 2014-12-15
	Author: Susan
	Redmine link: https://redmine.nexcel.vn/issues/27595
	DB: DBTXN/CustDB
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

	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only

	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('Dep_Custsetting3rd','custinfo') AND type = 'U') <> 2
		RETURN

	DECLARE @minbet money, @maxbet money, @maxpermatch money,  @ptVALUE SMALLMONEY
	
	SELECT @ptVALUE = 0.85  --Virtual sports PT 
	 
	SELECT @minbet = CASE 
			WHEN @currency = 15 THEN 1  --IN
			WHEN @currency = 3 THEN 1  --US$
			WHEN @currency = 13 THEN 1  --RMB
			WHEN @currency = 4 THEN 10  --THB
			WHEN @currency = 2 THEN 1  --MYR
			ELSE 0
			END
		,@maxbet = CASE 
			WHEN @currency = 15 THEN 5000  --IDR
			WHEN @currency = 3 THEN 500  --US$
			WHEN @currency = 13 THEN 3000  --RMB
			WHEN @currency = 4 THEN 15000  --THB
			WHEN @currency = 2 THEN 1500  --MYR
			ELSE 0
			END
		,@maxpermatch = CASE 
			WHEN @currency = 15 THEN 15000  --IDR
			WHEN @currency = 3 THEN 1500  --US$
			WHEN @currency = 13 THEN 10000  --RMB
			WHEN @currency = 4 THEN 50000  --THB
			WHEN @currency = 2 THEN 5000  --MYR
			ELSE 0
			END

	IF (@minbet = 0)  RETURN 

--- update custinfo table 	:2849 rows affected			
	UPDATE Custinfo WITH(UPDLOCK,ROWLOCK)
	SET maxpermatch180 = @maxpermatch,
	    maxpermatch181 = @maxpermatch,
		maxpermatch182 = @maxpermatch,
		maxpermatch183 = @maxpermatch,
		maxpermatch184 = @maxpermatch,
		maxpermatch185 = @maxpermatch,
		maxpermatch186 = @maxpermatch,
		DisableVirtualSports = 0,
		HideVirtualSports = 0
	WHERE srecommend=@srecommend
	AND custid<=@maxcustid
			
-- Update VS bet setting: 19943 rows affected 
	UPDATE newVS WITH(UPDLOCK,ROWLOCK)
	SET    newVS.spositiontaking = case when roleid = 4 then @ptVALUE else 0 end 
		  ,newVS.mpositiontaking = case when roleid in (4,3)  then @ptVALUE else 0 end 
		  ,newVS.apositiontaking = case when roleid = 3  then 0 else @ptVALUE end 
		  ,newVS.sdiscount = 0
		  ,newVS.adiscount = 0
		  ,newVS.discount = 0
		  ,newVS.playerdiscount = 0
		  ,newVS.minbet = @minbet
		  ,newVS.maxbet = @maxbet
	FROM Dep_CustSetting3rd newVS 
	INNER JOIN custInfo c with(nolock) ON newVS.custid = c.custid 
	WHERE c.srecommend=@srecommend 
	AND newVS.sporttype IN (180,181,182,183,184,185,186)
	AND newVS.custid <=@maxcustid

END
GO-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


-- BEGIN STEP 2: RUN THIS SCRIPT AT REPLICATE DB -----
-------------------------------------------------
CREATE TABLE #Supers ( custid INT PRIMARY KEY,currency int , isfinished bit default(0))
Declare @currency int ,@srecommend int , @maxcustid int, @site varchar (50)
select @site='BE7',
	   @maxcustid=xxx ---input maxcustid here

---inser super in to #supers: 5 supers: BE7SuperIN, BE7SuperUS$, BE7SuperRMB, BE7SuperTB, BE7SuperRM
insert into #Supers
SELECT  custid,currency, 0
FROM Dep_CustSuper with(NOLOCK) where site = @site and currency <>20

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

---- End of step 2

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS/CustDB -----
-------------------------------------------------
-------------------------------------------------
CREATE TABLE #Supers ( custid INT PRIMARY KEY,currency int , isfinished bit default(0))
Declare @currency int ,@srecommend int , @maxcustid int, @site varchar (50)
select @site='BE7',
	   @maxcustid=xxx ---input maxcustid here

---inser super in to #supers: 5 supers: BE7SuperIN, BE7SuperUS$, BE7SuperRMB, BE7SuperTB, BE7SuperRM
insert into #Supers
SELECT custid ,currency, 0
FROM Dep_CustSuper with(NOLOCK) where site = @site and currency <>20

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@currency = currency
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @currency = @currency, @srecommend = @srecommend, @maxcustid=@maxcustid,@target = 'DBTRANS'  			
	
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #Supers
GO

---- End of step 3