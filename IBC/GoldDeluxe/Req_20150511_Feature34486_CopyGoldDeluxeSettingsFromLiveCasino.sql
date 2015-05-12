  /*
	Created: Johnson
	Date: 2015-05-11
	Task: Copy Gold Deluxe settings from Live Casino for credit customers
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
	
	DECLARE @StakeLevelList_1701 VARCHAR(100)= ''
			,@StakeLevelList_1702 VARCHAR(100)= ''
			,@StakeLevelList_1701_new VARCHAR(100)= ''
			,@StakeLevelList_1702_new VARCHAR(100)= ''
			,@currency INT
			,@custid INT
			,@uplineID INT
			,@roleid INT
			,@syncLiveCasino BIT
	
	CREATE TABLE #tmpCust (custid INT, syncLiveCasino BIT, roleid INT, UplineID INT)
	
	SELECT @currency = currency 
	FROM custinfo WITH(NOLOCK) 
	WHERE custid = @srecommend 
	
	INSERT INTO #tmpCust(custid,syncLiveCasino,roleid,UplineID)
	SELECT custid, syncLiveCasino, roleid, 
		CASE WHEN roleid = 3 THEN srecommend
			WHEN roleid = 2 THEN mrecommend
			WHEN roleid = 1 THEN recommend  ELSE 0 END
	FROM custinfo ci WITH(NOLOCK) 
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
	
	WHILE (1=1)
	BEGIN
		SELECT TOP (1) @custid = custid
			,@roleid = roleid
			,@syncLiveCasino = syncLiveCasino
			,@UplineID = uplineID
		FROM #tmpCust		
		ORDER BY roleid DESC
		
		IF @@ROWCOUNT = 0
			BREAK;
		
		IF @syncLiveCasino = 1
		BEGIN
			--get stakelevel from LiveCasino
			SELECT @StakeLevelList_1701 = StakeLevelList
			FROM DBBingoAdmin.LiveCasinoAdmin.dbo.CustGameType s with(Nolock) 
			WHERE custid = @custid
				AND GameTypeID = 108
				
			SELECT @StakeLevelList_1702 = StakeLevelList
			FROM DBBingoAdmin.LiveCasinoAdmin.dbo.CustGameType s with(Nolock) 
			WHERE custid = @custid
				AND GameTypeID = 109	
			
			SELECT @StakeLevelList_1701_new = @StakeLevelList_1701_new + CONVERT(VARCHAR(10),StakeLevelID) + ','
			FROM (
			SELECT MinStake, MaxStake
			FROM DBBingoAdmin.LiveCasinoAdmin.dbo.StakeLevel WITH(NOLOCK) 
			WHERE stakeLevelID IN (SELECT val FROM strSplit(@StakeLevelList_1701,','))
			)t 
			INNER JOIN bodb02.dbo.StakeLevel s WITH(NOLOCK) ON t.MinStake = s.MinStake AND t.MaxStake = s.MaxStake
			WHERE s.ExchangeID = @currency 
				AND GameTypeID = 1701
			ORDER BY s.MinStake, s.MaxStake
			
			IF @StakeLevelList_1701_new <> ''
				SELECT @StakeLevelList_1701_new = left(@StakeLevelList_1701_new,len(@StakeLevelList_1701_new) - 1)
			
			SELECT @StakeLevelList_1702_new = @StakeLevelList_1702_new + CONVERT(VARCHAR(10),StakeLevelID) + ','
			FROM (
			SELECT MinStake, MaxStake
			FROM DBBingoAdmin.LiveCasinoAdmin.dbo.StakeLevel WITH(NOLOCK) 
			WHERE stakeLevelID IN (SELECT val FROM strSplit(@StakeLevelList_1701,','))
			)t 
			INNER JOIN bodb02.dbo.StakeLevel s WITH(NOLOCK) ON t.MinStake = s.MinStake AND t.MaxStake = s.MaxStake
			WHERE s.ExchangeID = @currency 
				AND GameTypeID = 1702
			ORDER BY s.MinStake, s.MaxStake
			
			IF @StakeLevelList_1702_new <> ''
				SELECT @StakeLevelList_1702_new = left(@StakeLevelList_1702_new,len(@StakeLevelList_1702_new) - 1)
			
			INSERT INTO CustGameType(custid,GameTypeID,StakeLevelList)
			SELECT @custid, 1701,@StakeLevelList_1701_new
			UNION 
			SELECT @custid, 1702,@StakeLevelList_1702_new
		END
		ELSE
		BEGIN
			IF @roleid = 4
			BEGIN
				--get stake from Global settings
				SELECT @StakeLevelList_1701_new = @StakeLevelList_1701_new + CONVERT(VARCHAR(10),StakeLevelID) + ','
				FROM bodb02.dbo.StakeLevel s WITH(NOLOCK) 
				WHERE s.ExchangeID = @currency 
					AND GameTypeID = 1701
				ORDER BY s.MinStake, s.MaxStake
				
				SELECT @StakeLevelList_1702_new = @StakeLevelList_1702_new + CONVERT(VARCHAR(10),StakeLevelID) + ','
				FROM bodb02.dbo.StakeLevel s WITH(NOLOCK) 
				WHERE s.ExchangeID = @currency 
					AND GameTypeID = 1702
				ORDER BY s.MinStake, s.MaxStake
				
				IF @StakeLevelList_1701_new <> ''
					SELECT @StakeLevelList_1701_new = left(@StakeLevelList_1701_new,len(@StakeLevelList_1701_new) - 1)
			
				IF @StakeLevelList_1702_new <> ''
					SELECT @StakeLevelList_1702_new = left(@StakeLevelList_1702_new,len(@StakeLevelList_1702_new) - 1)
				
				INSERT INTO CustGameType(custid,GameTypeID,StakeLevelList)
				SELECT @custid, 1701,@StakeLevelList_1701_new
				UNION 
				SELECT @custid, 1702,@StakeLevelList_1702_new
			END
			ELSE IF @roleid IN (2,3)
			BEGIN
				INSERT INTO CustGameType(custid,GameTypeID,StakeLevelList)
				SELECT @custid, GameTypeID,	StakeLevelList
				FROM CustGameType WITH(NOLOCK)
				WHERE custID = @uplineID
					AND GameTypeID IN (1701,1702)
			END
			ELSE IF @roleid = 1
			BEGIN
				SELECT @StakeLevelList_1701 = StakeLevelList
				FROM CustGameType WITH(NOLOCK) 
				WHERE custid = @uplineID
					AND GameTypeID = 1701
				
				SELECT @StakeLevelList_1702 = StakeLevelList
				FROM CustGameType WITH(NOLOCK) 
				WHERE custid = @uplineID
					AND GameTypeID = 1702
				
				--get lowest stake level from upline to apply for member
				SELECT TOP (1) @StakeLevelList_1701_new = CONVERT(varchar(10),StakeLevelID)
				FROM bodb02.dbo.StakeLevel WITH(NOLOCK) 		
				WHERE StakeLevelID IN (SELECT val FROM strSplit(@StakeLevelList_1701,','))
				ORDER BY MinStake, MaxStake ASC
				
				SELECT TOP (1) @StakeLevelList_1702_new = CONVERT(varchar(10),StakeLevelID)
				FROM bodb02.dbo.StakeLevel WITH(NOLOCK) 		
				WHERE StakeLevelID IN (SELECT val FROM strSplit(@StakeLevelList_1702,','))
				ORDER BY MinStake, MaxStake ASC
				
				INSERT INTO CustGameType(custid,GameTypeID,StakeLevelList)
				SELECT @custid, 1701,@StakeLevelList_1701_new
				UNION 
				SELECT @custid, 1702,@StakeLevelList_1702_new
			END
		END
		
		DELETE #tmpCust WHERE custid = @custid
	END
	
	
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
           ,1701 as [Bettype]
           ,255 as [Sporttype]
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
		AND cs.sporttype = 162
		AND cs.bettype = 1101         
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
FROM CustInfo WITH(NOLOCK)
WHERE roleid = 4 
	AND currency = 20 
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))


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
FROM CustInfo WITH(NOLOCK)
WHERE roleid = 4 
	AND currency = 20 
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))

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
 				