/* TLC - Adjust Basketball bet limit for RMB currency (https://redmine.nexcel.vn/issues/9582)
		Max bet: 20,000
		Max per match:  40,000
	
	Note: apply for members and their uplines
	
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

DECLARE @maxbet MONEY, @maxpermatch MONEY

SELECT  
		@maxbet = CASE WHEN @currency = 13 and @site = 'TLC' THEN 20000  --RMB
				  ELSE 0  END,			  
		@maxpermatch = CASE WHEN @currency = 13 and @site = 'TLC' THEN 40000  --RMB
				       ELSE 0  END

IF (@maxbet = 0) RETURN
		
UPDATE Custinfo WITH (ROWLOCK, UPDLOCK)
SET		
		maxpermatch2 = @maxpermatch	
WHERE custid in (select custid from @res)

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Dep_CustSetting') RETURN

UPDATE  Dep_CustSetting WITH (ROWLOCK, UPDLOCK)
SET		maxbet = @maxbet
WHERE sporttype=2 and custid in (select custid from @res)

GO


----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- Script to execute [Acc_ExecRep_09]

CREATE TABLE #list (custid INT PRIMARY KEY, isfinished bit)

declare @site varchar(20), @currency int 
   
select @site='TLC', @currency=13


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

	EXEC [Acc_ExecRep_09] @ids = @ids, @currency = @currency, @site = @site	
	
	if @rowcnt < 1000 BREAK

	WAITFOR DELAY '00:00:01'
end	

DROP TABLE #list



