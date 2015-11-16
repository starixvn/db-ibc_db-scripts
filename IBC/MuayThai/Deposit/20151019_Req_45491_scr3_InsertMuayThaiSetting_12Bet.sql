/*
	Created: Elodie
	Date: 2015-10-19
	Task: Insert Muay Thai settings for 12BET
	DB: DBCUST/CustDB
*/ 
--Step 1: add customer settings into Dep_CustSetting
-- DEPLOY THIS SP @ DBCUST.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@srecommend INT	
	,@target VARCHAR(30)
	,@maxcustid INT
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only\

	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
			AND dbo.f_CheckRepTable('Dep_CustSetting') = 1
			)
		RETURN			
	
	DECLARE @minbet MONEY, @maxbet MONEY, @currency INT
	SELECT @currency = currency FROM CustInfo WITH (NOLOCK) WHERE custid = @srecommend
	
	SELECT	@minbet =  CASE 
							WHEN @currency = 2 THEN 5  -- MYR
							WHEN @currency IN (15,22,33,34,47) THEN 15  --IDR
							WHEN @currency = 61 THEN 75  --INR
							WHEN @currency IN (44,45,62) THEN 1000  --KRW
							WHEN @currency IN (13,66) THEN 10  --CNY
							WHEN @currency IN (4,43) THEN 50  --THB
							WHEN @currency = 51 THEN 30  --VND
							WHEN @currency IN (9,6,12) THEN 1 --AUD,EUR,GBP
							WHEN @currency IN (3,16,17,35,36,40,64,65,68) THEN 1  --USD
					   ELSE 0 END,
		
			@maxbet =  CASE 
							WHEN @currency = 2 THEN 2000  --RM
							WHEN @currency IN (15,22,33,34,47) THEN 5000  --IDR
							WHEN @currency = 61 THEN 25000  --INR
							WHEN @currency IN (44,45,62) THEN 500000  --KRW
							WHEN @currency IN (13,66) THEN 3000  --CNY
							WHEN @currency IN (4,43) THEN 20000  --THB
							WHEN @currency = 51 THEN 10000  --VND
							WHEN @currency IN (9,6,12) THEN 100 --AUD,EUR,GBP
							WHEN @currency IN (3,16,17,35,36,40,64,65,68) THEN 100  --USD
					   ELSE 0 END

	IF (@minbet = 0) RETURN
	
	--Copy setting from Other Sports for super, master
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
	SELECT cs.[custid]
			,[bettype]
			,44
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
	FROM [Dep_CustSetting] cs WITH(NOLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.srecommend = @srecommend
			AND  ci.custid <= @maxcustid
			AND sporttype = 99 and bettype = 3
			AND roleid IN (4,3)				 

	--Insert setting with specific value for agent, member except 12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05
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
	SELECT cs.[custid]
			,[bettype]
			,44
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
	FROM [Dep_CustSetting] cs WITH(NOLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.srecommend = @srecommend
			AND  ci.custid <= @maxcustid
			AND sporttype = 99 and bettype = 3
			AND roleid IN (2,1)
			AND ci.recommend NOT IN (18839496,18839497,13880633,13880635,10393717,10842822) 
	
	--Insert setting with specific value for 12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05
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
	SELECT cs.[custid]
			,[bettype]
			,44
			,[islive]
			,[apositiontaking]
			,[mpositiontaking]
			,[spositiontaking]
			,[playerdiscount]
			,[discount]
			,[adiscount]
			,[sdiscount]
			,1 AS minbet
			,500 AS maxbet
	FROM [Dep_CustSetting] cs WITH(NOLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON cs.custid = ci.custid
	WHERE ci.srecommend = @srecommend -- 12BETSuperUS$
			AND  ci.custid <= @maxcustid
			AND sporttype = 99 and bettype = 3
			AND roleid IN (2,1) 
			AND ci.recommend IN (18839496,18839497,13880633,13880635,10393717,10842822) --12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05						
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid= xx

INSERT INTO #supers(custid)
SELECT custid
FROM customer WITH(NOLOCK)
WHERE custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND custid <= @max_custid	
	AND site = '12Bet' 
	AND currency IN (2,3,4,6,9,12,13,15,16,17,22,33,34,35,36,40,43,44,45,47,51,61,62,64,65,66,68)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] 
			srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
	
	WAITFOR DELAY '00:00:00.280'			
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB06/DBTP) -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT

SELECT @max_custid= xx

INSERT INTO #supers(custid)
SELECT custid
FROM customer WITH(NOLOCK)
WHERE custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND custid <= @max_custid	
	AND site = '12Bet' 
	AND currency IN (2,3,4,6,9,12,13,15,16,17,22,33,34,35,36,40,43,44,45,47,51,61,62,64,65,66,68)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] 
			@srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
	
	WAITFOR DELAY '00:00:00.280'			
END			
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------