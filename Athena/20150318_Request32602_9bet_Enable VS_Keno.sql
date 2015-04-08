/*
	Created: Susan
	Date: 2015-03-17
	Site: 9Bet
	Task: update bet setting for Keno, virtual sport
	DB: DBTXN/CustDB
	Redmine: https://redmine.nexcel.vn/issues/32602
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
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','Dep_CustSetting3rd','CustGameType') AND type = 'U' ) <> 3
		RETURN

DECLARE @minbet money, @maxbet money, @maxpermatch money,  @ptVALUE SMALLMONEY
	
	SELECT @ptVALUE = 0.85  --Virtual sports PT 
	
		 
	SELECT @minbet = CASE 
					WHEN @currency = 3 THEN 1  --TB
					WHEN @currency = 15 THEN 10  --US$
					WHEN @currency = 20 THEN 1  --UUS
					ELSE 0
					END
		,@maxbet = CASE 
					WHEN @currency = 3 THEN 500  --TB
					WHEN @currency = 15 THEN 10000  --US$
					WHEN @currency = 20 THEN 500  --UUS
					ELSE 0
					END
		,@maxpermatch = CASE 
						WHEN @currency = 3 THEN 1500  --TB
						WHEN @currency = 15 THEN 50000  --US$
						WHEN @currency = 20 THEN 1500  --UUS
						ELSE 0
						END

	IF (@minbet = 0)  RETURN 
	
--- update custinfo table 	:6109 rows affected			
	UPDATE Custinfo WITH(UPDLOCK,ROWLOCK)
	SET maxpermatch180 = @maxpermatch,
	    maxpermatch181 = @maxpermatch,
		maxpermatch182 = @maxpermatch,
		maxpermatch183 = @maxpermatch,
		maxpermatch184 = @maxpermatch,
		maxpermatch185 = @maxpermatch,
		maxpermatch186 = @maxpermatch,
		DisableVirtualSports = 0,
		HideVirtualSports = 0
	WHERE srecommend=@srecommend
	AND mrecommend not in (select custid from custInfo with(nolock) where roleid=3 and username like '%Acc%')
	AND custid<=@max_custid
							
---update keno setting custgametype: 6110 rows affected
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


	-- create temp table containing all accounts belong to super
	CREATE TABLE #tblCust (custid int, roleid int, sporttype int, bettype int)

--  42763 rows	
	INSERT INTO #tblCust (custid,roleid, sporttype,bettype)
		SELECT custid,roleid, sporttype, bettype
		FROM custinfo with (nolock)
		CROSS JOIN (
					SELECT 180 as sporttype, 1201 as bettype 
					UNION ALL SELECT 181 as sporttype, 1231 as bettype 
					UNION ALL SELECT 182 as sporttype, 1231 as bettype 
					UNION ALL SELECT 183 as sporttype, 1231 as bettype 
					UNION ALL SELECT 184 as sporttype, 1231 as bettype 
					UNION ALL SELECT 185 as sporttype, 1231 as bettype 
					UNION ALL SELECT 186 as sporttype, 1220 as bettype 
				) t
	    WHERE srecommend = @srecommend
		AND mrecommend not in (select custid from custInfo with(nolock) where roleid=3 and username like '%Acc%')
		and custid<= @max_custid


	-- Update VS bet setting: 25919 rows
	UPDATE newVS WITH(UPDLOCK,ROWLOCK)
	SET     newVS.spositiontaking = case when roleid = 4 then @ptVALUE else 0 end 
			, newVS.mpositiontaking = case when roleid in (4,3)  then @ptVALUE else 0 end 
			, newVS.apositiontaking = case when roleid = 3  then 0 else @ptVALUE end 
			, newVS.sdiscount = 0
			, newVS.adiscount = 0
			, newVS.discount = 0
			, newVS.playerdiscount = 0
			, newVS.minbet = @minbet
			, newVS.maxbet = @maxbet
	FROM Dep_CustSetting3rd newVS 
	INNER JOIN #tblCust t ON newVS.custid = t.custid and newVS.sporttype = t.sporttype and newVS.bettype = t.bettype
	and newVS.custid <=@max_custid
	

    -- Remove Virtual sport that having setting in Dep_CustSetting3rd
	 DELETE t 
	 FROM #tblCust t 
	 INNER JOIN Dep_CustSetting3rd cs on t.custid = cs.custid and t.sporttype = cs.sporttype and t.bettype = cs.bettype 
	 
	---7958 rows  	
	INSERT INTO [dbo].[Dep_CustSetting3rd]
			   ([custid]
			   ,[bettype]
			   ,[sporttype]
			   ,[islive]
			   ,[apositiontaking]
			   ,[mpositiontaking]
			   ,[spositiontaking]
			   ,[playerdiscount]
			   ,[discount]
			   ,[adiscount]
			   ,[sdiscount]
			   ,[minbet]
			   ,[maxbet])
	SELECT  custid
		   ,bettype as [bettype]
		   ,sporttype as [sporttype]
		   ,0 [islive]
		   ,case when roleid = 3  then 0 else @ptVALUE end as [apositiontaking]
		   ,case when roleid in (4,3)  then @ptVALUE else 0 end as [mpositiontaking]
		   ,case when roleid = 4 then @ptVALUE else 0 end as [spositiontaking]
		   ,0 as [playerdiscount]
		   ,0 as [discount]
		   ,0 as [adiscount]
		   ,0 as [sdiscount]
		   ,@minbet
		   ,@maxbet
	FROM #tblCust 
	
	DROP TABLE #tblCust

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
					  where site ='9Bet'  ---98		
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
					  where site ='9Bet'  ---98		
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