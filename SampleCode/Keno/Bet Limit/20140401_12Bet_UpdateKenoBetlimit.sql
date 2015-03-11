/*
	Created: Jerry 
	Date: 2014-04-01
	DB: DBTXN/CustDB
	Task: Adjust Keno Bet limit for 12bet
*/ 

ALTER PROCEDURE [dbo].[Acc_CustSetting_03]
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

DECLARE @minbet MONEY, @maxbet MONEY, @maxperGameType MONEY

-- NG bet limit 		
SELECT	@minbet =  CASE WHEN @currency = 1 and @site = '12Bet' THEN 1  --SD
						WHEN @currency = 2 and @site = '12Bet' THEN 1  --RM
						WHEN @currency = 3 and @site = '12Bet' THEN 1  --US$
						WHEN @currency = 4 and @site = '12Bet' THEN 10  --TB
						WHEN @currency = 6 and @site = '12Bet' THEN 1  --EURO
						WHEN @currency = 9 and @site = '12Bet' THEN 1  --AUD
						WHEN @currency = 12 and @site = '12Bet' THEN 1  --GBP
						WHEN @currency = 13 and @site = '12Bet' THEN 1  --RMB
						WHEN @currency = 15 and @site = '12Bet' THEN 1  --IN
						WHEN @currency = 20 and @site = '12Bet' THEN 1  --UUS
						WHEN @currency = 32 and @site = '12Bet' THEN 10  --JPY
						WHEN @currency = 41 and @site = '12Bet' THEN 1  --CHF
						WHEN @currency = 45 and @site = '12Bet' THEN 1000  --WON
						WHEN @currency = 51 and @site = '12Bet' THEN 1  --INH
						WHEN @currency = 61 and @site = '12Bet' THEN 10  --INR
			       ELSE 0 END,
		
		@maxbet =  CASE WHEN @currency = 1 and @site = '12Bet' THEN 800  --SD
						WHEN @currency = 2 and @site = '12Bet' THEN 5000  --RM
						WHEN @currency = 3 and @site = '12Bet' THEN 3000  --US$
						WHEN @currency = 4 and @site = '12Bet' THEN 50000  --TB
						WHEN @currency = 6 and @site = '12Bet' THEN 100  --EURO
						WHEN @currency = 9 and @site = '12Bet' THEN 150  --AUD
						WHEN @currency = 12 and @site = '12Bet' THEN 100  --GBP
						WHEN @currency = 13 and @site = '12Bet' THEN 10000  --RMB
						WHEN @currency = 15 and @site = '12Bet' THEN 15000  --IN
						WHEN @currency = 20 and @site = '12Bet' THEN 1000  --UUS
						WHEN @currency = 32 and @site = '12Bet' THEN 50000  --JPY
						WHEN @currency = 41 and @site = '12Bet' THEN 150  --CHF
						WHEN @currency = 45 and @site = '12Bet' THEN 750000  --WON
						WHEN @currency = 51 and @site = '12Bet' THEN 33000  --INH
						WHEN @currency = 61 and @site = '12Bet' THEN 33000  --INR
			       ELSE 0 END,
		
		@maxperGameType =  CASE WHEN @currency = 1 and @site = '12Bet' THEN 1000000  --SD
						WHEN @currency = 2 and @site = '12Bet' THEN 25000  --RM
						WHEN @currency = 3 and @site = '12Bet' THEN 15000  --US$
						WHEN @currency = 4 and @site = '12Bet' THEN 250000  --TB
						WHEN @currency = 6 and @site = '12Bet' THEN 5000  --EURO
						WHEN @currency = 9 and @site = '12Bet' THEN 8500  --AUD
						WHEN @currency = 12 and @site = '12Bet' THEN 5000  --GBP
						WHEN @currency = 13 and @site = '12Bet' THEN 50000  --RMB
						WHEN @currency = 15 and @site = '12Bet' THEN 72000  --IN
						WHEN @currency = 20 and @site = '12Bet' THEN 2000  --UUS
						WHEN @currency = 32 and @site = '12Bet' THEN 650000  --JPY
						WHEN @currency = 41 and @site = '12Bet' THEN 7500  --CHF
						WHEN @currency = 45 and @site = '12Bet' THEN 8000000  --WON
						WHEN @currency = 51 and @site = '12Bet' THEN 160000  --INH
						WHEN @currency = 61 and @site = '12Bet' THEN 400000  --INR
			       ELSE 0 END


IF (@minbet = 0) RETURN

IF NOT EXISTS ( SELECT * FROM sys.objects WHERE NAME = 'CustGameType' AND type = 'U' ) 	RETURN

UPDATE custGameType WITH(UPDLOCK,ROWLOCK)
SET    minbet = @minbet,
	   maxbet = @maxbet,
	   MaxPerGameType = @maxperGameType
WHERE custid IN (SELECT custid FROM @res)

GO
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- Script to execute [Acc_CustSetting_03]


CREATE TABLE #list (custid INT PRIMARY KEY, isfinished bit)

declare @site varchar(20), @currency int 
   
Select @site = '12bet'
, @currency=1

-- @currency=2
-- @currency=3
-- @currency=4
-- @currency=6
-- @currency=9
-- @currency=12
-- @currency=13
-- @currency=15
-- @currency=20
-- @currency=32
-- @currency=41
-- @currency=45
-- @currency=51
-- @currency=61



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

	EXEC [Acc_CustSetting_03] @ids = @ids, @currency = @currency, @site = @site	
	
	if @rowcnt < 1000 Break

	WAITFOR DELAY '00:00:01'
end	

DROP TABLE #list


