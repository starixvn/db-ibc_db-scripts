 
  /*
	Task: Offer   Virtual Sports 
	Create date: 2015-03-17
	Author: Susan
	Redmine link: https://redmine.nexcel.vn/issues/32246
	DB: DBTXN/CustDB
 */


-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	 @currency INT
	 ,@srecommend INT	
	 ,@target VARCHAR(20)
	 ,@max_custid int
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

			WHEN @currency = 4 THEN 10  --TB
			WHEN @currency = 3 THEN 1  --US$
			WHEN @currency = 20 THEN 1  --UUS
			ELSE 0
			END
		,@maxbet = CASE 
			
			WHEN @currency = 4 THEN 1500  --TB
			WHEN @currency = 3 THEN 500  --US$
			WHEN @currency = 20 THEN 500  --UUS
			ELSE 0
			END
		,@maxpermatch = CASE 
			WHEN @currency = 4 THEN 50000  --TB
			WHEN @currency = 3 THEN 1500  --US$
			WHEN @currency = 20 THEN 1500  --UUS
			ELSE 0
			END

	IF (@minbet = 0)  RETURN 

--- update custinfo table 	:11329 rows affected			
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
	AND mrecommend not in (select custid from custInfo with(nolock) where roleid=3 and username like '%Acc%')
	AND custid<=@max_custid
			
   -- create temp table containing all accounts belong to super
	CREATE TABLE #tblCust (custid int, roleid int, sporttype int, bettype int)

--79331 rows	
	INSERT INTO #tblCust (custid,roleid, sporttype,bettype)
		SELECT custid,roleid, sporttype, bettype
		FROM custinfo with (nolock)
		CROSS JOIN (
					SELECT 180 as sporttype, 1201 as bettype 
					UNION ALL SELECT 181 as sporttype, 1231 as bettype 
					UNION ALL SELECT 182 as sporttype, 1231 as bettype 
					UNION ALL SELECT 183 as sporttype, 1231 as bettype 
					UNION ALL SELECT 184 as sporttype, 1231 as bettype 
					UNION ALL SELECT 185 as sporttype, 1231 as bettype 
					UNION ALL SELECT 186 as sporttype, 1220 as bettype 
				) t
	    WHERE srecommend = @srecommend
		AND mrecommend not in (select custid from custInfo with(nolock) where roleid=3 and username like '%Acc%')
		and custid<= @max_custid


	-- Update VS bet setting: 71373 rows
	UPDATE newVS WITH(UPDLOCK,ROWLOCK)
	SET     newVS.spositiontaking = case when roleid = 4 then @ptVALUE else 0 end 
			, newVS.mpositiontaking = case when roleid in (4,3)  then @ptVALUE else 0 end 
			, newVS.apositiontaking = case when roleid = 3  then 0 else @ptVALUE end 
			, newVS.sdiscount = 0
			, newVS.adiscount = 0
			, newVS.discount = 0
			, newVS.playerdiscount = 0
			, newVS.minbet = @minbet
			, newVS.maxbet = @maxbet
	FROM Dep_CustSetting3rd newVS 
	INNER JOIN #tblCust t ON newVS.custid = t.custid and newVS.sporttype = t.sporttype and newVS.bettype = t.bettype
	and newVS.custid <=@max_custid
	

    -- Remove Virtual sport that having setting in Dep_CustSetting3rd
	 DELETE t 
	 FROM #tblCust t 
	 INNER JOIN Dep_CustSetting3rd cs on t.custid = cs.custid and t.sporttype = cs.sporttype and t.bettype = cs.bettype 
	 
	---7958 rows  	
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
		   ,case when roleid = 3  then 0 else @ptVALUE end as [apositiontaking]
		   ,case when roleid in (4,3)  then @ptVALUE else 0 end as [mpositiontaking]
		   ,case when roleid = 4 then @ptVALUE else 0 end as [spositiontaking]
		   ,0 as [playerdiscount]
		   ,0 as [discount]
		   ,0 as [adiscount]
		   ,0 as [sdiscount]
		   ,@minbet
		   ,@maxbet
	FROM #tblCust 
	
	DROP TABLE #tblCust

END
GO-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


-- BEGIN STEP 2: RUN THIS SCRIPT AT REPLICATE DB -----
-------------------------------------------------
CREATE TABLE #Supers ( custid INT PRIMARY KEY,currency int , isfinished bit default(0))
Declare @currency int ,@srecommend int , @max_custid int
select @max_custid=xxx ---input maxcustid here

---inser super in to #supers: 
INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
					  where site in ('Bet2day','Allbetclub','Hbobet','Mgm88','THBET','Winner99')  ---103,132,121,120,136,106
					   and currency  in (3,4,20)						
AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@currency = currency
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @currency = @currency, @srecommend = @srecommend, @max_custid= @max_custid, @target = 'REPLICATED'  			
	
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #Supers
GO

---- End of step 2

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS/CustDB -----
-------------------------------------------------
-------------------------------------------------
CREATE TABLE #Supers ( custid INT PRIMARY KEY,currency int , isfinished bit default(0))
Declare @currency int ,@srecommend int , @max_custid int
select @max_custid=xxx ---input maxcustid here

---inser super in to #supers: 
INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
					  where site in ('Bet2day','Allbetclub','Hbobet','Mgm88','THBET','Winner99')  ---103,132,121,120,136,106
					   and currency  in (3,4,20)						
AND custid <= @max_custid

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@currency = currency
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @currency = @currency, @srecommend = @srecommend, @max_custid= @max_custid ,@target = 'DBTRANS'  			
	
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #Supers
GO

---- End of step 3