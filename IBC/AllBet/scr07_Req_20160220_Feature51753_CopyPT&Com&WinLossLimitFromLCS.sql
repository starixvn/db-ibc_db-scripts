/*
	Created: Elodie
	Task: Copy PT & Comm & WinLossLimit for All Bet from Live Casino
	DB: DBCUST/CustDB
	Date: 20150618
*/ 
 ALTER PROCEDURE [dbo].[Acc_DynamicCustSetting3rd_09]
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF dbo.f_CheckRepTable('CustInfo') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTSetting3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustPTGroupSetting3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustDiscount3rd_Member') = 0 RETURN
	IF dbo.f_CheckRepTable('CustDiscount3rd_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Agent') = 0 RETURN
	IF dbo.f_CheckRepTable('CustWinLossLimit_Member') = 0 RETURN	
	
	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(162, 1101, 211	, 2401, 0, 1), --PT
	(162, 1101, 211	, 2401, 0, 3), --Comm
	(162, 1101, 211	, 2401, 0, 6) --WinLossLimit

	CREATE TABLE #MemberTemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		SyncLiveCasino BIT,
		MaxWinLiveCasino SMALLMONEY,
		isAutoResetLiveCasino BIT
	)

	CREATE TABLE #SMATemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		roleid TINYINT,
		SyncLiveCasino BIT,
		MaxWinLiveCasino SMALLMONEY,
		isAutoResetLiveCasino BIT
	)
	
	INSERT INTO #MemberTemp (CustID, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino)
	SELECT custid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid = 1  AND Enabled = 1 AND custid <= @maxcustid
	
	
	INSERT INTO #SMATemp (CustID, roleid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino)
	SELECT custid, roleid, SyncLiveCasino, MaxWinLiveCasino, isAutoResetLiveCasino
	FROM Custinfo WITH (NOLOCK)
	WHERE srecommend = @srecommend AND roleid IN (2,3,4) AND Enabled = 1 AND custid <= @maxcustid 

	DECLARE @SyncLCSuper BIT
	SELECT @SyncLCSuper = SyncLiveCasino FROM #SMATemp ci WITH (NOLOCK) WHERE custid = @srecommend
	--------------------------------------WinLossLimit-------------------------------------------------
	--SuperLevel
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT custid, dest.tSportType, dest.tBetType	
		,CASE WHEN @SyncLCSuper = 0 THEN 0 ELSE MaxWinLiveCasino END AS MaxWinLimit
		,0 AS MaxLossLimit 
		,CASE WHEN @SyncLCSuper = 0 THEN 1 ELSE isAutoResetLiveCasino END AS IsAutoReset
	FROM dbo.custInfo ci WITH(NOLOCK)	
		CROSS JOIN #DestinationSportBetType dest WITH(NOLOCK) 
	WHERE ci.custid = @srecommend AND dest.SettingType = 6 
									
	--Master Level
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT ci.custid, dest.tSportType, dest.tBetType	
		,CASE	WHEN ci.SyncLiveCasino  = 1 THEN ci.MaxWinLiveCasino
				WHEN @SyncLCSuper = 1 THEN si.MaxWinLiveCasino 
				ELSE 0 END AS MaxWinLimit
		,0 AS MaxLossLimit 
		,CASE	WHEN ci.SyncLiveCasino  = 1 THEN ci.isAutoResetLiveCasino
				WHEN @SyncLCSuper = 1 THEN si.isAutoResetLiveCasino 
				ELSE 1 END AS IsAutoReset
	FROM dbo.custInfo ci WITH(NOLOCK)	
		INNER JOIN custinfo si WITH (NOLOCK) ON ci.srecommend = si.custid
		CROSS JOIN #DestinationSportBetType dest WITH(NOLOCK) 
	WHERE ci.srecommend = @srecommend AND ci.roleid = 3 AND dest.SettingType = 6 

	--Agent Level
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT ci.custid, dest.tSportType, dest.tBetType	
		,CASE	WHEN ci.SyncLiveCasino  = 1 THEN ci.MaxWinLiveCasino
				WHEN mi.SyncLiveCasino = 1 THEN mi.MaxWinLiveCasino 
				WHEN si.SyncLiveCasino = 1 THEN si.MaxWinLiveCasino 
				ELSE 0 END AS MaxWinLimit
		,0 AS MaxLossLimit 
		,CASE	WHEN ci.SyncLiveCasino  = 1 THEN ci.isAutoResetLiveCasino
				WHEN mi.SyncLiveCasino = 1 THEN mi.isAutoResetLiveCasino 
				WHEN si.SyncLiveCasino = 1 THEN si.isAutoResetLiveCasino 
				ELSE 1 END AS IsAutoReset
	FROM dbo.custInfo ci WITH(NOLOCK)
		INNER JOIN custinfo mi WITH (NOLOCK) ON ci.mrecommend = mi.custid	
		INNER JOIN custinfo si WITH (NOLOCK) ON ci.srecommend = si.custid
		CROSS JOIN #DestinationSportBetType dest WITH(NOLOCK) 
	WHERE ci.srecommend = @srecommend AND ci.roleid = 2 AND dest.SettingType = 6
	
	--Member Level
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType, MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT ci.custid, dest.tSportType, dest.tBetType	
		,CASE	WHEN ci.SyncLiveCasino  = 1 THEN ci.MaxWinLiveCasino
				WHEN ai.SyncLiveCasino = 1 THEN ai.MaxWinLiveCasino 
				WHEN mi.SyncLiveCasino = 1 THEN mi.MaxWinLiveCasino 
				WHEN si.SyncLiveCasino = 1 THEN si.MaxWinLiveCasino 
				ELSE 0 END AS MaxWinLimit
		,0 AS MaxLossLimit 
		,CASE	WHEN ci.SyncLiveCasino  = 1 THEN ci.isAutoResetLiveCasino
				WHEN ai.SyncLiveCasino = 1 THEN ai.isAutoResetLiveCasino 
				WHEN mi.SyncLiveCasino = 1 THEN mi.isAutoResetLiveCasino 
				WHEN si.SyncLiveCasino = 1 THEN si.isAutoResetLiveCasino 
				ELSE 1 END AS IsAutoReset
	FROM dbo.custInfo ci WITH(NOLOCK)
		INNER JOIN Custinfo ai WITH (NOLOCK) ON ci.recommend = ai.custid
		INNER JOIN custinfo mi WITH (NOLOCK) ON ci.mrecommend = mi.custid	
		INNER JOIN custinfo si WITH (NOLOCK) ON ci.srecommend = si.custid
		CROSS JOIN #DestinationSportBetType dest WITH(NOLOCK) 
	WHERE ci.srecommend = @srecommend AND ci.roleid = 1 AND dest.SettingType = 6 
	
	--------------------------------------PT Setting-------------------------------------------------	
	--AGENT LEVEL
	INSERT INTO dbo.CustPTSetting3rd_Agent
		(	[CustID]
		   ,[SportType]
		   ,[BetType]
		   ,[IsLive]
		   ,[SuperPT]
		   ,[MasterPT]
		   ,[AgentPT]
		   ,[IsAutoMasterPT]
		   ,[AutoMasterPT]
		   ,[IsAutoSuperPT]
		   ,[AutoSuperPT]
		   ,[MinPT]
		   ,[MaxPT])
	SELECT 
		cs.custid, dest.tsporttype, dest.tbettype, dest.IsLive
		,cs.spositiontaking  *100
		,cs.mpositiontaking  *100
		,cs.apositiontaking  *100
		,cs.isautompositiontaking
		,cs.autompositiontaking *100
		,cs.isautopositiontaking 
		,cs.autopositiontaking  *100
		,co.minpositiontaking  *100
		,93
	FROM dbo.CustSettingGame cs WITH(NOLOCK) 
		INNER JOIN dbo.custOverrideGame co WITH(NOLOCK) ON cs.custid = co.custid and cs.sporttype = co.sporttype and cs.bettype = co.bettype
		INNER JOIN #SMATemp ci WITH(NOLOCK) ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.fBetType AND cs.sporttype = dest.fSportType
	
	--MEMBER LEVEL
	INSERT INTO dbo.CustPTSetting3rd_Member
		(	[custid]
		  ,	[sporttype]
		  ,	[bettype]
		  ,	[islive]
		  ,	[superPT]
		  ,	[masterPT]
		  ,	[agentPT]
		  ,	[IsAutoMasterPT]
		  ,	[AutoMasterPT]
		  ,	[IsAutoSuperPT]
		  ,	[AutoSuperPT])
	SELECT 
		cs.custid, dest.tsporttype, dest.tbettype, dest.IsLive
		,cs.spositiontaking  *100
		,cs.mpositiontaking  *100
		,cs.apositiontaking  *100
		,cs.isautompositiontaking
		,cs.autompositiontaking *100
		,cs.isautopositiontaking 
		,cs.autopositiontaking  *100
	FROM dbo.custSetting cs WITH(NOLOCK)
		INNER JOIN #MemberTemp ci WITH(NOLOCK) ON cs.CustID = ci.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK) ON dest.SettingType = 1 AND cs.bettype = dest.fBetType AND cs.sporttype = dest.fSportType
	
	
	INSERT INTO [dbo].[CustSettingMode3rd]
			   ([CustID]
			   ,[IsGrouped])
	SELECT custid, 0
	FROM #MemberTemp ci WITH(NOLOCK)

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
		AND cs.sporttype = 162
		AND cs.bettype = 1101
		and enabled = 1  
	
	DECLARE @apos SMALLMONEY,
			@mpos SMALLMONEY
	
	UPDATE cs
	SET minpositiontaking = 0.93
	FROM CustOverrideGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid		
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND  minpositiontaking > 0.93		
	
	UPDATE cs
	SET @apos = CASE WHEN apositiontaking > 0.93 THEN 0.93 ELSE apositiontaking END,
		apositiontaking = @apos,
		@mpos = CASE WHEN @apos + mpositiontaking > 0.93 THEN 0.93- @apos ELSE mpositiontaking END,
		mpositiontaking = @mpos,
		spositiontaking = CASE WHEN @apos + @mpos + spositiontaking > 0.93 THEN 0.93 - @mpos -@apos ELSE spositiontaking END
	FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND ci.roleid = 1
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND spositiontaking + mpositiontaking + apositiontaking > 0.93
		
	UPDATE cs
	SET @apos = CASE WHEN apositiontaking > 0.93 THEN 0.93 ELSE apositiontaking END,
		apositiontaking = @apos,
		mpositiontaking = CASE WHEN @apos + mpositiontaking > 0.93 THEN 0.93- @apos ELSE mpositiontaking END		
	FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND ci.roleid = 2
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND mpositiontaking + apositiontaking > 0.93	
	
	UPDATE cs
	SET @mpos = CASE WHEN mpositiontaking > 0.93 THEN 0.93 ELSE mpositiontaking END,
		mpositiontaking = @mpos,
		spositiontaking = CASE WHEN spositiontaking + @mpos > 0.93 THEN 0.93 - @mpos ELSE spositiontaking END 		
	FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.srecommend = @srecommend
		AND ci.custid <= @maxcustid
		AND ci.roleid = 3
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND mpositiontaking + spositiontaking > 0.93	
		
	UPDATE cs
	SET spositiontaking = CASE WHEN spositiontaking > 0.93 THEN 0.93 ELSE spositiontaking END 		
	FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
		INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
	WHERE ci.custid = @srecommend		
		AND cs.sporttype = 255
		AND cs.bettype = 1701 
		AND spositiontaking > 0.93	
		
	--adjust commission Super = [0; 0.007]	
	--correct for super level
	IF EXISTS(
			SELECT 1 
			FROM custSettingGame cs WITH(NOLOCK) 
			WHERE cs.custid = @srecommend		
				AND cs.sporttype = 255
				AND cs.bettype = 1701 
				AND cs.sdiscount > 0.007
			)
	BEGIN
		UPDATE cs
		SET cs.sdiscount = 0.007
		FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
			INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		WHERE ci.custid = @srecommend		
			AND cs.sporttype = 255
			AND cs.bettype = 1701 
			AND cs.sdiscount > 0.007
		
		UPDATE cs
		SET cs.adiscount = 0.007
		FROM  CustSettingGame cs WITH(UPDLOCK,ROWLOCK) 
			INNER JOIN custinfo ci WITH(NOLOCK) ON ci.custid = cs.custid
		WHERE ci.srecommend = @srecommend		
			AND roleid = 3
			AND ci.custid <= @maxcustid
			AND cs.sporttype = 255
			AND cs.bettype = 1701 
			AND cs.adiscount > 0.007
		
		UPDATE cs
		SET cs.discount = 0.007
		FROM dbo.CustSettingGame cs WITH(UPDLOCK, ROWLOCK)
			INNER JOIN dbo.CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		WHERE ci.srecommend = @srecommend
		   AND ci.roleid     = 2
		   AND ci.Enabled    = 1
		   AND ci.custid <= @maxcustid
		   AND bettype       = 1701
		   AND cs.sporttype  = 255
		   AND cs.discount   > 0.007
		
		UPDATE cs
		SET cs.sdiscount = 0.007
		FROM dbo.CustSettingGame cs WITH(UPDLOCK, ROWLOCK)
			INNER JOIN dbo.CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		WHERE ci.srecommend = @srecommend
		   AND ci.roleid     = 1
		   AND ci.Enabled    = 1
		   AND ci.custid <= @maxcustid
		   AND bettype       = 1701
		   AND cs.sporttype  = 255
		   AND cs.sdiscount   > 0.007
		   
		UPDATE cs
		SET cs.adiscount = cs.sdiscount
		FROM dbo.CustSettingGame cs WITH(UPDLOCK, ROWLOCK)
			INNER JOIN dbo.CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		WHERE ci.srecommend = @srecommend
		   AND ci.roleid     = 1
		   AND ci.Enabled    = 1
		   AND ci.custid <= @maxcustid
		   AND bettype       = 1701
		   AND cs.sporttype  = 255
		   AND cs.adiscount > cs.sdiscount
		
		UPDATE cs
		SET cs.discount = cs.adiscount
		FROM dbo.CustSettingGame cs WITH(UPDLOCK, ROWLOCK)
			INNER JOIN dbo.CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		WHERE ci.srecommend = @srecommend
		   AND ci.roleid     = 1
		   AND ci.Enabled    = 1
		   AND ci.custid <= @maxcustid
		   AND bettype       = 1701
		   AND cs.sporttype  = 255
		   AND cs.discount > cs.adiscount
		
		UPDATE cs
		SET cs.playerdiscount = cs.discount 
		FROM dbo.CustSettingGame cs WITH(UPDLOCK, ROWLOCK)
			INNER JOIN dbo.CustInfo ci WITH(NOLOCK) ON cs.custid = ci.custid
		WHERE ci.srecommend = @srecommend
		   AND ci.roleid     = 1
		   AND ci.Enabled    = 1
		   AND ci.custid <= @maxcustid
		   AND bettype       = 1701
		   AND cs.sporttype  = 255
		   AND cs.playerdiscount > cs.discount  
	END		
	
	DROP TABLE #tmpEnableAgent
	DROP TABLE #tmpSuperOnly
	DROP TABLE #tmpDownlineEnable		
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	



