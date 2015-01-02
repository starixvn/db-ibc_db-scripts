/*
 Offer Racing for VWIN
 https://redmine.nexcel.vn/issues/9634

*/
 
 ALTER PROCEDURE [dbo].[Acc_ExecRep_09]
    @ids varchar(max),
    @currency INT,
    @site varchar (20),
    @whatAreYouDoing varchar(100) = ''
AS
SET NOCOUNT ON

if @whatAreYouDoing <> 'Offer_VWIN_Racing_setting' RETURN --:D

IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Custinfo') RETURN

declare @string varchar(max), @splitter char(1), @xml XML
select @splitter = ',' ,@string = @ids

SET @XML = N'<root><r>' + REPLACE(@string, @splitter, '</r><r>') + '</r></root>'
declare @res AS TABLE(custid INT)
INSERT INTO @res(custid)
SELECT r.value('.','VARCHAR(12)')
FROM @xml.nodes('//root/r') AS RECORDS(r)
---------------------------------------------

DECLARE @minbet MONEY, @maxbet151 MONEY, @maxbet152_153 MONEY, @maxbet152_UK MONEY, @maxpermatch MONEY , @maxpermatch_SA MONEY, @maxpermatch_AU MONEY
DECLARE @Comm decimal (9,8), @AustComm decimal (9,8)

SELECT @Comm = 0.04, @AustComm = 0.03

SELECT  @minbet = CASE
                WHEN @currency = 2  and @site = 'VWIN' THEN 30  --RM/MYR
				WHEN @currency = 3  and @site = 'VWIN' THEN 10  --USD
				WHEN @currency = 4  and @site = 'VWIN' THEN 300  --TB/THB
				WHEN @currency = 13 and @site = 'VWIN' THEN 50  --RMB/CNY
				WHEN @currency = 15 and @site = 'VWIN' THEN 100 --IN
				WHEN @currency = 20 and @site = 'VWIN' THEN 50  --UUS
				WHEN @currency = 51 and @site = 'VWIN' THEN 200  --INH
				ELSE 0 END,

		@maxbet151 = CASE
				WHEN @currency = 2  and @site = 'VWIN' THEN 4000  --RM/MYR
				WHEN @currency = 3  and @site = 'VWIN' THEN 1200  --USD
				WHEN @currency = 4  and @site = 'VWIN' THEN 40000  --TB/THB
				WHEN @currency = 13 and @site = 'VWIN' THEN 7000  --RMB/CNY
				WHEN @currency = 15 and @site = 'VWIN' THEN 6000 --IN
				WHEN @currency = 20 and @site = 'VWIN' THEN 7000  --UUS
				WHEN @currency = 51 and @site = 'VWIN' THEN 12000  --INH
				ELSE 0 END,

		@maxbet152_153 = CASE
				WHEN @currency = 2  and @site = 'VWIN' THEN 40000  --RM/MYR
				WHEN @currency = 3  and @site = 'VWIN' THEN 15000  --USD
				WHEN @currency = 4  and @site = 'VWIN' THEN 400000  --TB/THB
				WHEN @currency = 13 and @site = 'VWIN' THEN 80000  --RMB/CNY
				WHEN @currency = 15 and @site = 'VWIN' THEN 20000 --IN
				WHEN @currency = 20 and @site = 'VWIN' THEN 80000  --UUS
				WHEN @currency = 51 and @site = 'VWIN' THEN 40000  --INH
				ELSE 0 END,
              
	    @maxbet152_UK = CASE
				WHEN @currency = 15 and @site = 'VWIN' THEN 4999 --IN
				WHEN @currency = 51 and @site = 'VWIN' THEN 9999  --INH
				ELSE @maxbet152_153 END,
				
				 
        @maxpermatch =  CASE
				WHEN @currency = 2  and @site = 'VWIN' THEN 80000  --RM/MYR
				WHEN @currency = 3  and @site = 'VWIN' THEN 30000  --USD
				WHEN @currency = 4  and @site = 'VWIN' THEN 800000  --TB/THB
				WHEN @currency = 13 and @site = 'VWIN' THEN 160000  --RMB/CNY
				WHEN @currency = 15 and @site = 'VWIN' THEN 49999 --IN
				WHEN @currency = 20 and @site = 'VWIN' THEN 160000  --UUS
				WHEN @currency = 51 and @site = 'VWIN' THEN 99999  --INH
				ELSE 0 END,

		 
        @maxpermatch_SA =  CASE
				WHEN @currency = 15 and @site = 'VWIN' THEN 10000 --IN
				WHEN @currency = 51 and @site = 'VWIN' THEN 20000  --INH
				ELSE @maxpermatch END,

		@maxpermatch_AU =  CASE
				WHEN @currency = 15 and @site = 'VWIN' THEN 40000 --IN
				WHEN @currency = 51 and @site = 'VWIN' THEN 80000  --INH
				ELSE @maxpermatch END
				

