/*
	date :2015-03-11
	Author: Susan
	Task: UPDATE s1 FROM 0.5 to 0.4 for member under super KY48
	step: 
	+ UPDATE m4,a4,s4 =0.4 for super
	+ UPDATE s3=0.4 for master, s1=0,4 for member

	DB: DBTXN/CustDB
 */
 

---UPDATE s4,m4,a4 for super  	KY48 (15334111)
---custSETting: non live: 41 rows
 UPDATE custSetting with(Rowlock, updlock)
 SET spositiontaking=0.4,
	 mpositiontaking=0.4,
	 apositiontaking=0.4
 WHERE custid=15334111  
 AND spositiontaking>0.4

-- custSetting: live: 4 rows
 UPDATE CustSetting with(Rowlock, updlock)
 SET slivepositiontaking=0.4,
	 mlivepositiontaking=0.4,
	 alivepositiontaking=0.4
 WHERE custid=15334111
 AND slivepositiontaking>0.4

-- CustSETting 3rd : non live: 11 row
 UPDATE custSetting3rd with(Rowlock, updlock)
 SET spositiontaking=0.4,
	 mpositiontaking=0.4,
	 apositiontaking=0.4
 WHERE custid=15334111
 AND spositiontaking>0.4
  and sporttype not in (151,152,153) --exclude racing

--CustSETting 3rd live: 5 row

 UPDATE custSetting3rd with(Rowlock, updlock)
 SET slivepositiontaking=0.4,
	 mlivepositiontaking=0.4,
	 alivepositiontaking=0.4
 WHERE custid=15334111
 AND slivepositiontaking>0.4
 and sporttype not in (151,152,153)  --exclude racing




-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------

ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	  @srecommend INT	
	 ,@maxcustid INT	
	 ,@target VARCHAR(20)
AS
BEGIN

SET NOCOUNT ON;
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only

IF (SELECT COUNT(1) FROM sys.objects WHERE name IN ('CustSetting3rd','custinfo','CustSetting') AND type = 'U') <>3
	RETURN

--UPDATE custSETting : nonlive 85813 rows
UPDATE newCS with(Rowlock, updlock)
SET newCS.spositiontaking=0.4
FROM custSETting newCS 
INNER JOIN custInfo c with(nolock) on c.custid=newCS.custid 
WHERE c.srecommend=@srecommend
AND c.roleid in (1,3)
AND newCS.spositiontaking>0.4

--UPDATE custSETing live : 8372 rows
UPDATE newCS with(Rowlock, updlock)
SET newCS.slivepositiontaking=0.4
FROM custSETting newCS 
INNER JOIN custInfo c with(nolock) on c.custid=newCS.custid 
WHERE c.srecommend=@srecommend
AND c.roleid in (1,3)
AND newCS.slivepositiontaking>0.4

---UPDATE custSETting3rd :23009 rows nonlive
UPDATE newCS with(Rowlock, updlock)
SET newCS.spositiontaking=0.4
FROM custSETting3rd newCS 
INNER JOIN custInfo c with(nolock) on c.custid=newCS.custid 
WHERE c.srecommend=@srecommend
AND c.roleid in (1,3)
AND newCS.spositiontaking>0.4 

---UPDATE custSETting3rd :10465 rows live
UPDATE newCS with(Rowlock, updlock)
SET newCS.slivepositiontaking=0.4
FROM CustSetting3rd newCS 
INNER JOIN custInfo c with(nolock) on c.custid=newCS.custid 
WHERE c.srecommend=@srecommend
AND c.roleid in (1,3)
AND newCS.slivepositiontaking>0.4


End
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------
------------------------------------------------------


-- BEGIN STEP 2: RUN THIS SCRIPT AT REPLICATED DB -----
-------------------------------------------------

DECLARE @srecommend int ,@maxcustid int

SELECT @srecommend=15334111 ---ky48
	  ,@maxcustid=xxx   --input maxcustid here
		
	EXEC dbo.Acc_CustSetting3rd_19 @srecommend = @srecommend, @maxcustid=@maxcustid,@target = 'REPLICATED'  	
	
GO

---- End of step 2

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS/CustDB -----
-------------------------------------------------

Declare @srecommend int ,@maxcustid int

select @srecommend=15334111 ---ky48
      ,@maxcustid=xxx   --input maxcustid here
			
	EXEC dbo.Acc_CustSetting3rd_19 @srecommend = @srecommend, @maxcustid=@maxcustid,@target = 'DBTRANS'  	
	
GO

---- End of step 3