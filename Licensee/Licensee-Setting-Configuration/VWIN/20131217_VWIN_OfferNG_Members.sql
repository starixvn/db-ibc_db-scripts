/*
 Offer NG for VWIN to member with bet limit as below: 
 https://redmine.nexcel.vn/issues/9634

ID	Currency	minbet	maxbet	maxpermatch		max per ball
2	MYR			1		5000	25000			15000
3	USD			1		150		8000			500
4	THB			10		50000	250000			150000
13	RMB			1		10000	50000			30000
15	IDR			5		15000	72000			43000
20	UUS			1		10000	50000			30000
51	VND			10		33000	160000			100000



*/
ALTER PROCEDURE [dbo].[Acc_ExecRep_09]
    @ids varchar(max),
    @currency INT,
    @site varchar (20),
    @whatAreYouDoing varchar(100) = ''
AS
SET NOCOUNT ON

if @whatAreYouDoing <> 'Offer_VWIN_NG_setting' RETURN --:D

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

SELECT  @minbet = CASE
               WHEN @currency = 2  and @site = 'VWIN' THEN 1  --RM/MYR
			   WHEN @currency = 3  and @site = 'VWIN' THEN 1  --USD
			   WHEN @currency = 4  and @site = 'VWIN' THEN 10  --TB/THB
			   WHEN @currency = 13 and @site = 'VWIN' THEN 1  --RMB/CNY
			   WHEN @currency = 15 and @site = 'VWIN' THEN 5 --IN
			   WHEN @currency = 20 and @site = 'VWIN' THEN 1  --UUS
			   WHEN @currency = 51 and @site = 'VWIN' THEN 10  --INH
			   ELSE 0 END,
          
        @maxbet = CASE
               WHEN @currency = 2  and @site = 'VWIN' THEN 5000  --RM/MYR
			   WHEN @currency = 3  and @site = 'VWIN' THEN 150  --USD
			   WHEN @currency = 4  and @site = 'VWIN' THEN 50000  --TB/THB
			   WHEN @currency = 13 and @site = 'VWIN' THEN 10000  --RMB/CNY
			   WHEN @currency = 15 and @site = 'VWIN' THEN 15000 --IN
			   WHEN @currency = 20 and @site = 'VWIN' THEN 10000  --UUS
			   WHEN @currency = 51 and @site = 'VWIN' THEN 33000  --INH
			   ELSE 0 END,

		@maxperball = CASE
               WHEN @currency = 2  and @site = 'VWIN' THEN 15000  --RM/MYR
			   WHEN @currency = 3  and @site = 'VWIN' THEN 500  --USD
			   WHEN @currency = 4  and @site = 'VWIN' THEN 150000  --TB/THB
			   WHEN @currency = 13 and @site = 'VWIN' THEN 30000  --RMB/CNY
			   WHEN @currency = 15 and @site = 'VWIN' THEN 43000 --IN
			   WHEN @currency = 20 and @site = 'VWIN' THEN 30000  --UUS
			   WHEN @currency = 51 and @site = 'VWIN' THEN 100000  --INH
			   ELSE 0 END,
				 
         @maxpermatch = CASE
               WHEN @currency = 2  and @site = 'VWIN' THEN 25000  --RM/MYR
			   WHEN @currency = 3  and @site = 'VWIN' THEN 8000  --USD
			   WHEN @currency = 4  and @site = 'VWIN' THEN 250000  --TB/THB
			   WHEN @currency = 13 and @site = 'VWIN' THEN 50000  --RMB/CNY
			   WHEN @currency = 15 and @site = 'VWIN' THEN 72000 --IN
			   WHEN @currency = 20 and @site = 'VWIN' THEN 50000  --UUS
			   WHEN @currency = 51 and @site = 'VWIN' THEN 160000  --INH
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

select @site='VWIN',
 @currency=2 --MYR
-- @currency=3 --USD
 --@currency=4 --THB
-- @currency=13 --RMB
-- @currency=15 --IDR
-- @currency=20 --UUS
-- @currency=51 --INH


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

	EXEC [Acc_ExecRep_09] @ids = @ids, @currency = @currency, @site = @site, @whatAreYouDoing = 'Offer_VWIN_NG_setting' 
	
	if @rowcnt < 1000 BREAK

	WAITFOR DELAY '00:00:01'
end	

DROP TABLE #list