IF (@minbet = 0) RETURN
	
UPDATE Custinfo WITH (ROWLOCK, UPDLOCK)
SET maxpermatch151 = @maxpermatch_SA,
	maxpermatch151_OT = @maxpermatch,
	maxPerMatch151_AU = @maxpermatch_AU,
	maxPerMatch152_UK = @maxpermatch,
	maxPerMatch152_AU = @maxpermatch_AU,
	maxPerMatch153_AU = @maxpermatch_AU,
	DisableHorseRacing = 0,
	DisableOpenTote = 0,
	Disable151_AU = 0,
	Disable152_AU = 0,
	Disable152_UK = 0,
	Disable153_AU = 0
WHERE custid IN (SELECT * FROM @res)


IF NOT exists (SELECT TOP 1 1 FROM dbo.sysobjects WHERE name = 'Dep_CustSetting3rd') RETURN

UPDATE cs3 WITH(ROWLOCK,UPDLOCK)	
SET sdiscount = CASE WHEN roleid IN (1,4) THEN CASE WHEN bettype IN (41,42,31,32) THEN @Comm
													WHEN bettype IN (51,52) THEN @AustComm
													ELSE 0
											   END
				     ELSE 0 
				END,
	adiscount = CASE WHEN roleid IN (1,3) THEN CASE WHEN bettype IN (41,42,31,32) THEN @Comm
													WHEN bettype IN (51,52) THEN @AustComm
													ELSE 0
											   END
				    ELSE 0 
				END,
	discount  = CASE WHEN roleid IN (1,2) THEN CASE WHEN bettype IN (41,42,31,32) THEN @Comm
													WHEN bettype IN (51,52) THEN @AustComm
													ELSE 0
											   END
					ELSE 0 
				END,
	playerdiscount = 0,
	
	maxbet = CASE 
				WHEN sporttype = 151 THEN @maxbet151
				WHEN sporttype = 152 and bettype in (41,42) THEN @maxbet152_UK
				ELSE @maxbet152_153 End , 
	minbet = @minbet,
	
	apositiontaking = 0,
	mpositiontaking = 0,
	spositiontaking = 0	
	FROM Custinfo c WITH(NOLOCK)
		INNER JOIN Dep_CustSetting3rd cs3 ON c.custid = cs3.custid
	WHERE sporttype IN (151,152,153)
		AND bettype IN (31,32,41,42,51,52)
		AND cs3.custid IN (select custid from @res)

GO
----------------------------
----------------------------

CREATE TABLE #list (custid INT PRIMARY KEY, isfinished bit)

declare @site varchar(20), @currency int

/*
srecommend currency username
custid		currency	username
4854900		20			VwinSuperUUS
7596783		3			VwinSuperUS$
10380749	13			VWINSuperRMB
11387211	2			VWinSuperRM
11387220	4			VWinSuperTB
11387229	15			VWinSuperIN
11387238	51			VWinSuperINH

*/   
   

select @site='VWIN', @currency=4

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

	EXEC [Acc_ExecRep_09] @ids = @ids, @currency = @currency, @site = @site, @whatAreYouDoing = 'Offer_VWIN_Racing_setting'
	
	if @rowcnt < 1000 Break

	WAITFOR DELAY '00:00:01'
end	

DROP TABLE #list