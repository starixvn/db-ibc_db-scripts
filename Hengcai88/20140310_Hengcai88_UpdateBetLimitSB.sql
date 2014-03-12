/* Hengcai88 (RMB) - Adjust min bet settings for SB
https://redmine.nexcel.vn/issues/13105

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

DECLARE @minbet MONEY


-- SB bet limit
SELECT  @minbet = CASE WHEN @currency = 13 and @site = 'Hengcai88' THEN 20  --RMB
			      ELSE 0 END
          
    

IF (@minbet = 0) RETURN

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Dep_CustSetting') RETURN



UPDATE  Dep_CustSetting WITH (ROWLOCK, UPDLOCK)
SET		minbet = @minbet
WHERE custid in (select custid from @res) 

GO


----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- Script to execute [Acc_execrep_cust_09]

CREATE TABLE #list (custid INT PRIMARY KEY, isfinished bit)

declare @site varchar(20), @currency int 
   
Select @site = 'Hengcai88'
, @currency=13



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


