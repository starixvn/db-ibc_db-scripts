/*
	Created: Elodie
	Date: 2015-10-19
	Task: Copy Muay Thai settings from Other Sports for deposit customer
	DB: DBCUST/CustDB
*/ 

--STEP 1: DEPLOY THIS SP @DBCUST.CustDB -----
-----------------------------------------------
ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
	@ids varchar(max),
    @currency INT
AS
BEGIN	
	SET NOCOUNT ON
	
	IF dbo.f_CheckRepTable('Custinfo') = 0
		RETURN		

	declare @string varchar(max), @splitter char(1), @xml XML
	select @splitter = ',' ,@string = @ids

	SET @XML = N'<root><r>' + REPLACE(@string, @splitter, '</r><r>') + '</r></root>'

	declare @res AS TABLE(custid INT)
	INSERT INTO @res(custid)
	SELECT r.value('.','VARCHAR(12)')
	FROM @xml.nodes('//root/r') AS RECORDS(r)

	DECLARE @maxPerMatch MONEY

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

	IF @currency IN (3,16,17,35,36,40,64,65,68) --USD
	BEGIN
		UPDATE ci 
		SET ci.MaxPerMatch44 = ci.maxpermatch99
		FROM custInfo ci WITH(ROWLOCK, UPDLOCK)
		WHERE ci.custid IN (SELECT custid FROM @res)
			AND roleid IN (4,3)

		UPDATE ci 
		SET ci.MaxPerMatch44 = @maxPerMatch
		FROM custInfo ci WITH(ROWLOCK, UPDLOCK)
		WHERE ci.custid IN (SELECT custid FROM @res)
			AND ci.recommend NOT IN (18839496,18839497,13880633,13880635,10393717,10842822) --12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05
			AND roleid IN (2,1)

		UPDATE ci 
		SET ci.MaxPerMatch44 = 1500
		FROM custInfo ci WITH(ROWLOCK, UPDLOCK)
		WHERE ci.custid IN (SELECT custid FROM @res)
			AND ci.recommend IN (18839496,18839497,13880633,13880635,10393717,10842822) --12betUS$INR, 12betUS$INR01, 12BETUS$JP, 12BETUS$JP01, 12betUS$KR, 12BETUS$KR05
			AND roleid IN (2,1)

	END
	ELSE
	BEGIN
		--custInfo
		UPDATE ci 
		SET ci.MaxPerMatch44 = ci.maxpermatch99
		FROM custInfo ci WITH(ROWLOCK, UPDLOCK)
		WHERE ci.custid IN (SELECT custid FROM @res)
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

INSERT INTO #list (custid, isfinished)
SELECT custid, 0
FROM customer WITH(NOLOCK)
WHERE roleid in (1,2,3,4)
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

	EXEC Acc_ExecRep_Cust_09 @ids = @ids, @currency = @currency
	
	if @rowcnt < 1000 Break

	WAITFOR DELAY '00:00:00.280'
end	

DROP TABLE #list