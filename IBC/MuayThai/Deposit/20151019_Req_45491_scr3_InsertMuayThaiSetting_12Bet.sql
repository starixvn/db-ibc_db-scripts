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
	@ids varchar(max),
    @currency INT
AS
BEGIN	
	SET NOCOUNT ON
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
			AND dbo.f_CheckRepTable('Dep_CustSetting') = 1
			)
		RETURN		
	
	declare @string varchar(max), @splitter char(1), @xml XML
	select @splitter = ',' ,@string = @ids

	SET @XML = N'<root><r>' + REPLACE(@string, @splitter, '</r><r>') + '</r></root>'

	declare @res AS TABLE(custid INT)
	INSERT INTO @res(custid)
	SELECT r.value('.','VARCHAR(12)')
	FROM @xml.nodes('//root/r') AS RECORDS(r)

	DECLARE @minbet MONEY, @maxbet MONEY
	
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

	IF @currency IN (3,16,17,35,36,40,64,65,68) --USD
	BEGIN
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
		WHERE ci.custid IN (SELECT custid FROM @res)
			 AND sporttype = 99 and bettype = 3
			 AND ci.recommend IN (18839496,18839497,13880633,13880635,10393717,10842822) --12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05
			 AND roleid IN (2,1) 

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
		WHERE ci.custid IN (SELECT custid FROM @res)
			 AND sporttype = 99 and bettype = 3
			 AND ci.recommend NOT IN (18839496,18839497,13880633,13880635,10393717,10842822) AND roleid IN (2,1)

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
		WHERE ci.custid IN (SELECT custid FROM @res)
			 AND sporttype = 99 and bettype = 3
			 AND roleid IN (4,3)
	END
	ELSE
	BEGIN
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
		WHERE ci.custid IN (SELECT custid FROM @res)
			 AND sporttype = 99 and bettype = 3
	END 
		
END
GO
-- END STEP 1: DEPLOY THIS SP @ DBCUST.CustDB -------
------------------------------------------------------
---
---
-- BEGIN STEP 2: RUN THIS SCRIPT -----
--------------------------------------------------------------------------------------
CREATE TABLE #list (custid INT PRIMARY KEY, isfinished bit)

declare @currency int
 --2,3,4,6,9,12,13,15,16,17,22,33,34,35,36,40,43,44,45,47,51,61,62,64,65,66,68
SELECT @currency = 2	--MYR
	--@currency = 3		--USD
	--@currency = 4		--THB
	--@currency = 6		--EUR
	--@currency = 9		--AUD
	--@currency = 12	--GBP
	--@currency = 13	--CNY
	--@currency = 16	--USD
	--@currency = 17	--USD
	--@currency = 22	--IDR
	--@currency = 33	--IDR
	--@currency = 34	--IDR
	--@currency = 35	--USD
	--@currency = 36	--USD
	--@currency = 40	--USD
	--@currency = 43	--THB
	--@currency = 44	--KRW
	--@currency = 45	--KRW
	--@currency = 47	--IDR
	--@currency = 51	--VND
	--@currency = 61	--INR
	--@currency = 62	--KRW
	--@currency = 64	--USD
	--@currency = 65	--USD
	--@currency = 66	--CNY
	--@currency = 68	--USD

DECLARE @max_custid INT

SELECT @max_custid= xx

INSERT INTO #list (custid, isfinished)
SELECT custid, 0
FROM customer WITH(NOLOCK)
WHERE roleid in (1,2,3,4)
	AND custid <= @max_custid
	and srecommend in (
		select custid 
		from dep_custsuper with(nolock)
		where currency = @currency
			and site='12Bet'	
	)

declare @ids varchar(max), @rowcnt int

while (1=1)
begin
	select @ids = ''
	
	update TOP (1000) #list
	set @ids = @ids + case @ids when '' then '' else ',' end + cast(custid as varchar(12))
		,isfinished = 1
	from #list
	where isfinished = 0
	
	select @rowcnt = @@rowcount

	EXEC Acc_Custsetting3rd_19 @ids = @ids, @currency = @currency
	
	if @rowcnt < 1000 Break

	WAITFOR DELAY '00:00:00.280'
end	

DROP TABLE #list