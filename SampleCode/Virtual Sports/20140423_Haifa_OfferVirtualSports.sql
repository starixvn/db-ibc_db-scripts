  /*
	Created: Jerry Tran
	Date: 2014-04-23
	Task: Offer Haifa Virtual Sports (excluding Virtual Cycling and Virtual Speedway)
	DB: DBTXN/CustDB
 */


-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	 @currency INT
	 ,@srecommend INT	
	 ,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only

	
	IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('Dep_Custsetting3rd','custinfo','Dep_Custsetting') AND type = 'U') <> 3
		RETURN

	DECLARE @minbet money, @maxbet money, @maxpermatch money
	
	SELECT @minbet = case when @currency = 4  then 10
						  when @currency = 13 then 10
						  when @currency = 45 then 1800
						  when @currency = 51 then 30
						  when @currency = 3  then 2
						  when @currency = 32 then 150
					  else 0 end,
			
			@maxbet = case when @currency = 4  then 10000
						   when @currency = 13 then 50000
						   when @currency = 45 then 9000000
						   when @currency = 51 then 150000
						   when @currency = 3  then 7000
						   when @currency = 32 then 750000
						else 0 end,

			@maxpermatch = case when @currency = 4  then 50000
								when @currency = 13 then 200000
								when @currency = 45 then 36000000
								when @currency = 51 then 300000
								when @currency = 3  then 50000
								when @currency = 32 then 3000000
						   else 0 end

	IF (@minbet = 0)  RETURN 
	 					
	UPDATE cs WITH(UPDLOCK,ROWLOCK)
	SET cs.maxpermatch180 = @maxpermatch,
	    cs.maxpermatch181 = @maxpermatch,
		cs.maxpermatch182 = @maxpermatch,
		cs.maxpermatch184 = @maxpermatch,
		cs.maxpermatch186 = @maxpermatch,
		DisableVirtualSports = 0,
		HideVirtualSports = 0
	FROM Custinfo cs
	WHERE srecommend = @srecommend 
		

   -- create temp table containing all accounts belong to super
	CREATE TABLE #tblCust (custid int, sporttype int, bettype int)
	
	INSERT INTO #tblCust (custid, sporttype,bettype)
		SELECT custid, sporttype, bettype
		FROM custinfo with (nolock)
		CROSS JOIN (
					SELECT 180 as sporttype, 1201 as bettype 
					UNION ALL SELECT 181 as sporttype, 1231 as bettype 
					UNION ALL SELECT 182 as sporttype, 1231 as bettype 
					UNION ALL SELECT 184 as sporttype, 1231 as bettype 
					UNION ALL SELECT 186 as sporttype, 1220 as bettype 
				) t
	    WHERE srecommend = @srecommend

	DECLARE @bettype int, @sporttype int
	SELECT @bettype = 1, @sporttype =1

	-- Update VS bet setting based on Soccer handicap bet setting 
	UPDATE newVS WITH(UPDLOCK,ROWLOCK)
	SET     newVS.spositiontaking = cs.spositiontaking
			, newVS.mpositiontaking = cs.mpositiontaking
			, newVS.apositiontaking = cs.apositiontaking
			, newVS.sdiscount = cs.sdiscount
			, newVS.adiscount = cs.adiscount
			, newVS.discount = cs.discount
			, newVS.playerdiscount = cs.playerdiscount
			, newVS.minbet = @minbet
			, newVS.maxbet = @maxbet
	FROM Dep_CustSetting3rd newVS 
	INNER JOIN Dep_CustSetting cs with (nolock) ON newVS. custid = cs.custid and cs.sporttype = @sporttype and cs.bettype = @bettype  and cs.islive = 0
	INNER JOIN #tblCust t ON newVS.custid = t.custid and newVS.sporttype = t.sporttype and newVS.bettype = t.bettype
	where   newVS.spositiontaking <> cs.spositiontaking
			or newVS.mpositiontaking <> cs.mpositiontaking
			or newVS.apositiontaking <> cs.apositiontaking
			or newVS.sdiscount <> cs.sdiscount
			or newVS.adiscount <> cs.adiscount
			or newVS.discount <> cs.discount
			or newVS.playerdiscount <> cs.playerdiscount
			or newVS.minbet <> @minbet
			or newVS.maxbet <> @maxbet

    -- Remove Virtual sport that having setting in Dep_CustSetting3rd
	 DELETE t 
	 FROM #tblCust t 
	 INNER JOIN Dep_CustSetting3rd cs on t.custid = cs.custid and t.sporttype = cs.sporttype and t.bettype = cs.bettype 
	 
	 	
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
	SELECT cs.custid
		   ,t.bettype as [bettype]
		   ,t.sporttype as [sporttype]
		   ,[islive]
		   ,[apositiontaking]
		   ,[mpositiontaking]
		   ,[spositiontaking]
		   ,[playerdiscount]
		   ,[discount]
		   ,[adiscount]
		   ,[sdiscount]
		   ,@minbet
		   ,@maxbet
	FROM Dep_CustSetting cs with(NOLOCK)
	INNER JOIN #tblCust t on cs.custid = t.custid and cs.sporttype = @sporttype and cs.bettype = @bettype and islive = 0
	
	DROP TABLE #tblCust
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------




-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------

CREATE TABLE #Supers (currency int , custid INT PRIMARY KEY, isfinished bit default(0))
Declare @currency int ,@srecommend int 

INSERT INTO #Supers(currency,custid)
SELECT currency, custid 
FROM Dep_CustSuper with(NOLOCK) where site = 'haifa' and currency in (4,13,45,51,3,32)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@currency = currency
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @currency = @currency, @srecommend = @srecommend		
		,@target = 'REPLICATED'
		
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #Supers
GO

-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
------------------------------------------------------



-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #Supers (currency int , custid INT PRIMARY KEY, isfinished bit default(0))
Declare @currency int ,@srecommend int 

INSERT INTO #Supers(currency,custid)
SELECT currency, custid 
FROM Dep_CustSuper with(NOLOCK) where site = 'haifa' and currency in (4,13,45,51,3,32)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@currency = currency
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @currency = @currency, @srecommend = @srecommend		
		,@target = 'DBTRANS'
		
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #Supers
GO

