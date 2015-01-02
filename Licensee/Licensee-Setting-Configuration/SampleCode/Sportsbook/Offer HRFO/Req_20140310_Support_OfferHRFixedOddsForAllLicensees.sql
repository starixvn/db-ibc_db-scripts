  /*
	Created: Julien
	Date: 2014-03-10
	Task: Offer HR Fixed Odds for all licensees
	DB: DBTXN/CustDB
 */


-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only

	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('custinfo') AND type = 'U'
		) <> 1 RETURN 
	 					
	UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
	SET maxpermatch154 = maxpermatch99,
		DisableHRFixedOdds = 0
	WHERE srecommend = @srecommend 
		AND custid <= @maxcustid
						
	IF (SELECT COUNT(1)
		FROM sys.objects
		WHERE NAME IN ('Dep_CustSetting') AND type = 'U'
		) <> 1 RETURN	

	UPDATE hr WITH(UPDLOCK,ROWLOCK)
	SET hr.spositiontaking = o.spositiontaking
			, hr.mpositiontaking = o.mpositiontaking
			, hr.apositiontaking = o.apositiontaking
			, hr.sdiscount = o.sdiscount
			, hr.adiscount = o.adiscount
			, hr.discount = o.discount
			, hr.playerdiscount = o.playerdiscount
			, hr.minbet = o.minbet
			, hr.maxbet = o.maxbet
	From Dep_CustSetting hr inner join Dep_CustSetting o with (nolock) 
				on hr.custid = o.custid
				And hr.sporttype = 154 and hr.bettype = 20
				and o.sporttype = 99 and o.bettype = 20
	where hr.custid IN (SELECT custid 
					FROM custinfo with(NOLOCK)
					WHERE srecommend = @srecommend 
						AND custid <= @maxcustid
				)
		And (hr.spositiontaking <> o.spositiontaking
			or hr.mpositiontaking <> o.mpositiontaking
			or hr.apositiontaking <> o.apositiontaking
			or hr.sdiscount <> o.sdiscount
			or hr.adiscount <> o.adiscount
			or hr.discount <> o.discount
			or hr.playerdiscount <> o.playerdiscount
			or hr.minbet <> o.minbet
			or hr.maxbet <> o.maxbet) 

	INSERT INTO [dbo].[Dep_CustSetting]
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
	SELECT [custid]
		   ,20 as [bettype]
		   ,154 as [sporttype]
		   ,[islive]
		   ,[apositiontaking]
		   ,[mpositiontaking]
		   ,[spositiontaking]
		   ,[playerdiscount]
		   ,[discount]
		   ,[adiscount]
		   ,[sdiscount]
		   ,[minbet]
		   ,[maxbet]
	FROM Dep_CustSetting with(NOLOCK)
	WHERE custid IN (SELECT c.custid 
					FROM custinfo c with(NOLOCK) left join Dep_CustSetting cs with (nolock)
						on c.custid = cs.custid and cs.sporttype = 154 and cs.bettype = 20
					WHERE c.srecommend = @srecommend 
						AND c.custid <= @maxcustid
						And cs.custid is null
				)	
		AND sporttype = 99
		AND bettype = 20
			 
   
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------




-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
--------------------------------------------------------------------------------------

CREATE TABLE #Supers (custid INT PRIMARY KEY, isfinished bit default(0))

INSERT INTO #Supers(custid)
SELECT custid 
FROM Dep_CustSuper with(NOLOCK)

DECLARE @max_custid INT, @srecommend INT
SET @max_custid = xxx 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend		
		,@maxcustid = @max_custid
		,@target = 'REPLICATED'
		
	WAITFOR DELAY '00:00:00.280'
END
GO

-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
------------------------------------------------------



-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #Supers (custid INT PRIMARY KEY, isfinished bit default(0))

INSERT INTO #Supers(custid)
SELECT custid 
FROM Dep_CustSuper with(NOLOCK)

DECLARE @max_custid INT, @srecommend INT
SET @max_custid = xxx 

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_ExecRep_Cust_09 @srecommend = @srecommend		
		,@maxcustid = @max_custid
		,@target = 'DBTRANS'
		
	WAITFOR DELAY '00:00:00.280'
END
GO
-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------



--STEP 4: UPDATE SETTINGs FOR NEW CUSTOMERs
-------------------------------------------------
DECLARE @max_custid INT
SET @max_custid = xxx

UPDATE custinfo WITH(UPDLOCK,ROWLOCK)
SET maxpermatch154 = maxpermatch99,
	DisableHRFixedOdds = 0
WHERE srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND custid > @max_custid

UPDATE hr WITH(UPDLOCK,ROWLOCK)
	SET hr.spositiontaking = o.spositiontaking
			, hr.mpositiontaking = o.mpositiontaking
			, hr.apositiontaking = o.apositiontaking
			, hr.sdiscount = o.sdiscount
			, hr.adiscount = o.adiscount
			, hr.discount = o.discount
			, hr.playerdiscount = o.playerdiscount
			, hr.minbet = o.minbet
			, hr.maxbet = o.maxbet
	From Dep_CustSetting hr inner join Dep_CustSetting o with (nolock) 
				on hr.custid = o.custid
				And hr.sporttype = 154 and hr.bettype = 20
				and o.sporttype = 99 and o.bettype = 20
	where hr.custid IN (SELECT custid 
				FROM custinfo with(NOLOCK)
				WHERE srecommend IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
					AND custid > @max_custid
			)
