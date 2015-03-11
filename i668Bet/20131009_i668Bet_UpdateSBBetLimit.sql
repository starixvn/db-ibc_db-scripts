/*
TaskID: 6510
Update SB maxbet, max per match of Super/Master/Agent and 3 specific members
(max bet and max per match of existing members are not updated)
custid	roleid	username
10487492	4	i668betSuperUS$
10487493	3	i668betUS$
10487494	2	i668betUS$01
10942310	2	i668betUS$02  
12584040	1	i668betUS$011136
12584045	1	i668betUS$011137
12584049	1	i668betUS$011138
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
DECLARE @minbet MONEY
DECLARE @maxbet MONEY, @maxpermatch MONEY


SELECT  @maxbet = CASE WHEN @currency = 3 and @site = 'i668bet' THEN 5000  --USD 
					   ELSE 0  END,
		@maxpermatch = CASE WHEN @currency = 3 and @site = 'i668bet' THEN 10000  --USD 
					   ELSE 0 END
       

IF (@maxbet = 0) RETURN
		
UPDATE Custinfo WITH (ROWLOCK, UPDLOCK)
SET		maxpermatch = @maxpermatch,
		maxpermatch2 = @maxpermatch,
		maxpermatch3 = @maxpermatch,
		maxpermatch5 = @maxpermatch,
		maxpermatch8 = @maxpermatch,
		maxpermatch10 = @maxpermatch,
		maxpermatch11 = @maxpermatch,
		maxpermatch99 = @maxpermatch,
		maxpermatch99MP = @maxpermatch
WHERE custid in (select custid from @res)

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Dep_CustSetting') RETURN

UPDATE  Dep_CustSetting WITH (ROWLOCK, UPDLOCK)
SET		maxbet = @maxbet
WHERE custid in (select custid from @res)
	
GO
----------------------------
----------------------------

CREATE TABLE #list (custid INT PRIMARY KEY, isfinished bit)

declare @site varchar(20), @currency int
--select @site / @currency
/*
custid	roleid	username
10487492	4	i668betSuperUS$
10487493	3	i668betUS$
10487494	2	i668betUS$01
10942310	2	i668betUS$02  
12584040	1	i668betUS$011136
12584045	1	i668betUS$011137
12584049	1	i668betUS$011138

*/   
   
select @site='i668bet', @currency=3

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
AND custid in (10487492,10487493,10487494,10942310,12584040,12584045,12584049)

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
	
	if @rowcnt < 1000 RETURN

	WAITFOR DELAY '00:00:01'
end	

DROP TABLE #list



