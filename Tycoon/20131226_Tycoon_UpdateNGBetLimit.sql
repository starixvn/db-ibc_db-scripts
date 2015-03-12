/* Tycoon - Adjust bet settings for Number Game (MYR, THB, RMB, IDR,INR)
https://redmine.nexcel.vn/issues/10130

ID	Currency  Min bet	Max bet		Max per ball	Max per match
2	MYR		　1		    500			15,000			25,000
4	THB		　10			50,000		150,000			250,000
13	RMB		　1			10,000		30,000			50,000
15	IDR		　1			15,000		43,000			72,000
61	INR		  10		33,000		80,000			400,000

*/

ALTER PROCEDURE [dbo].[Acc_execrep_cust_09]
    @ids varchar(max),
    @currency INT,
    @site varchar (20)
AS
SET NOCOUNT ON

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Custinfo') RETURN

declare @string varchar(max), @splitter char(1), @xml XML
select @splitter = ',' ,@string = @ids

SET @XML = N'<root><r>' + REPLACE(@string, @splitter, '</r><r>') + '</r></root>'
declare @res AS TABLE(custid INT)
INSERT INTO @res(custid)
SELECT r.value('.','VARCHAR(12)')
FROM @xml.nodes('//root/r') AS RECORDS(r)
---------------------------------------------

DECLARE @minbet MONEY, @maxbet MONEY, @maxpermatch MONEY, @maxperball MONEY

SELECT  @minbet = CASE
                 WHEN @currency = 2 and @site = 'Tycoon' THEN 1  --MYR
                 WHEN @currency = 4 and @site = 'Tycoon' THEN 10  --THB
				 WHEN @currency = 13 and @site = 'Tycoon' THEN 1  --CNY
				 WHEN @currency = 15 and @site = 'Tycoon' THEN 1  --IDR
                 WHEN @currency = 61 and @site = 'Tycoon' THEN 10  --INR
			     ELSE 0 END,
          
        @maxbet = CASE
                 WHEN @currency = 2 and @site = 'Tycoon' THEN 500  --MYR
                 WHEN @currency = 4 and @site = 'Tycoon' THEN 50000 --THB
				 WHEN @currency = 13 and @site = 'Tycoon' THEN 10000  --CNY
				 WHEN @currency = 15 and @site = 'Tycoon' THEN 15000  --IDR
                 WHEN @currency = 61 and @site = 'Tycoon' THEN 33000  --INR
			ELSE 0 END,

		@maxperball = CASE
                 WHEN @currency = 2 and @site = 'Tycoon' THEN 15000  --MYR
                 WHEN @currency = 4 and @site = 'Tycoon' THEN 150000  --THB
				 WHEN @currency = 13 and @site = 'Tycoon' THEN 30000  --CNY
				 WHEN @currency = 15 and @site = 'Tycoon' THEN 43000  --IDR
                 WHEN @currency = 61 and @site = 'Tycoon' THEN 80000  --INR
			ELSE 0 END,
				 
         @maxpermatch = CASE
                 WHEN @currency = 2 and @site = 'Tycoon' THEN 25000  --MYR
                 WHEN @currency = 4 and @site = 'Tycoon' THEN 250000  --THB
				 WHEN @currency = 13 and @site = 'Tycoon' THEN 50000  --CNY
				 WHEN @currency = 15 and @site = 'Tycoon' THEN 72000  --IDR
                 WHEN @currency = 61 and @site = 'Tycoon' THEN 400000  --INR
			ELSE 0 END

IF (@minbet = 0) RETURN
		
UPDATE Custinfo WITH (ROWLOCK, UPDLOCK)
SET		
	MaxPerBall161 = @maxperball	, 
	Maxpermatch161 = @maxpermatch	
WHERE custid in (select custid from @res)

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Dep_CustSetting3rd') RETURN

UPDATE  Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET		maxbet = @maxbet,
		minbet = @minbet
WHERE sporttype=161 and custid in (select custid from @res)

GO


----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- Script to execute [Acc_execrep_cust_09]

CREATE TABLE #list (custid INT PRIMARY KEY, isfinished bit)

declare @site varchar(20), @currency int 
   
Select @site = 'Tycoon'
, @currency=2
--, @currency=4
--, @currency=13
--, @currency=15
--, @currency=61


INSERT INTO #list (custid, isfinished)
SELECT custid, 0
FROM customer WITH(NOLOCK)
WHERE roleid in (1,2,3,4)
	and srecommend in (
		select custid 
		from dep_custsuper with(nolock)
		where currency = @currency
			and site=@site	
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

	EXEC [Acc_execrep_cust_09] @ids = @ids, @currency = @currency, @site = @site	
	
	if @rowcnt < 1000 Break

	WAITFOR DELAY '00:00:01'
end	

DROP TABLE #list

