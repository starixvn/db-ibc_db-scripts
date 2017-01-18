/*
	Created: Johnson
	Date: 2016-12-29
	Task: copy PT, comm from LCS for GD
	DB: DBCUST/CustDB
*/

 ALTER PROCEDURE [dbo].[Acc_CustSetting3rd_19]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 )
		RETURN
		
	CREATE TABLE #SMATemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		roleid TINYINT,
		SyncLiveCasino BIT,
		MaxWinLiveCasino SMALLMONEY,
		isAutoResetLiveCasino BIT
	)
	
	INSERT INTO #SMATemp
	SELECT custid, roleid, syncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino
	FROM custinfo ci WITH(NOLOCK)
	WHERE srecommend = @srecommend 
		AND custid <= @maxcustid
		AND roleid IN (2,3,4)
		AND Enabled = 1
		
	IF ( dbo.f_CheckRepTable('CustWinLimit') = 1 	)	 		
	BEGIN
		--super level		
		INSERT INTO CustWinLimit(CustId
								,SportType
								,BetType
								,MaxWinLimit
								,IsAutoReset)
		SELECT custid
			,255
			,1701
			,CASE WHEN SyncLiveCasino = 0 THEN 0 ELSE MaxWinLiveCasino END 
			,CASE WHEN SyncLiveCasino = 0 THEN 1 ELSE isAutoResetLiveCasino END
		FROM CustInfo WITH(NOLOCK)
		WHERE custid = @srecommend
		
		--master level
		INSERT INTO CustWinLimit(CustId
								,SportType
								,BetType
								,MaxWinLimit
								,IsAutoReset)
		SELECT ci.custid
			,255
			,1701
			,CASE WHEN ci.SyncLiveCasino = 1 THEN ci.MaxWinLiveCasino 
				WHEN s.syncLiveCasino = 1 THEN s.MaxWinLiveCasino
				ELSE 0 END 
			,CASE WHEN ci.SyncLiveCasino = 1 THEN ci.isAutoResetLiveCasino 
				WHEN s.syncLiveCasino = 1 THEN s.isAutoResetLiveCasino
				ELSE 1 END 
		FROM CustInfo ci WITH(NOLOCK)
			INNER JOIN #SMATemp s ON ci.srecommend = s.custid
		WHERE ci.srecommend = @srecommend 
			AND ci.roleid = 3
			AND ci.custid <= @maxcustid
			AND ci.Enabled = 1
			
		--agent level									
		INSERT INTO CustWinLimit(CustId
								,SportType
								,BetType
								,MaxWinLimit
								,IsAutoReset)
		SELECT ci.custid
			,255
			,1701
			,CASE WHEN ci.SyncLiveCasino = 1 THEN ci.MaxWinLiveCasino 
				WHEN m.syncLiveCasino = 1 THEN m.MaxWinLiveCasino
				WHEN s.syncLiveCasino = 1 THEN s.MaxWinLiveCasino
				ELSE 0 END 
			,CASE WHEN ci.SyncLiveCasino = 1 THEN ci.isAutoResetLiveCasino 
				WHEN m.syncLiveCasino = 1 THEN m.isAutoResetLiveCasino
				WHEN s.syncLiveCasino = 1 THEN s.isAutoResetLiveCasino
				ELSE 1 END 
		FROM CustInfo ci WITH(NOLOCK)
			INNER JOIN #SMATemp s ON ci.srecommend = s.custid
			INNER JOIN #SMATemp m ON ci.mrecommend = m.custid
		WHERE ci.srecommend = @srecommend 
			AND ci.roleid = 2
			AND ci.custid <= @maxcustid
			AND ci.Enabled = 1
		
		--member level
		INSERT INTO CustWinLimit(CustId
								,SportType
								,BetType
								,MaxWinLimit
								,IsAutoReset)
		SELECT ci.custid
			,255
			,1701
			,CASE WHEN ci.SyncLiveCasino = 1 THEN ci.MaxWinLiveCasino 
				WHEN a.syncLiveCasino = 1 THEN a.MaxWinLiveCasino
				WHEN m.syncLiveCasino = 1 THEN m.MaxWinLiveCasino
				WHEN s.syncLiveCasino = 1 THEN s.MaxWinLiveCasino
				ELSE 0 END 
			,CASE WHEN ci.SyncLiveCasino = 1 THEN ci.isAutoResetLiveCasino 
				WHEN a.syncLiveCasino = 1 THEN a.isAutoResetLiveCasino
				WHEN m.syncLiveCasino = 1 THEN m.isAutoResetLiveCasino
				WHEN s.syncLiveCasino = 1 THEN s.isAutoResetLiveCasino
				ELSE 1 END 
		FROM CustInfo ci WITH(NOLOCK)
			INNER JOIN #SMATemp s ON ci.srecommend = s.custid
			INNER JOIN #SMATemp m ON ci.mrecommend = m.custid
			INNER JOIN #SMATemp a ON ci.recommend = a.custid
		WHERE ci.srecommend = @srecommend 
			AND ci.roleid = 1
			AND ci.custid <= @maxcustid		
			AND ci.Enabled = 1
	END
	
	
	IF ( dbo.f_CheckRepTable('CustSettingGame') = 1
		AND dbo.f_CheckRepTable('CustOverrideGame') = 1
	)
	BEGIN
		--super/master/agent level
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
			   ,CASE WHEN SyncLiveCasino = 1 THEN [apositiontaking] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN [mpositiontaking] ELSE 0 END 
			   ,CASE WHEN SyncLiveCasino = 1 THEN [spositiontaking] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN [playerdiscount] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN [discount] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN [adiscount] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN [sdiscount] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN [autopositiontaking] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN [isautopositiontaking] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN [autompositiontaking] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN [isautompositiontaking] ELSE 0 END
		FROM  CustSettingGame cs WITH(NOLOCK) 
			INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		WHERE ci.srecommend = @srecommend
			AND ci.custid <= @maxcustid
			AND ci.roleid IN (2,3,4)
			AND cs.sporttype = 162
			AND cs.bettype = 1101  
			AND ci.enabled = 1   
		
		--member level
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
			   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[apositiontaking] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[mpositiontaking] ELSE 0 END 
			   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[spositiontaking] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[playerdiscount] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[discount] ELSE acs.discount END
			   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[adiscount] ELSE mcs.adiscount END
			   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[sdiscount] ELSE scs.sdiscount END
			   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[autopositiontaking] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[isautopositiontaking] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[autompositiontaking] ELSE 0 END
			   ,CASE WHEN SyncLiveCasino = 1 THEN cs.[isautompositiontaking] ELSE 0 END
		FROM  CustSettingGame cs WITH(NOLOCK) 
			INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
			INNER JOIN CustSettingGame acs WITH(NOLOCK) ON acs.custid = ci.recommend
														AND acs.sporttype = 255
														AND acs.bettype = 1701
			INNER JOIN CustSettingGame mcs WITH(NOLOCK) ON mcs.custid = ci.mrecommend
														AND mcs.sporttype = 255
														AND mcs.bettype = 1701
			INNER JOIN CustSettingGame scs WITH(NOLOCK) ON scs.custid = ci.srecommend
														AND scs.sporttype = 255
														AND scs.bettype = 1701													
		WHERE ci.srecommend = @srecommend
			AND ci.custid <= @maxcustid
			AND ci.roleid = 1
			AND cs.sporttype = 162
			AND cs.bettype = 1101  
			AND ci.enabled = 1   
		
		INSERT INTO [dbo].[CustOverrideGame]
			   ([CustID]
			   ,[Bettype]
			   ,[Sporttype]
			   ,[minpositiontaking])
		SELECT cs.[CustID]
			   ,1701 as [Bettype]
			   ,255 as [Sporttype]
			   ,CASE WHEN SyncLiveCasino = 1 THEN [minpositiontaking] ELSE 0 END          
		FROM  CustOverrideGame cs WITH(NOLOCK) 
			INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		WHERE ci.srecommend = @srecommend
			AND ci.custid <= @maxcustid
			AND ci.roleid IN (2,3,4)
			AND cs.sporttype = 162
			AND cs.bettype = 1101
			and enabled = 1  
	END	

	IF (SELECT COUNT(1) FROM sys.objects WHERE NAME IN ('tmpCustGameType')) = 1
		AND dbo.f_CheckRepTable('CustGameType') = 1
	BEGIN
		INSERT INTO [dbo].[CustGameType]
           ([CustID]
           ,[GameTypeID]
           ,[StakeLevelList]           
           ,[IsDisabled]
           )
		SELECT 
			ci.[CustID]
           ,[GameTypeID]
           ,ISNULL([StakeLevelList_GD],'')
           ,0 as [IsDisabled]
		FROM tmpCustGameType t WITH(NOLOCK)
			INNER JOIN custinfo ci WITH(NOLOCK) ON t.custid = ci.custid
		WHERE srecommend = @srecommend
		AND ci.custid <= @maxcustid
	END

END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	




---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx

--disable supers list
INSERT INTO #supers(custid)
SELECT ci.custid
FROM Customer ci WITH(NOLOCK)
WHERE site = '789y'
	AND roleid =4 
	AND custid <= @max_custid
	
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
	
	waitfor delay '00:00:0.280'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
-----------------------------------------------------------------------------------
 
 
 
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT

SELECT @max_custid = xx

--disable supers list
INSERT INTO #supers(custid)
SELECT ci.custid
FROM Customer ci WITH(NOLOCK)
WHERE site = '789y'
	AND roleid =4 
	AND custid <= @max_custid
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid					
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_CustSetting3rd_19] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'			
	
	waitfor delay '00:00:0.280'
END			
GO	

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------
 				