/*
 Update NG for 12bet USD to upline with bet limit as below:
 https://redmine.nexcel.vn/issues/9209 

CurrencyID	Currency  Max bet		Max per ball	Max per match
3			USD		　3000			10000			15000

*/

ALTER PROCEDURE [dbo].[Acc_ExecRep_09]
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

DECLARE @maxbet MONEY, @maxpermatch MONEY, @maxperball MONEY, @ptVALUE SMALLMONEY
SELECT  @maxbet = CASE WHEN @currency = 3 and @site = '12bet' THEN 3000  --USD
					   ELSE 0 END,
		@maxperball = CASE WHEN @currency = 3 and @site = '12bet' THEN 10000  --USD
						   ELSE 0 END,
        @maxpermatch =CASE WHEN @currency = 3 and @site = '12bet' THEN 15000  --USD
						   ELSE 0 END

IF (@maxbet = 0) RETURN
	

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Custinfo') RETURN
 
UPDATE Custinfo WITH(rowlock, updlock)
SET		maxperball161 = @maxperball,
		maxpermatch161 = @maxpermatch		
WHERE custid in (select custid from @res)

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Dep_CustSetting3rd') RETURN

UPDATE  Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET		maxbet = @maxbet
WHERE custid in (select custid from @res) and sporttype = 161


GO


----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- Script to execute [Acc_ExecRep_09]

CREATE TABLE #list (custid INT PRIMARY KEY, isfinished bit)

declare @site varchar(20), @currency int

/*
roleid	currency	custid		username
4		3			791080		12BETSuperUS$
3		3			791082		12BETUS$
2		3			791083		12BETUS$01
2		3			860376		12BETUS$02
2		3			2812695		12BETUS$03
2		3			3577591		12BETUS$04
2		3			10393717	12betUS$KR
2		3			10842822	12BETUS$KR05
*/   
   
select @site='12bet', @currency=3


INSERT INTO #list (custid, isfinished)
SELECT custid, 0
FROM customer WITH(NOLOCK)
WHERE roleid in (2,3,4)
	and srecommend in (
		select custid 
		from dep_custsuper with(nolock)
		where currency = @currency
			and site=@site	
	)
	and custid in (791080,791082,791083,860376,2812695,3577591,10393717,10842822)

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

	EXEC [Acc_ExecRep_09] @ids = @ids, @currency = @currency, @site = @site	
	
	if @rowcnt < 1000 Break

	WAITFOR DELAY '00:00:01'
end	

DROP TABLE #list
