/*
	Created: Elodie
	Date: 2015-10-19
	Task: Copy Muay Thai settings for 12Bet customer
	DB: DBCUST/CustDB
*/ 

--STEP 1: DEPLOY THIS SP @DBCUST.CustDB -----
-----------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@srecommend INT
	,@target     VARCHAR(30)
	,@maxcustid INT
AS
BEGIN	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only

	IF dbo.f_CheckRepTable('Custinfo') = 0
		RETURN			

	DECLARE @maxPerMatch MONEY, @currency INT
	SELECT @currency = currency FROM CustInfo WITH (NOLOCK) WHERE custid = @srecommend

	SELECT	@maxPerMatch =  CASE 
							WHEN @currency = 2 THEN 5000  -- MYR
							WHEN @currency IN (15,22,33,34,47) THEN 15000  --IDR
							WHEN @currency = 61 THEN 75000  --INR
							WHEN @currency IN (44,45,62) THEN 1500000  --KRW
							WHEN @currency IN (13,66) THEN 10000  --CNY
							WHEN @currency IN (4,43) THEN 50000  --THB
							WHEN @currency = 51 THEN 30000  --VND
							WHEN @currency IN (9,6,12) THEN 300 --AUD,EUR,GBP
							WHEN @currency IN (3,16,17,35,36,40,64,65,68) THEN 300  --USD
					   ELSE 0 END
	
	--Copy setting from Other Sports for super, master
	UPDATE ci 
	SET ci.MaxPerMatch44 = ci.maxpermatch99
	FROM custInfo ci WITH(ROWLOCK, UPDLOCK)
	WHERE srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND roleid IN (4,3)
	
	--Insert setting with specific value for agent, member except 12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05
	UPDATE ci 
	SET ci.MaxPerMatch44 = @maxPerMatch
	FROM custInfo ci WITH(ROWLOCK, UPDLOCK)
	WHERE srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND ci.recommend NOT IN (18839496,18839497,13880633,13880635,10393717,10842822) --12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05
		AND roleid IN (2,1)
	
	IF @srecommend = 791080
	BEGIN
		--Insert setting with specific value for 12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05
		UPDATE ci 
		SET ci.MaxPerMatch44 = 1500
		FROM custInfo ci WITH(ROWLOCK, UPDLOCK)
		WHERE srecommend = @srecommend
			AND ci.custid <= @maxcustid
			AND ci.recommend IN (18839496,18839497,13880633,13880635,10393717,10842822) --12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05
			AND roleid IN (2,1)	
	END
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------	

---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP -----
--------------------------------------------------------------------------------------
CREATE TABLE #CustSuper(srecommend INT , isfinished BIT DEFAULT(0))	

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
	UPDATE TOP (1) #CustSuper
	   SET isfinished = 1
		 , @srecommend = srecommend
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_ExecRep_Cust_09
	   @srecommend = @srecommend
	  ,@target = 'REPLICATED'
	  ,@maxcustid = @max_custid

    WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #CustSuper

GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
-------------------------------------------------
CREATE TABLE #CustSuper(srecommend INT , isfinished BIT DEFAULT(0))	

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
	UPDATE TOP (1) #CustSuper
	   SET isfinished = 1
		 , @srecommend = srecommend			
	 WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.Acc_ExecRep_Cust_09	
	  @srecommend = @srecommend
	  ,@target = 'DBCUST'
	  ,@maxcustid = @max_custid
	  
	WAITFOR DELAY '00:00:00.280'
END

DROP TABLE #CustSuper

GO	

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -------
-------------------------------------------------