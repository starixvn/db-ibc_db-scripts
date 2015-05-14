/*
	Created: Susan
	Date: 2015-03-09
	Site: Be7 
	Currency:  15,3,13,4,2,20 -- IN,US$,RMB,TB,RM,UUS		
	Task: update setting for Keno
	DB: DBTXN/CustDB
	Redmine: https://redmine.nexcel.vn/issues/31752
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
					WHEN @currency = 15 THEN 1  --IN 15	
					WHEN @currency = 3 THEN 1 --US$ 3
					WHEN @currency = 13 THEN 1  --RMB 13
					WHEN @currency = 4 THEN 10  --TB 4	
					WHEN @currency = 2 THEN 1  --RM 2
					WHEN @currency = 20 THEN 1  --UUS 20
					ELSE 0
					END
		,@maxbet =  CASE
					WHEN @currency = 15 THEN 33000  --IN 15	
					WHEN @currency = 3 THEN 3000  --US$ 3
					WHEN @currency = 13 THEN 10000  --RMB 13
					WHEN @currency = 4 THEN 50000  --TB 4	
					WHEN @currency = 2 THEN 50000  --RM 2
					WHEN @currency = 20 THEN 3000  --UUS 20
					ELSE 0
					END
		,@maxpermatch = CASE
						WHEN @currency = 15 THEN 15000  --IN 15	
						WHEN @currency = 3 THEN 15000  --US$ 3
						WHEN @currency = 13 THEN 50000 --RMB 13
						WHEN @currency = 4 THEN 250000  --TB 4	
						WHEN @currency = 2 THEN 1000000  --RM 2
						WHEN @currency = 20 THEN 15000  --UUS 20
						ELSE 0
						END
	IF (@minbet = 0)  RETURN 
	
	
			
-- Update pt for all members :7383 rows affected --- only need update 1 bettype 1501
	UPDATE newKN WITH(UPDLOCK,ROWLOCK)
	SET    newKN.MinBet = @minbet
		  ,newKN.MaxBet = @maxbet
		  ,newKN.MaxPerGameType= @maxpermatch
	FROM CustGameType newKN
	INNER JOIN custInfo c with(nolock) ON newKN.custid = c.custid 
	WHERE c.srecommend=@srecommend 
	AND mrecommend NOT IN (SELECT custid FROM custInfo WITH(NOLOCK) WHERE username like '%Acc%' AND roleid=3)
	and GameTypeID=1
	AND newKN.custid <=@max_custid



-- create temp table containing all accounts belong to super
	CREATE TABLE #tblCust (
		custid INT
		,GameTypeID INT
		,StakeLevelList VARCHAR(50)
		,MaxPerGameType MONEY
		,MinBet MONEY
		,MaxBet MONEY 
		,IsDisabled BIT 
		)
----insert keno setting into tmp table: for members that donot have setting on custgametype
	INSERT INTO #tblCust (
		 CustID
		,GameTypeID
		,StakeLevelList
		,MinBet
		,MaxBet
		,MaxPerGameType
		,IsDisabled
	)

	SELECT	ci.CustID
			,1 AS GameTypeID
			,'' AS StakeLevelList
			,@minbet
			,@maxbet
			,@maxpermatch
			,0 AS IsDisabled
	FROM custinfo ci with (nolock)
	WHERE CustID IN (SELECT custid FROM  custInfo c with(nolock)	
												WHERE c.srecommend=@srecommend )
	AND CustID not in (Select custid from CustGameType with(nolock))
	AND mrecommend NOT IN (SELECT custid FROM custInfo WITH(NOLOCK) WHERE username like '%Acc%' AND roleid=3)
	AND ci.custid <=@max_custid

---insert into custgametype
	INSERT INTO CustGameType(
		 CustID
		,GameTypeID
		,MinBet
		,MaxBet
		,MaxPerGameType
		,StakeLevelList
		,IsDisabled	
	)
	SELECT	CustID
			,GameTypeID
			,MinBet
			,MaxBet
			,MaxPerGameType
			,StakeLevelList
			,IsDisabled
	FROM	#tblCust WITH (NOLOCK) 

Drop table  #tblCust

End
GO
-- END STEP 1: DEPLOY THIS SP @ DBTRANS.CustDB -------

------------------------------------------------------	
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
 
CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency int 
SELECT   @site='BE7',
	     @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
					  where site=@site and currency  in (15,3,13,4,2,20)  -- IN,US$,RMB,TB,RM,UUS									
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

DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency int
SELECT   @site='BE7',
		 @max_custid= xxx ---input maxcustid

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
					  where site=@site and currency  in (15,3,13,4,2,20)  -- IN,US$,RMB,TB,RM,UUS			
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