/*
 Offer NG for W88 to member with bet limit as below: 
 https://redmine.nexcel.vn/issues/8176

ID	Currency  Min bet	Max bet		Max per ball	Max per match
3	usd		　1		    75000		75001			500000
13	RMB		　1			500000		500001			2000000
4	THB		　1			2500000		2500001			10000000
12	GBP		　1			10000		10001			100000
2	MYR		　1			250000		250001			1000000
9	AUD		　1			75000		75001			500000
15	IDR		　1			750000		750001			3000000
6	EUR		　1			10000		10001			100000
61	INR		  1			4000000		4000001			16000000
32	JPY		  1			7000000		7000001			28000000
51	VND		  1			1500000		1500001			6000000
45	WON		 100		50,000,000	50,000,001		200000000
*/
ALTER PROCEDURE [dbo].[Acc_ExecRep_09]
    @ids varchar(max),
    @currency INT,
    @site varchar (20),
    @whatAreYouDoing varchar(100) = ''
AS
SET NOCOUNT ON

if @whatAreYouDoing <> 'Offer_W88_NG_setting' RETURN --:D

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Custinfo') RETURN

declare @string varchar(max), @splitter char(1), @xml XML
select @splitter = ',' ,@string = @ids

SET @XML = N'<root><r>' + REPLACE(@string, @splitter, '</r><r>') + '</r></root>'
declare @res AS TABLE(custid INT)
INSERT INTO @res(custid)
SELECT r.value('.','VARCHAR(12)')
FROM @xml.nodes('//root/r') AS RECORDS(r)
---------------------------------------------

DECLARE @minbet MONEY, @maxbet MONEY, @maxpermatch MONEY, @maxperball MONEY, @ptVALUE SMALLMONEY
SELECT  @ptVALUE = 0.85

