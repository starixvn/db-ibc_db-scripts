/*
	Created: Susan
	Date: 2015-01-15
	Site: Hbobet 
	Currency: TB, UUS 4  20
	Task: Set up setting for Keno
	DB: DBTXN/CustDB
	Redmine: https://redmine.nexcel.vn/issues/29081
*/ 
-- BEGIN STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -----
------------------------------------------------------
ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
 	 @srecommend INT
	,@currency int	
	,@max_custid INT
	,@target VARCHAR(20)
AS
BEGIN	
	SET NOCOUNT ON
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','CustGameType','CustSettingGame') AND type = 'U' ) <> 3
		RETURN

DECLARE @minbet money, @maxbet money, @maxpermatch money,  @ptVALUE SMALLMONEY
	
	SELECT @ptVALUE = 0.9  --Keno PT 
	 
	SELECT @minbet =CASE 
					WHEN @currency = 4 THEN 10  --TB 4
					WHEN @currency = 20 THEN 10  --UUS
					ELSE 0
					END
		,@maxbet =  CASE
					WHEN @currency= 4 then 15000 --TB 4
					WHEN @currency = 20 THEN 15000  --UUS
					ELSE 0
					END
		,@maxpermatch = CASE
						WHEN @currency= 4 then 50000 --TB 4
						WHEN @currency = 20 THEN 50000  --UUS
						ELSE 0
						END
	IF (@minbet = 0)  RETURN 
	
	
--- Enable keno on Custinfo : 1152 rows affected	
	UPDATE Custinfo WITH(UPDLOCK,ROWLOCK)
	SET HideKeno=0
	WHERE srecommend=@srecommend 
	AND mrecommend NOT IN (SELECT custid FROM custInfo WITH(NOLOCK) WHERE username like '%Acc%' AND roleid=3)
	AND custid<=@max_custid
			
-- Update pt for all members :11520 rows affected
	UPDATE newKN WITH(UPDLOCK,ROWLOCK)
	SET    newKN.spositiontaking = case when roleid = 4 then @ptVALUE else 0 end 
		  ,newKN.mpositiontaking = case when roleid in (4,3)  then @ptVALUE else 0 end 
		  ,newKN.apositiontaking = case when roleid = 3  then 0 else @ptVALUE end 
	FROM CustSettingGame newKN 
	INNER JOIN custInfo c with(nolock) ON newKN.custid = c.custid 
	WHERE c.srecommend=@srecommend 
	AND mrecommend NOT IN (SELECT custid FROM custInfo WITH(NOLOCK) WHERE username like '%Acc%' AND roleid=3)
	AND newKN.sporttype=202
	AND newKN.custid <=@max_custid

----update keno setting custgametype: 16180 rows affected
	UPDATE newKN WITH(UPDLOCK,ROWLOCK)
	SET    MinBet=@minbet, 
		   MaxBet=@maxbet , 
		   MaxPerGameType= @maxpermatch,
		   IsDisabled=0	
	FROM CustGameType newKN 
	INNER JOIN custInfo c with(nolock) ON newKN.custid = c.custid 
	WHERE c.srecommend=@srecommend 
	AND mrecommend NOT IN (SELECT custid FROM custInfo WITH(NOLOCK) WHERE username like '%Acc%' AND roleid=3)
	AND newKN.custid <=@max_custid

End
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------

------------------------------------------------------	
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
 
CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency int ,@ptVALUE SMALLMONEY
SELECT   @site='Hbobet',
	     @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
					  where site=@site and currency  in (4,20)  -- TB, UUS									
AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
		,@currency=currency			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend, @currency=@currency, @max_custid=@max_custid,@target ='REPLICATED'  	
				
	WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers		
GO		

-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------

---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------
CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency int ,@ptVALUE SMALLMONEY
SELECT   @site='Hbobet',
		 @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
					  where site=@site and currency  in (4,20)  -- TB, UUS			
AND custid <= @max_custid


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #supers
	SET isfinished = 1
		,@srecommend = custid
		,@currency=currency			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend, @currency=@currency, @max_custid=@max_custid,@target ='DBTRANS'  	
		
	WAITFOR DELAY '00:00:00.280'			
END	

DROP TABLE #supers		
GO		



-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-------------------------------------------------