---
---
-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, DisableGoldDeluxe BIT, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT, @DisableGoldDeluxe BIT

SELECT @max_custid = xx

--disable supers list
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 1
FROM Customer ci WITH(NOLOCK)
WHERE USERname IN ('M312T','312BP','S312R','M312RR','R312R','S312C','S312RMB','S312US','S312H','S312G','R313R','S32RMB','M32RM','S32R','S32AR','S32H','S32AH','S32BH','S32CH','S32DH','M32M','S32EH','S32FH','S32GH','S32M','S32AM','S32HH','S32IH','S32JH','S32BM','S32HK','S32K','S32HKD','S32RM','S32KH','S32LH','S32CM','MGRM','SGURMB','SGM','SGR','SG1M','SGH','SG1H','SG2H','SG3H','SG5H','SG4H','SG6H','SG7H','SG8H','SG9H','SG10H','SG11H','SG12H','SG13H','SG15H','SG1R','SG16H','SG17H','SG18H','SG19H','SG20H','SG21H','SG22H','SG23H','SG2M','SG25H','SG3M','SG26H','SG27H','SG28h','sg29h','SG5M','sg30h','SG6M','SG31H','SG7M','SGGT','SG32H','SG8M','sg9m','SG1T','SG2T','SG3T','SG33H','SGRD','SG35H','SG36H','SG37H','SG38H','SG39H','SG40H','SGRP','SG41H','SG42H','SGRI','SPR','SPH','SSR','PPB','PPR','S922H','M922U','M922M','S922M','M922T','S922T','S922K','S922N','S922U','S922L','S922P','S922W','S922G','S922US','S922MA','S922Y','S922R','S922C','S922V','S922B','S922O','S922S','S922A','M39IRMB','S39R','S39RR','SKHK','SKR','SKM','SKRR','SKUS','266HK','JMRM','S35H','S35M','S35AH','S35RM','MMMRM','SBKHK','SBKRMB','SBKTB','MMPRM','SMM','SMSM','SBKH','MMSD','SBKT','SMH','SMMH','SBK','SMAH','SMMS','SMAT','SMR','MMRMB','SMMR','SMBT','SMBH','SSMS','SMCH','SMMP','MSRMB','M7RM','M7ARM','M7SD','M7RMB','M7ARMB','M7BRMB','M7BRM','S7RMB','M7ZRMB','M7CRM','M926R','HK7','1158RM','M58SD','S58RM','S58R','M12RM','S12HK','S12M','S12MM','7899HK','789R','M96RM','S96h','M318HK','M318RMB','S318U','2588RM','M258RM','2588SD','M57HK','S57R','S57H','M863HK','S863R','KM','KH','KR','KS','KT','KRC','KSD','KMM','KRR','KMA','KHH','KHK','KAR','KBR','KCR','KAM','KMAM','KMBM','KHAH','KHBH','KAT','KHCH','KDR','KER','KHT','KHDH','M28RMB','M28H','S09H','S09M','MQRM','MQARM','MQRMB','MQR','SQHH','S33M','S33E','S33R','S33C','S33AR','S33MR','S33SM','S33S','S33BR','S33CR','S33T','S33A','MPTUS','MPTRMB','MPPU','PTM','166HK','M16RMB','S80R','S80U','S80H','S5S','S5M','S5R','S5U','S5I','330GBP','W79','HIS','HIH','HIU','HAH','HIM','HIK','HIW','HIT','HIF','SMORMB','SMORM','SMOEH','SMOHK','SMOH','SMOK','SMOL','SMOM','SMON','SMOO','SMOP','SMOQ','SMOT','SMOR','SMOS','SMOA','SMOB','SMOC','SMOD','SMOCNY','SMOE','SMOU','SMOF','SMORA','MOU','MOW','SMOG','MOA','MOB','MOD','SMOKH','SMOV','SMOI','SMODH','SMOTH','SMOJ','SMOW','SMOY','SMOX','S31SD','S31ARM','SBQJ','SBQ1J','SBQ2J','SAPM','SBQ3J','SBQ5J','S31HK','S116SD','S31D','SBQ6J','S31RRM','SBQ8J','SBQ9J','S31ASD','A31BP','SBQ7J','S31BSD','SPA1M','M3CRM','SBQ4J','S31AHK','SPA2M','SPA3M','M50RM','S50RMB','S50R','A50RM','M53SD','M53HK','S53S','S53HHK','S53M','M91RMB','M91ARMB','M91CRMB','M91DRMB','S91RM','M91FRMB','M91HK','S91R','S3ARM','S3AR','S3AAR','S3AH','S3AAH','S3AK','S3AG','S3EH','S3BH','S3AB','M83RM','M83RMB','M83ARM','M83H','M98RM','M98HK','S98R','M98ZR','S98H','M98ZH','S98E','S98K','SDRM','SDSD','SDRMB','SDARM','SDR','SDH','SDHK','SDHA','SDEU','SDBP','1188RM','S188R','S188RM','S188ARM','M188SD','S188AR','S188H','S188AH','S188BH','S188US','M79BR','M79CR','79AH','79AR','S70RMB','S70M','3KHK','SOGO','SOGA','S57AR','M57AHK','M606HK','M818H','M818R','M818RA','S59BR','S989R','S989M','S989H','SORM','MK1','MK2','MK3','MK5','MK6','MK4C','TH7','MK8','MK9','MK10','MK11C','CKT','CKT1','CKT2','MKM','MK12','TH88','MKS','MK17','CK18','MKTB','MK13','CKU','MKM1','MK19','MK20','MK21','MK16','MK15','TH25','MK22','MK30','TH26','MK23','JC1','JC7','JC2','JC8','MKI','JC6','JC81','JC3','JC9','MK27','TH28','TH29','THM','JCM','JC10','TH89','MK31','MKM2','JC5','JC82','MKS1','JCH','GAX','MK32','JC83','MKH','AK1','AKM1','MK33','MK35','MKHA','HJ','HM','M113H','KYH','KYM','MKYM','M85TB','M85ATB','S85RMB','M85BTB','S85RM','M85CTB','M85DTB','S85R','S85AR','S85BR','S85RR','S85H','S85S','S85M','S85T','S85GTH','S85A','S42RM','S42H','S42AH','S42S','S42BH','S42CH','S42DH','M42M','S42ARM','S42M','S42D','YH','YHA','TWS','S88ML','S42U','S42EH','S42T','STPM','STPH','STPK','STPL','JAT','JAH','JAS','JAM','JAHA','JAU','JAHP','JAHB','JARWRONG','JAR','JAHE','JAA','S120R','S121R','S122R','S120H','S123R','S124R','S120M','S120S','DDS','BBS','BBM','MR','MRU','SBZR','SBZ','SBZB','SZ','MA','M822M','S822R','GEH','GFH','S822M','S822MA','GFJ','S822D','D5M','M81ARMB','S81R','S81RA','S81RB','SLH','SLK','SLJ','SLM','SLD','SSS','SSSD','SSSR','SSH','S23H','S23S','S23M','MLLRMB','SLLM','S95RMB','M95RM','S95H','S95AH','S95BH','S95CH','S95M','S95RM','S95DH','S95AM','PPH','PPM','SYLHK','SYLRM','SYLSD','SYLM','SYLH','SYLHZ','SYLK','SYLG','SYCN','SYLT','SYLL','SSK','SSM','SSMA','SSKA','SSKB','SSKC','SSN','SF8','S62H','S62AH','M62SD','S62M','KM6','KH6','KS6','M62H','M62R','M62AH','M62RA','m62rb','S62D','M62BH','S27RMB','S27HK','S27H','S27A','SADA','S27TK','GN','GX','GC','GL','LHH','LHU','LHM','LHI','LHM1','LHM2','LHH1','LHH2','LHH3','LHH4','LHH5','LHS ','LHH6','LHHRMB','LHR','LHH7','LHH8','LHH9','LHH10','LHH11','LHH12','LHA','LHM3','LHM5','LHM6','POR','POT','U311','POK','POY','POB','POW','KTV','KTW','POG','POM','POH','POJ','AX','AXH','AXG','FYG','AXT','AX1','AXRMB','AX3','AXA','AXHK','AX5','VVG','SVVG','87R','QQMZ','QQKR','QQKA','QQMW','QQMY','QQMA','QQKU','QQK3','QQUS','QQMR','QQMD','QQHK','QQKY','QQBS','QQKT','QQKH','QQKS','QQKV','QQTB','QQTC','QQTD','QQTE','QQTF','Pyy','PYH','PYT','PYU','PYM','PYG','PYR','PYA','MLH','MLI','TLM','TLN','D71','cks','C1','C2','C3','C5','C7','TLH','C8','C9','C10','C11','C12','C13','C15','H9','H1','JK6','C6','H2','H3','HZ','H5','CV','9H','1C','EPL','MMS','KP','H8','S1','S2','S3','S6','S7','S8','S9','S11','SR','CM','ZS','CN','JD','JG','U8','A6','R8','A1','A2','A3','A5','YUM','YUH','WPR','KPW','JGBP','XCN','BPK','EEM','EEH','EGH','EGM','ETB','MKLHK','MKLTB','1E','MLAMRM','A919HK','SA-RMB00110','SBET339','M72H','S26AH','S26M','S8T','S8R','S8U','S8KT','S8H','S8AR','S8AH','S8BR','S8BH','S8CR','RC','MHK8','MHK9','HK8','M7RRMB','A7HK','S7D','S7RR','TU1','TU2','JYT','WHT01','WHT02','WHT03','WHT04','WHT05','WHD','SMTG','GT','M8HK','M8RMB','M51SD','M51TB','TAS51S','M51RMB','S51SM','S51R','M51H','S51H','S51AH','S51BH','S51CH','S51DH','S51EH','S51HA','S51TB','M47RMB','S47SD','S47RM','M47R','S47R','S47U','S47IR','S47DR','S47H','S47M','S31M','S31MR','SS32U','SS31U','SS31K','SS31L','SS31N','SS31P','SS31G','ANY','SS31A','M63H','M63IRMB','M63IHK','S63H','M033R','M033H','SBSR','SBH','SBSU','SBS','SBM','SBU','SBHA','SBHB','SBHC','SBC','SBHD','MYM','SSF','SBHE','SBHF','SBHG','SBHJ','SBTB','SSG','WWR','WKR','MTRE','MTRU','FBR','FBM','SFB','FBH','FBB','YKH','YKR','YKM','CYKM','SBRR','HS','HSK','SBMW','M88SD','M88ASD','S88R','S88AR','S88M','S88H','S88T','M88US','S88RMB','S88K','M88M','S88US','8188BP','MMYTB','SVM','SVR','SVS','SVH','SVUS','SVP','SVE','SVA','S11S','S11MY','M73TB','S1188','SS11H','S1100','s1199','S11YY','S11M1','S11M4','S11M6','S11M8','S11N','HYY','S93RM','S93M','S93S','S93R','S97R','S100R','S101R','S93H','S97H','S93SS','S93HK','M93S','S93RRMB','S93HK1','S93D','S93P','s66h','s66s','S77AH','s66bh','s66pk','s66y','s667','s663','s664','s66m','s66b','S77X','s66a','s66c','s668','S66D','S66V','S66T','S66E','SBT','BBBU','SBBT','SBBR','SBCT','RB168','FYY','FYU','FYS','FYK','FYT','FYD','JTRIHK','JTRIEU','JTRIUSD','JTRIGBP','AHMA','A68M','A68H','REU','VKJ','VKP','VKG','AGO','AGD','BQ','AGK','AGJ','M101M'
--add LLR to disable list
,'LLR')
AND roleid = 4

