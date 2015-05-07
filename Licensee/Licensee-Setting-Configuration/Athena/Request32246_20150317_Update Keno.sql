/*
	Created: Susan
	Date: 2015-03-17
	Site: 'Bet2day','Allbetclub','Hbobet','Mgm88','THBET','Winner99'
	Currency: US$,TB, UUS
	Task: update bet setting for Keno
	DB: DBTXN/CustDB
	Redmine: https://redmine.nexcel.vn/issues/32485
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
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','CustGameType') AND type = 'U' ) <> 2
		RETURN

DECLARE @minbet money, @maxbet money, @maxpermatch money
	
		 
	SELECT @minbet =CASE 
					WHEN @currency= 4 THEN 10  --TB 4
					WHEN @currency = 3 THEN 1  --US$ 3
					WHEN @currency = 20 THEN 1  --UUS
					ELSE 0
					END
		,@maxbet =  CASE
					WHEN @currency= 4 THEN 50000  --TB 4
					WHEN @currency=3 then 3000--US$ 3
					WHEN @currency = 20 THEN 3000  --UUS
					ELSE 0
					END
		,@maxpermatch = CASE
						WHEN @currency= 4 THEN 250000  --TB 4
						WHEN @currency= 3 then 15000 --US$ 3
						WHEN @currency = 20 THEN 15000  --UUS
						ELSE 0
						END
	IF (@minbet = 0)  RETURN 
	
				
---update keno setting custgametype: 11333 rows affected
	UPDATE newKN WITH(UPDLOCK,ROWLOCK)
	SET    MinBet=@minbet, 
		   MaxBet=@maxbet , 
		   MaxPerGameType= @maxpermatch,
		   IsDisabled=0	
	FROM CustGameType newKN 
	INNER JOIN custInfo c with(nolock) ON newKN.custid = c.custid 
	WHERE c.srecommend=@srecommend 
	AND mrecommend NOT IN (SELECT custid FROM custInfo WITH(NOLOCK) WHERE username like '%Acc%' AND roleid=3)
	AND newKN.GameTypeID=1
	AND newKN.custid <=@max_custid

End
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------

------------------------------------------------------	
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
 
CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @currency int ,@ptVALUE SMALLMONEY
SELECT   @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
					  where site in ('Bet2day','Allbetclub','Hbobet','Mgm88','THBET','Winner99')  ---103,132,121,120,136,106
					   and currency  in (3,4,20)						
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

DECLARE @max_custid INT, @srecommend INT,  @currency int ,@ptVALUE SMALLMONEY

SELECT  @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
					  where site in ('Bet2day','Allbetclub','Hbobet','Mgm88','THBET','Winner99')  ---103,132,121,120,136,106
					   and currency  in (3,4,20)						
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