/* Mayfair (RMB) - Adjust bet settings for SB, NG, VS and Racing 
https://redmine.nexcel.vn/issues/12158

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

DECLARE @minbet MONEY, @maxbet MONEY, @maxpermatch MONEY
DECLARE @minbet161 MONEY, @maxbet161 MONEY, @maxpermatch161 MONEY, @maxperball161 MONEY
DECLARE @minbetSA MONEY, @maxbetSA MONEY, @maxpermatchHR MONEY
DECLARE @minbetUK MONEY, @maxbetUK MONEY
DECLARE @minbetAust MONEY, @maxbetAust MONEY

-- SB,VS bet limit
SELECT  @minbet = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 10  --RMB
			      ELSE 0 END,
          
        @maxbet = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 500000  --RMB
			      ELSE 0 END,

		@maxpermatch = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 1500000  --RMB
					    ELSE 0 END
-- NG bet limit 		
SELECT	@minbet161 = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 10  --RMB
			         ELSE 0 END,
          
        @maxbet161 = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 50000  --RMB
			         ELSE 0 END,

		@maxpermatch161 = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 500000  --RMB
					      ELSE 0 END,

		@maxperball161 = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 50000  --RMB
					      ELSE 0 END

-- Racing bet limit
SELECT	@minbetSA = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 20  --RMB
					      ELSE 0 END,
				
		@minbetUK = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 50  --RMB
					      ELSE 0 END,
						  
		@minbetAust = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 30  --RMB
					      ELSE 0 END,
						   
        @maxbetSA = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 80000  --RMB
					      ELSE 0 END,
				
		@maxbetUK = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 7000  --RMB
					      ELSE 0 END,
						  
		@maxbetAust = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 32000  --RMB
					      ELSE 0 END,  

        @maxpermatchHR = CASE WHEN @currency = 13 and @site = 'Mayfair' THEN 160000  --RMB
				      ELSE 0 END


IF (@minbet = 0) RETURN
		
UPDATE Custinfo WITH (ROWLOCK, UPDLOCK)
SET		
	    maxpermatch = @maxpermatch,
		maxpermatch2 = @maxpermatch,
		maxpermatch3 = @maxpermatch,
		maxpermatch5 = @maxpermatch,
		maxpermatch8 = @maxpermatch,
		maxpermatch10 = @maxpermatch,
		maxpermatch11 = @maxpermatch,
		maxpermatch99 = @maxpermatch,
		MaxPerMatch99MP = @maxpermatch,

		maxperball161 = @maxperball161,
		maxpermatch161 = @maxpermatch161,
		
		maxpermatch180 = @maxpermatch,
		maxpermatch181 = @maxpermatch,
		maxpermatch182 = @maxpermatch,
		maxpermatch183 = @maxpermatch,
		maxpermatch184 = @maxpermatch,
		maxpermatch185 = @maxpermatch,
		maxpermatch186 = @maxpermatch,

		maxpermatch151 = @maxpermatchHR,
		MaxPerMatch151_AU = @maxpermatchHR,
		maxpermatch151_OT = @maxpermatchHR,
		MaxPerMatch152_UK = @maxpermatchHR,
		MaxPerMatch152_AU = @maxpermatchHR,
		MaxPerMatch153_AU = @maxpermatchHR

WHERE custid in (select custid from @res)

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Dep_CustSetting') RETURN
IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Dep_CustSetting3rd') RETURN


UPDATE  Dep_CustSetting WITH (ROWLOCK, UPDLOCK)
SET		maxbet = @maxbet,
		minbet = @minbet
WHERE custid in (select custid from @res) 


UPDATE  Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
SET		maxbet = case when sporttype = 161  then @maxbet161
					  when sporttype in (180,181,182,183,184,185,186) then @maxbet
					  when sporttype = 151 and bettype in (31,32) then @maxbetSA
					  when sporttype in (151,152) and bettype in (41,42) then @maxbetUK
					  else @maxbetAust end	,
		minbet = case when sporttype = 161  then @minbet161
					  when sporttype in (180,181,182,183,184,185,186) then @minbet
					  when sporttype = 151 and bettype in (31,32) then @minbetSA
					  when sporttype in (151,152) and bettype in (41,42) then @minbetUK
					  else @minbetAust end
WHERE custid in (select custid from @res) 
and sporttype in (151,152,153,161,180,181,182,183,184,185,186)

GO


----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- Script to execute [Acc_execrep_cust_09]

CREATE TABLE #list (custid INT PRIMARY KEY, isfinished bit)

declare @site varchar(20), @currency int 
   
Select @site = 'Mayfair'
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