--special supers list will disable
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 1
FROM Customer ci WITH(NOLOCK)
WHERE USERname IN ('9999SD','M999SD','M9999S','S999S','99HK','PHRM','MPHSD','SPK','SPKM','SPKR','M90RM','S90AR','S90RM','S90C','M797M','M797AM','SWHH','D77','D78','D79','D80','D81','D82','D83','D85','DRM','DADR','D99','2MH','2HA')
AND roleid = 4

--enable supers list
--remove 'LLR' out of enable list
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM Custinfo ci WITH(NOLOCK)
WHERE USERname IN ('M359RM','M359SD','M359EU','M359ARM','M359ASD','M359RMB','M359ARMB','S359AH','HD','HE','S359HK','S359CM','S359HL','S359RM','HF','HG','HDN','HDQ','HH','DAA','DAB','DAC','DAD','HB','DAE','DAF','HX','DAM','HN','HQ','TKRM','WBRMB','WBR','WBRR','WBRA','wbrf','WBRG','WBRH','WBRI','WBRJ','TG1','TG3','TG2','TG4','CHTB','CHITB','ST','STT','ST1T','ST2T','ST3T','ST4T','ST5T','ST6T','ST7T','ST8T','ST9T','BT','B5T','B1T','B2T','B3T','B4T','B6T','B7T','B8T','B9T','B10T','B11T','B12T','B13T','B14T','B15T','B16T','B17T','B18T','B19T','B20T','B21T','B22T','B23T','B24T','B25T','STEB','SABT','B26T','B27T','B28t','B29T','B30T','B31T','B32T','B33T','B35T','B34T','B36T','B37T','B38T','B39T','B40T','B41T','B42T','B43T','B44T','B45T','B46T','B47T','B48T','B49T','B50T','B51T','SKKM','ywrm','6599RM','SALR','SALH','MALM','MGTB','MGBTB','MGCTB','SGS','SGTB','SGATB','SGI','SGT','SGAT','SGBT','SGCT','SGAR','TEH','TEC','THR','SGSM','SGSN','TEK','SGMM','TED','THH','THS','TEG','THT','MAMRM','SMAMRMB','SAMR','M25RM','M25ARMB','M25BRMB','S25R','M25HK','S25RM','L25RM','MMYBRM','MMYBH','BYS','MBY','BYM','BYU','SI','UU','WH','UT','D8G','UK','IB','LK','JA','AS','UM','AP','SB','UN','UL','IM','AJ','JB','IN','JC','YN','CL','UA','UB','WB','IK','IJ','AN','WU','AT','ZZ','UC','LN','KK','VB','YY','UE','IF','BB','HO','HU','SL','UD','IZ','JK','HW','UW','CX','UV','AK','AZ','JN','AI','JT','UF','CY','UZ','UH','MH','AH','UG','UY','YM','TA','AQ','AD','WJ','WG','HI','BI','BJ','LI','LW','UI','II','IA','IE','IG','HP','GI','SW','DI','WI','QQ','DW','FF','TI','CI','IP','RR','IC','AW','AG','AF','CO','CU','CS','YI','JJ','IR','VV','ID','WW','MW','MM','AL','DB','SD','CJEU','M26RMB','M26ARMB','M26RM','M26SD','M26BRMB','M26ARM','S26H','M26BRM','M252RMB','M252H','SCHK','SCM','SCS','SCSM','SCH','SCAH','SCAI','SCI','SCBH','SCHI','SCDH','69SD','S69SD','S69RM','S7RM','S69R','M69U','M69H','S69H','S69RD','S69E','S69TB','S69BP','S69HD','S69RP','S56RM','S56R','S56ARM','S56BRM','S556R','S556AR','S56CRM','S56H','S56AH','S56BBH','S56CH','S56DH','S56HH','S56EH','S56DRM','S56FH','S56TB','S56GH','S56JH','S56KH','S56HK','S56T','S56TC','S56LH','S56MH','S56TH','S56TA','S56TD','S56TT','S56I','S56D','S56NH','S56PH','S56QH','s56rh','S56SH','S56KK','S56SD','S56AA','S56AB','S56AC','S56AD','S56AI','S56II','S56UH','S56VH','S56A','HKD','HKD01','HKD02','HK01','HK02','HK03','HK05','HK06','S56AE','HK07','S56ASD','HK09','HK10','HK11','S56ERM','HK12','HK13','HK15','HK16','HK17','HK18','HK19','HK20','HK21','HK22','TM01','TM02','TM03','TM04','TM05','TM06','TM07','TM08','TM09','TM10','TM11','S36RMB','S36RM','SD1R','s79rrr','S79RM','S79AR','S79R','S79H','S79AHH','S79HH','S79HK','S799H','S79SH','M79H','S79HG','S79hz','S79CR','S79HS','S79I','S79C','WD1','WD2','WD3','S79RMB','M79U','WDD','WDE','WDH','WDI','WDJ','WDK','WDL','M79V','WDR','WD','WC','WD7','S49RM','S49R','S49H','SSTMR','SSTMH','SSTMJ','SSTMM','SSTMK','SSTMI','S60RUP','S60AR','D60','E60','S16RUP','6666HK','6666BP','6666US','6666EU','M6HK','6hk6601','M6SD','6666AUD','S6EU','S6RUP','S6US','S6ARUP','M6RM','AA','BA','6666AHK','DA','6666AEU','MPH','JPG','S6H','FA','VC','S6BP','VD','VM','VF','GA','VO','GG','s6cn','VP','VQ','S6HK','S6RMB','FM','S6P','VI','VE','VA','VG','MD','S9EU','S6T','VJ','S6S','S6AHK','S88D','M553R','M553AR','M553BR','M553H','M553AH','M553BH','M553CH','M553M','M553DH','S553H','S553M','SEM','SEI','SEH','SED','SEK','SEMA','MJRMB','SJM','SJH','SJSD','SBHK','S305CRMB','S305RM','S31RM','S31RMB','S305R','S31ARMB','SSFH','SSF1H','S3H','SSF2H','SSF3H','MSFR','SSFK','S3HH','SSF5H','S31BRM','S3HK','S305M','S3HG','S3HJ','S3HP','SSF6H','SHSD','SHRMB','SHTB','SHHK','hhm','SHKK','SHHT','SHDK','SHHK1','SHHK2','SHR','SHR1','SHHK3','SHI','shhk5','SHR3','shhk6','SHR5','SHHK7','hhma','sh8','SHHK9','HHN','SHHK8','HHK1','HHK10','HHK2','HHK3','HHR','HHK4','BHJ','CFT','TT','TTA','TTB','S2R','S2T','S2AR','S2BR','S2TB','S688R','S688H','S788H','S688T','S688AH','S688M','LP','LLP','A68US','A688U','SAKH','SAKM','DKE','DKD','M8H','SWU','SWK','SWM','S2H','S2M','S2HH','S2MM','S2MN','S2HY','MRTB','MKWRM','SRRMB','SKWRMB','SRARMB','SRRH','SRR','SRH','SRHK','SRRR','SRMA','SRHKA','SRJ','SRKH','SRHH','SRMB','SRK','SRHC','SRHD','SRMC','SRQ','SMQARMB','M99RMB','S99H','S99TB','S99M','S99T','S99R','S99ah','S99HK','S99HKK','S99HKD','S99BH','S99TH','S99RMB','S999TB','S99C','S99THB','S99D','S99MHK','S99CH','S99BT','S99HA','S99TC','S99E','S99BA','S99BB','S99BC','S99BD','WKH','S45H','s45m','S45AH','S45BH','S45AM','S45BM','S45HK','KJH','KJHB','KJM','KJI','KJD','KJT','KJMB','KJK','KJE','KJB','KJC','KJF','KJMC','KJMA','KJG','KJMD','KJL','KJO','KJME','KJMF','AHM','AHN','AHI','AHO','BHO','AHP','AHQ','AHR','BHN','AHH','AHE','bhu','AHF','AHD','AHG','AHJ','AHL','AHT','AHA','AHC','AHY','AHU','AHV','BHS','AHZ','AHX','AKK','DDD','DDA','GM1','DDB','GM2','GMG','BKK','S41S','S41M','S41H','S43S','S43H','S41K','MC','MC1','MC2','MCR','MC3','MC5','LJ','LH','LU','LY','LL','LB','LC','LD','LE','LV','LF','LT','KD','KL','HA','LS','LA','LG','LM','LII','LZ','BGR','CHU','HPP','HPO','HPM','HPU','HPV','HPW','HPQ','HPK','HPN','HPX','HPY','HPMM','HPI','HPZ','HPR','HPJ','HPH','SX3','SX1','SX2','SZZ','SMY','HPC','HPD','HPE','HPA','MO','MP','HPG','HPB','HPF','HPL','SX5','MQ','SX6','HP2','MG','SX7','SX8','HTB','HPS','HPM2','HP1','HPT','HP3','SX9','HSS','HMN','SATU','SATE','SATS','SATM','JS','JS1','JM','JS2','SFH','JS3','JS5','JS6','JS7','JS8','SJS','SFHA','JS9','JSA','JSC','JSB','JSD','SYSM','SYSHK','JSR','JMA','JSE','JSQ','JSF','JSG','JST','JSH','JSK','JSL','JSM','JR','JSZ','SHG','JSN','JSP','JSU','JRA','JSV','JSW','JSX','JSY','JTH','JSO','JSI','JMJ','JHA','JHB','JMK','JML','JHC','JHH','JHJ','SAS','ASA','SAE','SAI','ASB','M71RMB','M71ARMB','M71BRMB','M71CRMB','S71RM','M71DRMB','SER','S71H','S71AH','S71M','S71BH','S71MA','S71CH','S71DH','S71MB','SCLH','SCLM','SMT','SBTM','SBTH','SBTK','SBTN','SBTD','SBTL','SBTR','SBTY','SKHH','SKMM','PKK','PKA','PKB','PKRM','PKID','PKC','PKD','PKE','PKF','MPKS','PKG','PKH','PKJ','PKL','PKM','PKO','PKP','PKQ','PKT','PKS','SSYR','SSYH','SKPRMB','KPM','WVW','SEA','SEB','SEC','S9M','S9H','XKS','SYI','SNI','S555','S666','S777','JJB','JJM','S359BH','S359M','S359CH','S359S','S359HH','S359am','S359bm','SLP','SLI','SLN','SLO','SLG','SLQ','SLW','SLB','SLL','SLR','SLT','LGA','SLY','SLS','SLE','SLF','SLV','SLU','ALR','ALM','ALH','ALA','ALB','ALC','ALD','RMB','TP','TH','TR','AC1','AC2','ACH','ACH1','ACH2','ACH3','AC3','AC4','ACH4','ACH5','ACH6','AC7','HT1','HT2','HT3','KKT','KKM','KKH','KKMA','KKS','KKB','KKC','KKD','KKE','KKJ','KKN','KKY','KKF','KKG','KKK','KKL','KKI','KKR','KAA','KAB','KGK','KGL','KGM','KGN','KGO','KGP','KAC','KGD','SRS','KAD','KGA','KGB','KAE','KAF','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAK','KAJ','KBF','XKM','XKH','VKH','VKD','FJM','SAZM','FFM','21M','21A','LLKH','LHHR','HG9','HGG','HG8','HG7','HG6','HG88','HG101','HG102','HG71','VVY','RG1','RG2','RG3','RG5','RG6','RG7','PPS','PPJ','TS1','TS2','TS3','TS4','DS1','DS2','PK','P11','P12','P13','P14','P15','P16','P17','P18','P19','P22','CTH','CTV','CTM')
AND roleid = 4
AND DisableLiveCasino = 0--enable GD for line has been enabled LCS

