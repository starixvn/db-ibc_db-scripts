/*  Enable Virtual Sports for Haifa 
	https://redmine.nexcel.vn/issues/15255
*/

ALTER PROCEDURE [dbo].[Acc_ExecRep_Cust_09]
    @ids varchar(max)
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

		
UPDATE Custinfo WITH (ROWLOCK, UPDLOCK)
SET		DisableVirtualSports = 0, 
		HideVirtualSports = 0
WHERE custid in (select custid from @res)

GO

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- Script to execute [Acc_ExecRep_Cust_09]

CREATE TABLE #list (custid INT PRIMARY KEY, isfinished bit)

declare @site varchar(20)
   
select @site='Haifa'


INSERT INTO #list (custid, isfinished)
SELECT custid, 0
FROM customer WITH(NOLOCK)
WHERE roleid in (1,2,3,4)
	and srecommend in (
		select custid 
		from dep_custsuper with(nolock)
		where site=@site and currency in  (4,13,45,51,3,32)
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

	EXEC [Acc_ExecRep_Cust_09] @ids = @ids
	
	if @rowcnt < 1000 Break

	WAITFOR DELAY '00:00:01'
end	

DROP TABLE #list