SELECT @minbet = CASE
                WHEN @currency = 3 and @site = 'W88' THEN 1  --USD
                 WHEN @currency = 13 and @site = 'W88' THEN 1  --CNY
                 WHEN @currency = 4 and @site = 'W88' THEN 1  --THB
                 WHEN @currency = 12 and @site = 'W88' THEN 1  --GBP
                 WHEN @currency = 2 and @site = 'W88' THEN 1  --MYR
                 WHEN @currency = 9 and @site = 'W88' THEN 1  --AUD
                 WHEN @currency = 15 and @site = 'W88' THEN 1  --IDR
                 WHEN @currency = 6 and @site = 'W88' THEN 1  --EUR
                 WHEN @currency = 61 and @site = 'W88' THEN 1  --INR
                 WHEN @currency = 32 and @site = 'W88' THEN 1  --JPY
                 WHEN @currency = 51 and @site = 'W88' THEN 1  --INH  
                 WHEN @currency = 45 and @site = 'W88' THEN 100  --KRW
				 ELSE 0 END,
          
        @maxbet = CASE
               WHEN @currency = 3 and @site = 'W88' THEN 75000  --USD
                 WHEN @currency = 13 and @site = 'W88' THEN 500000  --CNY
                 WHEN @currency = 4 and @site = 'W88' THEN 2500000  --THB
                 WHEN @currency = 12 and @site = 'W88' THEN 10000 --GBP
                 WHEN @currency = 2 and @site = 'W88' THEN 250000  --MYR
                 WHEN @currency = 9 and @site = 'W88' THEN 75000 --AUD
                 WHEN @currency = 15 and @site = 'W88' THEN 750000 --IDR
                 WHEN @currency = 6 and @site = 'W88' THEN 10000  --EUR
                 WHEN @currency = 61 and @site = 'W88' THEN 4000000  --INR
                 WHEN @currency = 32 and @site = 'W88' THEN 7000000   --JPY
                 WHEN @currency = 51 and @site = 'W88' THEN 1500000  --INH  
                 WHEN @currency = 45 and @site = 'W88' THEN 50000000 --KRW
				 ELSE 0 END,
		@maxperball = CASE
                 WHEN @currency = 3 and @site = 'W88' THEN 75001 --USD
                 WHEN @currency = 13 and @site = 'W88' THEN 500001 --CNY
                 WHEN @currency = 4 and @site = 'W88' THEN 2500001 --THB
                 WHEN @currency = 12 and @site = 'W88' THEN 10001 --GBP
                 WHEN @currency = 2 and @site = 'W88' THEN 250001 --MYR
                 WHEN @currency = 9 and @site = 'W88' THEN 75001 --AUD
                 WHEN @currency = 15 and @site = 'W88' THEN 750001 --IDR
                 WHEN @currency = 6 and @site = 'W88' THEN 10001 --EUR
                 WHEN @currency = 61 and @site = 'W88' THEN 4000001 --INR
                 WHEN @currency = 32 and @site = 'W88' THEN 7000001 --JPY
                 WHEN @currency = 51 and @site = 'W88' THEN 1500001 --INH  
                 WHEN @currency = 45 and @site = 'W88' THEN 50000001 --KRW
				 ELSE 0 END,
         @maxpermatch = CASE
                WHEN @currency = 3 and @site = 'W88' THEN 500000 --USD
                 WHEN @currency = 13 and @site = 'W88' THEN 2000000 --CNY
                 WHEN @currency = 4 and @site = 'W88' THEN 10000000 --THB
                 WHEN @currency = 12 and @site = 'W88' THEN 100000 --GBP
                 WHEN @currency = 2 and @site = 'W88' THEN 1000000 --MYR
                 WHEN @currency = 9 and @site = 'W88' THEN 500000 --AUD
                 WHEN @currency = 15 and @site = 'W88' THEN 3000000 --IDR
                 WHEN @currency = 6 and @site = 'W88' THEN 100000 --EUR
                 WHEN @currency = 61 and @site = 'W88' THEN 16000000 --INR
                 WHEN @currency = 32 and @site = 'W88' THEN 28000000 --JPY
                 WHEN @currency = 51 and @site = 'W88' THEN 6000000  --INH  
                 WHEN @currency = 45 and @site = 'W88' THEN 200000000 --KRW
                 ELSE 0 END



UPDATE Custinfo WITH(rowlock, updlock)
SET maxperball161 = @maxperball,
	maxpermatch161 = @maxpermatch,
	disablenumber = 0
WHERE custid in (select custid from @res)
	

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Dep_CustSetting3rd') RETURN
UPDATE Dep_CustSetting3rd WITH(rowlock, updlock)
SET minbet = @minbet, 
	maxbet = @maxbet,
	apositiontaking = @ptVALUE
WHERE custid in (select custid from @res)
    and sporttype = 161

GO
----------------------------
----------------------------

CREATE TABLE #list (custid INT PRIMARY KEY, isfinished bit)

declare @site varchar(20), @currency int

select @site='W88',
 @currency=3 --USD
-- @currency=13 --RMB
-- @currency=4 --THB
-- @currency=12 --GBP
-- @currency=2 --MYR
-- @currency=9 --AUD
-- @currency=15 --IDR
-- @currency=6 --EUR
-- @currency=61 --INR
-- @currency=32 --JPY
-- @currency=51 --INH
-- @currency=45 --KRW

INSERT INTO #list (custid, isfinished)
SELECT custid, 0
FROM customer WITH(NOLOCK)
WHERE roleid = 1
	and srecommend in (
		select custid 
		from dep_custsuper with(nolock)
		where site=@site AND currency=@currency 			
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

	EXEC [Acc_ExecRep_09] @ids = @ids, @currency = @currency, @site = @site, @whatAreYouDoing = 'Offer_W88_NG_setting' 
	
	if @rowcnt < 1000 BREAK

	WAITFOR DELAY '00:00:01'
end	

DROP TABLE #list