--special supers list will enable
--2 accounts 'S90R','S90H' will be enabled for whole line 
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM Customer ci WITH(NOLOCK)
WHERE USERname IN ('M999RM','SHK','S90R','S90H','SPHM','SQK','S797R','M797RM','S797H','S797AH','SWH','SWAH','SWSH','wm','WN','WT','SWB','SWC','SWD','SWE','SWF','SWG','SWI','SWJ','SWW','WE','S797S','SWN','WMA','SWP','SWQ','SWR','SWX','WMB','WTA','D66','S222R','S222H','S222HK','S222T','S222AH','S222BH','S222TH','S222TA','S222CH','S222DH','2EH','S222FH','S222GH','2KH','S222MH','S222NH','M222M','2AH','2BH','2HB','2CH','2DH','2LH','2ZH','2ID','2NH','2PH','2MM','2YH','2FH','2GH','2EU','2DD','2MN','2WH','S222JH','2HH','2RM','2DE','S222X','2NN','2HK','2RR','2CR','2CT','2JH','S222N','S222ZH','2XX','2WW','2CK','2RH','2IH','2BP','2QH','2OH','2SH','2AA','2AB','2AC','2MP','2MY','2MQ','2UH','SB8R','SBB','TH8','SBSD','SBV')
AND roleid = 4

