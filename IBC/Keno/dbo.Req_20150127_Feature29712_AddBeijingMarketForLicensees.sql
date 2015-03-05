 /*
	Created: Johnson
	Date: 2015-01-27
	Task: Add Beijing market for all licensees 
	DB: DBTXN/CustDB
 */
 
 
 -- BEGIN STEP 1: DEPLOY THIS SP @DBTRANS.CustDB ------
------------------------------------------------------
 
 ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBTRANS') RETURN	-- run at all replicated servers
	IF (@target = 'DBTRANS' AND @@SERVERNAME <> 'DBTRANS') RETURN -- run at dbtrans only
	
	IF ( SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('Custinfo','CustGameType','CustSettingGame') AND type = 'U' ) <> 3
		RETURN
	
	INSERT INTO [dbo].[CustGameType]
           ([CustID]
           ,[GameTypeID]
           ,[StakeLevelList]
           ,[MaxPerGameType]
           ,[MinBet]
           ,[MaxBet]
           ,[IsDisabled])
	SELECT cg.[CustID]
           ,2 as [GameTypeID]--Beijing
           ,[StakeLevelList]
           ,[MaxPerGameType]
           ,[MinBet]
           ,[MaxBet]
           ,[IsDisabled]
	FROM CustGameType cg WITH(NOLOCK)
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cg.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND cg.GameTypeID = 1 --Australia Acttab           
	
	INSERT INTO [dbo].[CustSettingGame]
           ([CustID]
           ,[Bettype]
           ,[Sporttype]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[autopositiontaking]
           ,[isautopositiontaking]
           ,[autompositiontaking]
           ,[isautompositiontaking])
	SELECT cs.[CustID]
           ,1502 as [Bettype]
           ,[Sporttype]
           ,[apositiontaking]
           ,[mpositiontaking]
           ,[spositiontaking]
           ,[playerdiscount]
           ,[discount]
           ,[adiscount]
           ,[sdiscount]
           ,[autopositiontaking]
           ,[isautopositiontaking]
           ,[autompositiontaking]
           ,[isautompositiontaking]
	FROM  CustSettingGame cs WITH(NOLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND cs.sporttype = 202
		AND cs.bettype = 1501 --Australia Acttab          
END	
GO
-- END STEP 1: DEPLOY THIS SP @DBTRANS.CustDB --------
------------------------------------------------------	


---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx

INSERT INTO #supers(custid)
SELECT custid
FROM Dep_CustSuper WITH(NOLOCK)


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (DB052/053/053/054/06 -----
-----------------------------------------------------------------------------------
 
 
 
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBTRANS -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx

INSERT INTO #supers(custid)
SELECT custid
FROM Dep_CustSuper WITH(NOLOCK)


WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid			
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBTRANS'
END			
GO		
-- END STEP 3: RUN THIS SCRIPT AT DBTRANS -----
-----------------------------------------------------------------------------------
 				