--UUS currency enable by default
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM Customer ci WITH(NOLOCK)
WHERE roleid = 4
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND currency = 20
	AND site <> '789y'

--ohters will disable by default
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 1
FROM CustInfo ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.custid NOT IN (SELECT custid FROM #supers)
	AND custid <= @max_custid 
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid		
		,@DisableGoldDeluxe = DisableGoldDeluxe		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'REPLICATED'
			,@DisableGoldDeluxe = @DisableGoldDeluxe
	
	waitfor delay '00:00:0.280'
END			
GO		
-- END STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (052/053/054/06/DBTP) -----
-----------------------------------------------------------------------------------
 
 
 
---
---
-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #supers (custid int, DisableGoldDeluxe BIT, isfinished bit default(0))
DECLARE @srecommend INT, @max_custid INT, @DisableGoldDeluxe BIT

SELECT @max_custid = xx

--disable supers list
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 1
FROM Customer ci WITH(NOLOCK)
WHERE USERname IN ('M312T','312BP','S312R','M312RR','R312R','S312C','S312RMB','S312US','S312H','S312G','R313R','S32RMB','M32RM','S32R','S32AR','S32H','S32AH','S32BH','S32CH','S32DH','M32M','S32EH','S32FH','S32GH','S32M','S32AM','S32HH','S32IH','S32JH','S32BM','S32HK','S32K','S32HKD','S32RM','S32KH','S32LH','S32CM','MGRM','SGURMB','SGM','SGR','SG1M','SGH','SG1H','SG2H','SG3H','SG5H','SG4H','SG6H','SG7H','SG8H','SG9H','SG10H','SG11H','SG12H','SG13H','SG15H','SG1R','SG16H','SG17H','SG18H','SG19H','SG20H','SG21H','SG22H','SG23H','SG2M','SG25H','SG3M','SG26H','SG27H','SG28h','sg29h','SG5M','sg30h','SG6M','SG31H','SG7M','SGGT','SG32H','SG8M','sg9m','SG1T','SG2T','SG3T','SG33H','SGRD','SG35H','SG36H','SG37H','SG38H','SG39H','SG40H','SGRP','SG41H','SG42H','SGRI','SPR','SPH','SSR','PPB','PPR','S922H','M922U','M922M','S922M','M922T','S922T','S922K','S922N','S922U','S922L','S922P','S922W','S922G','S922US','S922MA','S922Y','S922R','S922C','S922V','S922B','S922O','S922S','S922A','M39IRMB','S39R','S39RR','SKHK','SKR','SKM','SKRR','SKUS','266HK','JMRM','S35H','S35M','S35AH','S35RM','MMMRM','SBKHK','SBKRMB','SBKTB','MMPRM','SMM','SMSM','SBKH','MMSD','SBKT','SMH','SMMH','SBK','SMAH','SMMS','SMAT','SMR','MMRMB','SMMR','SMBT','SMBH','SSMS','SMCH','SMMP','MSRMB','M7RM','M7ARM','M7SD','M7RMB','M7ARMB','M7BRMB','M7BRM','S7RMB','M7ZRMB','M7CRM','M926R','HK7','1158RM','M58SD','S58RM','S58R','M12RM','S12HK','S12M','S12MM','7899HK','789R','M96RM','S96h','M318HK','M318RMB','S318U','2588RM','M258RM','2588SD','M57HK','S57R','S57H','M863HK','S863R','KM','KH','KR','KS','KT','KRC','KSD','KMM','KRR','KMA','KHH','KHK','KAR','KBR','KCR','KAM','KMAM','KMBM','KHAH','KHBH','KAT','KHCH','KDR','KER','KHT','KHDH','M28RMB','M28H','S09H','S09M','MQRM','MQARM','MQRMB','MQR','SQHH','S33M','S33E','S33R','S33C','S33AR','S33MR','S33SM','S33S','S33BR','S33CR','S33T','S33A','MPTUS','MPTRMB','MPPU','PTM','166HK','M16RMB','S80R','S80U','S80H','S5S','S5M','S5R','S5U','S5I','330GBP','W79','HIS','HIH','HIU','HAH','HIM','HIK','HIW','HIT','HIF','SMORMB','SMORM','SMOEH','SMOHK','SMOH','SMOK','SMOL','SMOM','SMON','SMOO','SMOP','SMOQ','SMOT','SMOR','SMOS','SMOA','SMOB','SMOC','SMOD','SMOCNY','SMOE','SMOU','SMOF','SMORA','MOU','MOW','SMOG','MOA','MOB','MOD','SMOKH','SMOV','SMOI','SMODH','SMOTH','SMOJ','SMOW','SMOY','SMOX','S31SD','S31ARM','SBQJ','SBQ1J','SBQ2J','SAPM','SBQ3J','SBQ5J','S31HK','S116SD','S31D','SBQ6J','S31RRM','SBQ8J','SBQ9J','S31ASD','A31BP','SBQ7J','S31BSD','SPA1M','M3CRM','SBQ4J','S31AHK','SPA2M','SPA3M','M50RM','S50RMB','S50R','A50RM','M53SD','M53HK','S53S','S53HHK','S53M','M91RMB','M91ARMB','M91CRMB','M91DRMB','S91RM','M91FRMB','M91HK','S91R','S3ARM','S3AR','S3AAR','S3AH','S3AAH','S3AK','S3AG','S3EH','S3BH','S3AB','M83RM','M83RMB','M83ARM','M83H','M98RM','M98HK','S98R','M98ZR','S98H','M98ZH','S98E','S98K','SDRM','SDSD','SDRMB','SDARM','SDR','SDH','SDHK','SDHA','SDEU','SDBP','1188RM','S188R','S188RM','S188ARM','M188SD','S188AR','S188H','S188AH','S188BH','S188US','M79BR','M79CR','79AH','79AR','S70RMB','S70M','3KHK','SOGO','SOGA','S57AR','M57AHK','M606HK','M818H','M818R','M818RA','S59BR','S989R','S989M','S989H','SORM','MK1','MK2','MK3','MK5','MK6','MK4C','TH7','MK8','MK9','MK10','MK11C','CKT','CKT1','CKT2','MKM','MK12','TH88','MKS','MK17','CK18','MKTB','MK13','CKU','MKM1','MK19','MK20','MK21','MK16','MK15','TH25','MK22','MK30','TH26','MK23','JC1','JC7','JC2','JC8','MKI','JC6','JC81','JC3','JC9','MK27','TH28','TH29','THM','JCM','JC10','TH89','MK31','MKM2','JC5','JC82','MKS1','JCH','GAX','MK32','JC83','MKH','AK1','AKM1','MK33','MK35','MKHA','HJ','HM','M113H','KYH','KYM','MKYM','M85TB','M85ATB','S85RMB','M85BTB','S85RM','M85CTB','M85DTB','S85R','S85AR','S85BR','S85RR','S85H','S85S','S85M','S85T','S85GTH','S85A','S42RM','S42H','S42AH','S42S','S42BH','S42CH','S42DH','M42M','S42ARM','S42M','S42D','YH','YHA','TWS','S88ML','S42U','S42EH','S42T','STPM','STPH','STPK','STPL','JAT','JAH','JAS','JAM','JAHA','JAU','JAHP','JAHB','JARWRONG','JAR','JAHE','JAA','S120R','S121R','S122R','S120H','S123R','S124R','S120M','S120S','DDS','BBS','BBM','MR','MRU','SBZR','SBZ','SBZB','SZ','MA','M822M','S822R','GEH','GFH','S822M','S822MA','GFJ','S822D','D5M','M81ARMB','S81R','S81RA','S81RB','SLH','SLK','SLJ','SLM','SLD','SSS','SSSD','SSSR','SSH','S23H','S23S','S23M','MLLRMB','SLLM','S95RMB','M95RM','S95H','S95AH','S95BH','S95CH','S95M','S95RM','S95DH','S95AM','PPH','PPM','SYLHK','SYLRM','SYLSD','SYLM','SYLH','SYLHZ','SYLK','SYLG','SYCN','SYLT','SYLL','SSK','SSM','SSMA','SSKA','SSKB','SSKC','SSN','SF8','S62H','S62AH','M62SD','S62M','KM6','KH6','KS6','M62H','M62R','M62AH','M62RA','m62rb','S62D','M62BH','S27RMB','S27HK','S27H','S27A','SADA','S27TK','GN','GX','GC','GL','LHH','LHU','LHM','LHI','LHM1','LHM2','LHH1','LHH2','LHH3','LHH4','LHH5','LHS ','LHH6','LHHRMB','LHR','LHH7','LHH8','LHH9','LHH10','LHH11','LHH12','LHA','LHM3','LHM5','LHM6','POR','POT','U311','POK','POY','POB','POW','KTV','KTW','POG','POM','POH','POJ','AX','AXH','AXG','FYG','AXT','AX1','AXRMB','AX3','AXA','AXHK','AX5','VVG','SVVG','87R','QQMZ','QQKR','QQKA','QQMW','QQMY','QQMA','QQKU','QQK3','QQUS','QQMR','QQMD','QQHK','QQKY','QQBS','QQKT','QQKH','QQKS','QQKV','QQTB','QQTC','QQTD','QQTE','QQTF','Pyy','PYH','PYT','PYU','PYM','PYG','PYR','PYA','MLH','MLI','TLM','TLN','D71','cks','C1','C2','C3','C5','C7','TLH','C8','C9','C10','C11','C12','C13','C15','H9','H1','JK6','C6','H2','H3','HZ','H5','CV','9H','1C','EPL','MMS','KP','H8','S1','S2','S3','S6','S7','S8','S9','S11','SR','CM','ZS','CN','JD','JG','U8','A6','R8','A1','A2','A3','A5','YUM','YUH','WPR','KPW','JGBP','XCN','BPK','EEM','EEH','EGH','EGM','ETB','MKLHK','MKLTB','1E','MLAMRM','A919HK','SA-RMB00110','SBET339','M72H','S26AH','S26M','S8T','S8R','S8U','S8KT','S8H','S8AR','S8AH','S8BR','S8BH','S8CR','RC','MHK8','MHK9','HK8','M7RRMB','A7HK','S7D','S7RR','TU1','TU2','JYT','WHT01','WHT02','WHT03','WHT04','WHT05','WHD','SMTG','GT','M8HK','M8RMB','M51SD','M51TB','TAS51S','M51RMB','S51SM','S51R','M51H','S51H','S51AH','S51BH','S51CH','S51DH','S51EH','S51HA','S51TB','M47RMB','S47SD','S47RM','M47R','S47R','S47U','S47IR','S47DR','S47H','S47M','S31M','S31MR','SS32U','SS31U','SS31K','SS31L','SS31N','SS31P','SS31G','ANY','SS31A','M63H','M63IRMB','M63IHK','S63H','M033R','M033H','SBSR','SBH','SBSU','SBS','SBM','SBU','SBHA','SBHB','SBHC','SBC','SBHD','MYM','SSF','SBHE','SBHF','SBHG','SBHJ','SBTB','SSG','WWR','WKR','MTRE','MTRU','FBR','FBM','SFB','FBH','FBB','YKH','YKR','YKM','CYKM','SBRR','HS','HSK','SBMW','M88SD','M88ASD','S88R','S88AR','S88M','S88H','S88T','M88US','S88RMB','S88K','M88M','S88US','8188BP','MMYTB','SVM','SVR','SVS','SVH','SVUS','SVP','SVE','SVA','S11S','S11MY','M73TB','S1188','SS11H','S1100','s1199','S11YY','S11M1','S11M4','S11M6','S11M8','S11N','HYY','S93RM','S93M','S93S','S93R','S97R','S100R','S101R','S93H','S97H','S93SS','S93HK','M93S','S93RRMB','S93HK1','S93D','S93P','s66h','s66s','S77AH','s66bh','s66pk','s66y','s667','s663','s664','s66m','s66b','S77X','s66a','s66c','s668','S66D','S66V','S66T','S66E','SBT','BBBU','SBBT','SBBR','SBCT','RB168','FYY','FYU','FYS','FYK','FYT','FYD','JTRIHK','JTRIEU','JTRIUSD','JTRIGBP','AHMA','A68M','A68H','REU','VKJ','VKP','VKG','AGO','AGD','BQ','AGK','AGJ','M101M')
AND roleid = 4

--special supers list will disable
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 1
FROM Customer ci WITH(NOLOCK)
WHERE USERname IN ('9999SD','M999SD','M9999S','S999S','99HK','PHRM','MPHSD','SPK','SPKM','SPKR','M90RM','S90AR','S90RM','S90C','M797M','M797AM','SWHH','D77','D78','D79','D80','D81','D82','D83','D85','DRM','DADR','D99','2MH','2HA'
--add LLR to disable list
,'LLR'
)
AND roleid = 4

--enable supers list
--remove LLR out of enable list
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM Custinfo ci WITH(NOLOCK)
WHERE USERname IN ('M359RM','M359SD','M359EU','M359ARM','M359ASD','M359RMB','M359ARMB','S359AH','HD','HE','S359HK','S359CM','S359HL','S359RM','HF','HG','HDN','HDQ','HH','DAA','DAB','DAC','DAD','HB','DAE','DAF','HX','DAM','HN','HQ','TKRM','WBRMB','WBR','WBRR','WBRA','wbrf','WBRG','WBRH','WBRI','WBRJ','TG1','TG3','TG2','TG4','CHTB','CHITB','ST','STT','ST1T','ST2T','ST3T','ST4T','ST5T','ST6T','ST7T','ST8T','ST9T','BT','B5T','B1T','B2T','B3T','B4T','B6T','B7T','B8T','B9T','B10T','B11T','B12T','B13T','B14T','B15T','B16T','B17T','B18T','B19T','B20T','B21T','B22T','B23T','B24T','B25T','STEB','SABT','B26T','B27T','B28t','B29T','B30T','B31T','B32T','B33T','B35T','B34T','B36T','B37T','B38T','B39T','B40T','B41T','B42T','B43T','B44T','B45T','B46T','B47T','B48T','B49T','B50T','B51T','SKKM','ywrm','6599RM','SALR','SALH','MALM','MGTB','MGBTB','MGCTB','SGS','SGTB','SGATB','SGI','SGT','SGAT','SGBT','SGCT','SGAR','TEH','TEC','THR','SGSM','SGSN','TEK','SGMM','TED','THH','THS','TEG','THT','MAMRM','SMAMRMB','SAMR','M25RM','M25ARMB','M25BRMB','S25R','M25HK','S25RM','L25RM','MMYBRM','MMYBH','BYS','MBY','BYM','BYU','SI','UU','WH','UT','D8G','UK','IB','LK','JA','AS','UM','AP','SB','UN','UL','IM','AJ','JB','IN','JC','YN','CL','UA','UB','WB','IK','IJ','AN','WU','AT','ZZ','UC','LN','KK','VB','YY','UE','IF','BB','HO','HU','SL','UD','IZ','JK','HW','UW','CX','UV','AK','AZ','JN','AI','JT','UF','CY','UZ','UH','MH','AH','UG','UY','YM','TA','AQ','AD','WJ','WG','HI','BI','BJ','LI','LW','UI','II','IA','IE','IG','HP','GI','SW','DI','WI','QQ','DW','FF','TI','CI','IP','RR','IC','AW','AG','AF','CO','CU','CS','YI','JJ','IR','VV','ID','WW','MW','MM','AL','DB','SD','CJEU','M26RMB','M26ARMB','M26RM','M26SD','M26BRMB','M26ARM','S26H','M26BRM','M252RMB','M252H','SCHK','SCM','SCS','SCSM','SCH','SCAH','SCAI','SCI','SCBH','SCHI','SCDH','69SD','S69SD','S69RM','S7RM','S69R','M69U','M69H','S69H','S69RD','S69E','S69TB','S69BP','S69HD','S69RP','S56RM','S56R','S56ARM','S56BRM','S556R','S556AR','S56CRM','S56H','S56AH','S56BBH','S56CH','S56DH','S56HH','S56EH','S56DRM','S56FH','S56TB','S56GH','S56JH','S56KH','S56HK','S56T','S56TC','S56LH','S56MH','S56TH','S56TA','S56TD','S56TT','S56I','S56D','S56NH','S56PH','S56QH','s56rh','S56SH','S56KK','S56SD','S56AA','S56AB','S56AC','S56AD','S56AI','S56II','S56UH','S56VH','S56A','HKD','HKD01','HKD02','HK01','HK02','HK03','HK05','HK06','S56AE','HK07','S56ASD','HK09','HK10','HK11','S56ERM','HK12','HK13','HK15','HK16','HK17','HK18','HK19','HK20','HK21','HK22','TM01','TM02','TM03','TM04','TM05','TM06','TM07','TM08','TM09','TM10','TM11','S36RMB','S36RM','SD1R','s79rrr','S79RM','S79AR','S79R','S79H','S79AHH','S79HH','S79HK','S799H','S79SH','M79H','S79HG','S79hz','S79CR','S79HS','S79I','S79C','WD1','WD2','WD3','S79RMB','M79U','WDD','WDE','WDH','WDI','WDJ','WDK','WDL','M79V','WDR','WD','WC','WD7','S49RM','S49R','S49H','SSTMR','SSTMH','SSTMJ','SSTMM','SSTMK','SSTMI','S60RUP','S60AR','D60','E60','S16RUP','6666HK','6666BP','6666US','6666EU','M6HK','6hk6601','M6SD','6666AUD','S6EU','S6RUP','S6US','S6ARUP','M6RM','AA','BA','6666AHK','DA','6666AEU','MPH','JPG','S6H','FA','VC','S6BP','VD','VM','VF','GA','VO','GG','s6cn','VP','VQ','S6HK','S6RMB','FM','S6P','VI','VE','VA','VG','MD','S9EU','S6T','VJ','S6S','S6AHK','S88D','M553R','M553AR','M553BR','M553H','M553AH','M553BH','M553CH','M553M','M553DH','S553H','S553M','SEM','SEI','SEH','SED','SEK','SEMA','MJRMB','SJM','SJH','SJSD','SBHK','S305CRMB','S305RM','S31RM','S31RMB','S305R','S31ARMB','SSFH','SSF1H','S3H','SSF2H','SSF3H','MSFR','SSFK','S3HH','SSF5H','S31BRM','S3HK','S305M','S3HG','S3HJ','S3HP','SSF6H','SHSD','SHRMB','SHTB','SHHK','hhm','SHKK','SHHT','SHDK','SHHK1','SHHK2','SHR','SHR1','SHHK3','SHI','shhk5','SHR3','shhk6','SHR5','SHHK7','hhma','sh8','SHHK9','HHN','SHHK8','HHK1','HHK10','HHK2','HHK3','HHR','HHK4','BHJ','CFT','TT','TTA','TTB','S2R','S2T','S2AR','S2BR','S2TB','S688R','S688H','S788H','S688T','S688AH','S688M','LP','LLP','A68US','A688U','SAKH','SAKM','DKE','DKD','M8H','SWU','SWK','SWM','S2H','S2M','S2HH','S2MM','S2MN','S2HY','MRTB','MKWRM','SRRMB','SKWRMB','SRARMB','SRRH','SRR','SRH','SRHK','SRRR','SRMA','SRHKA','SRJ','SRKH','SRHH','SRMB','SRK','SRHC','SRHD','SRMC','SRQ','SMQARMB','M99RMB','S99H','S99TB','S99M','S99T','S99R','S99ah','S99HK','S99HKK','S99HKD','S99BH','S99TH','S99RMB','S999TB','S99C','S99THB','S99D','S99MHK','S99CH','S99BT','S99HA','S99TC','S99E','S99BA','S99BB','S99BC','S99BD','WKH','S45H','s45m','S45AH','S45BH','S45AM','S45BM','S45HK','KJH','KJHB','KJM','KJI','KJD','KJT','KJMB','KJK','KJE','KJB','KJC','KJF','KJMC','KJMA','KJG','KJMD','KJL','KJO','KJME','KJMF','AHM','AHN','AHI','AHO','BHO','AHP','AHQ','AHR','BHN','AHH','AHE','bhu','AHF','AHD','AHG','AHJ','AHL','AHT','AHA','AHC','AHY','AHU','AHV','BHS','AHZ','AHX','AKK','DDD','DDA','GM1','DDB','GM2','GMG','BKK','S41S','S41M','S41H','S43S','S43H','S41K','MC','MC1','MC2','MCR','MC3','MC5','LJ','LH','LU','LY','LL','LB','LC','LD','LE','LV','LF','LT','KD','KL','HA','LS','LA','LG','LM','LII','LZ','BGR','CHU','HPP','HPO','HPM','HPU','HPV','HPW','HPQ','HPK','HPN','HPX','HPY','HPMM','HPI','HPZ','HPR','HPJ','HPH','SX3','SX1','SX2','SZZ','SMY','HPC','HPD','HPE','HPA','MO','MP','HPG','HPB','HPF','HPL','SX5','MQ','SX6','HP2','MG','SX7','SX8','HTB','HPS','HPM2','HP1','HPT','HP3','SX9','HSS','HMN','SATU','SATE','SATS','SATM','JS','JS1','JM','JS2','SFH','JS3','JS5','JS6','JS7','JS8','SJS','SFHA','JS9','JSA','JSC','JSB','JSD','SYSM','SYSHK','JSR','JMA','JSE','JSQ','JSF','JSG','JST','JSH','JSK','JSL','JSM','JR','JSZ','SHG','JSN','JSP','JSU','JRA','JSV','JSW','JSX','JSY','JTH','JSO','JSI','JMJ','JHA','JHB','JMK','JML','JHC','JHH','JHJ','SAS','ASA','SAE','SAI','ASB','M71RMB','M71ARMB','M71BRMB','M71CRMB','S71RM','M71DRMB','SER','S71H','S71AH','S71M','S71BH','S71MA','S71CH','S71DH','S71MB','SCLH','SCLM','SMT','SBTM','SBTH','SBTK','SBTN','SBTD','SBTL','SBTR','SBTY','SKHH','SKMM','PKK','PKA','PKB','PKRM','PKID','PKC','PKD','PKE','PKF','MPKS','PKG','PKH','PKJ','PKL','PKM','PKO','PKP','PKQ','PKT','PKS','SSYR','SSYH','SKPRMB','KPM','WVW','SEA','SEB','SEC','S9M','S9H','XKS','SYI','SNI','S555','S666','S777','JJB','JJM','S359BH','S359M','S359CH','S359S','S359HH','S359am','S359bm','SLP','SLI','SLN','SLO','SLG','SLQ','SLW','SLB','SLL','SLR','SLT','LGA','SLY','SLS','SLE','SLF','SLV','SLU','ALR','ALM','ALH','ALA','ALB','ALC','ALD','RMB','TP','TH','TR','AC1','AC2','ACH','ACH1','ACH2','ACH3','AC3','AC4','ACH4','ACH5','ACH6','AC7','HT1','HT2','HT3','KKT','KKM','KKH','KKMA','KKS','KKB','KKC','KKD','KKE','KKJ','KKN','KKY','KKF','KKG','KKK','KKL','KKI','KKR','KAA','KAB','KGK','KGL','KGM','KGN','KGO','KGP','KAC','KGD','SRS','KAD','KGA','KGB','KAE','KAF','KBA','KBB','KBC','KGE','KBD','KBE','KAG','KAH','KAK','KAJ','KBF','XKM','XKH','VKH','VKD','FJM','SAZM','FFM','21M','21A','LLKH','LHHR','HG9','HGG','HG8','HG7','HG6','HG88','HG101','HG102','HG71','VVY','RG1','RG2','RG3','RG5','RG6','RG7','PPS','PPJ','TS1','TS2','TS3','TS4','DS1','DS2','PK','P11','P12','P13','P14','P15','P16','P17','P18','P19','P22','CTH','CTV','CTM')
AND roleid = 4
AND DisableLiveCasino = 0--enable GD for line has been enabled LCS

--special supers list will enable
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM Customer ci WITH(NOLOCK)
WHERE USERname IN ('M999RM','SHK','SPHM','S90R','S90H','SQK','S797R','M797RM','S797H','S797AH','SWH','SWAH','SWSH','wm','WN','WT','SWB','SWC','SWD','SWE','SWF','SWG','SWI','SWJ','SWW','WE','S797S','SWN','WMA','SWP','SWQ','SWR','SWX','WMB','WTA','D66','S222R','S222H','S222HK','S222T','S222AH','S222BH','S222TH','S222TA','S222CH','S222DH','2EH','S222FH','S222GH','2KH','S222MH','S222NH','M222M','2AH','2BH','2HB','2CH','2DH','2LH','2ZH','2ID','2NH','2PH','2MM','2YH','2FH','2GH','2EU','2DD','2MN','2WH','S222JH','2HH','2RM','2DE','S222X','2NN','2HK','2RR','2CR','2CT','2JH','S222N','S222ZH','2XX','2WW','2CK','2RH','2IH','2BP','2QH','2OH','2SH','2AA','2AB','2AC','2MP','2MY','2MQ','2UH','SB8R','SBB','TH8','SBSD','SBV')
AND roleid = 4

--UUS currency enable by default
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 0
FROM CustInfo ci WITH(NOLOCK)
WHERE roleid = 4
	AND custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND currency = 20

--ohters will disable by default
INSERT INTO #supers(custid, DisableGoldDeluxe)
SELECT ci.custid, 1
FROM CustInfo ci WITH(NOLOCK)
WHERE ci.roleid = 4 	
	AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
	AND ci.custid NOT IN (SELECT custid FROM #supers)
	AND custid <= @max_custid 
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@srecommend = custid		
		,@DisableGoldDeluxe = DisableGoldDeluxe		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	EXEC dbo.[Acc_ExecRep_Cust_09] @srecommend = @srecommend
			,@maxcustid = @max_custid
			,@target = 'DBCUST'
			,@DisableGoldDeluxe = @DisableGoldDeluxe
	
	waitfor delay '00:00:0.280'
END			
GO		

-- END STEP 3: RUN THIS SCRIPT AT DBCUST -----
-----------------------------------------------------------------------------------