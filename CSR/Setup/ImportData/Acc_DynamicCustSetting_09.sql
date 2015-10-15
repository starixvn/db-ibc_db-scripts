ALTER PROCEDURE Acc_DynamicCustSetting_09
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN   
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustSetting') = 1
	   AND dbo.f_CheckRepTable('custOverride') = 1 
	   AND dbo.f_CheckRepTable('CustProductStatus') = 1
	   AND dbo.f_CheckRepTable('CustBetSetting3rd_Member') = 1
	   AND dbo.f_CheckRepTable('CustBetSetting3rd_Agent') = 1
	   AND dbo.f_CheckRepTable('CustPTSetting3rd_Member') = 1
	   AND dbo.f_CheckRepTable('CustPTSetting3rd_Agent') = 1
	   )
	  RETURN
	
	--Default status
	DECLARE @IsDisabled BIT = 0, @IsHidden BIT = 0, @IsSync BIT = 1, @DefaultBitMap BINARY(32) = 0x00

	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(99, 3, 44	,3, 0, 1), --PT
	(99, 20,44	,20,0, 1), --PT
	(99, 3, 44	,3, 0, 2), --Bet Limit
	(44, 3, 44	,3, 0, 4) --Product Status


	DECLARE @xmlDisabled VARCHAR(MAX)
	SET @xmlDisabled = CAST( (
			SELECT (
					SELECT dic.bitmapOrder	AS '@b'
						, @IsDisabled	AS '@s'
					FROM #DestinationSportBetType tmp
						INNER JOIN ProductStatusProfile dic 
								ON tmp.tSporttype = dic.SportType 
								AND tmp.tBettype = dic.BetType
					WHERE tmp.SettingType = 4
					FOR XML PATH('r')
						, TYPE
					)
			FOR XML PATH('root')
				, TYPE
			) AS VARCHAR(MAX))
			
	DECLARE @xmlHidden VARCHAR(MAX)
	SET @xmlHidden = CAST((
			SELECT (
					SELECT dic.bitmapOrder	AS '@b'
						, @IsHidden	AS '@s'
					FROM #DestinationSportBetType tmp
						INNER JOIN ProductStatusProfile dic 
								ON tmp.tSporttype = dic.SportType 
								AND tmp.tBettype = dic.BetType
					WHERE tmp.SettingType = 4
					FOR XML PATH('r')
						, TYPE
					)
			FOR XML PATH('root')
				, TYPE
			) AS VARCHAR(MAX))
			
	DECLARE @xmlSync VARCHAR(MAX)
	SET @xmlSync = CAST((
			SELECT (
					SELECT dic.bitmapOrder	AS '@b'
						, @IsSync	AS '@s'
					FROM #DestinationSportBetType tmp
						INNER JOIN ProductStatusProfile dic 
								ON tmp.tSporttype = dic.SportType 
								AND tmp.tBettype = dic.BetType
					WHERE tmp.SettingType = 4
					FOR XML PATH('r')
						, TYPE
					)
			FOR XML PATH('root')
				, TYPE
			) AS VARCHAR(MAX))
				
	/*****************************POSITION TAKING**************************/
	--AGENT LEVEL
	INSERT INTO dbo.CustPTSetting3rd_Agent
		([CustID]
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
		cs.custid,dest.tsporttype,dest.tbettype,dest.IsLive
		,cs.spositiontaking  *100
		,cs.mpositiontaking  *100
		,cs.apositiontaking  *100
		,cs.isautompositiontaking
		,cs.autompositiontaking *100
		,cs.isautopositiontaking 
		,cs.autopositiontaking  *100
		,co.minpositiontaking  *100
		,co.maxpositiontaking  *100
	FROM dbo.CustSetting cs WITH(NOLOCK) 
		INNER JOIN dbo.custOverride co WITH(NOLOCK) 
			ON cs.custid = co.custid and cs.sporttype = co.sporttype and cs.bettype = co.bettype
		INNER JOIN dbo.custInfo ci WITH(NOLOCK) 
			ON ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 1
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
	WHERE ci.roleid IN (2,3,4) AND ci.srecommend = @srecommend AND  ci.custid <= @maxcustid
	
	
	--MEMBER LEVEL
	INSERT INTO dbo.CustPTSetting3rd_Member
			([custid]
		  ,[sporttype]
		  ,[bettype]
		  ,[islive]
		  ,[superPT]
		  ,[masterPT]
		  ,[agentPT]
		  ,[IsAutoMasterPT]
		  ,[AutoMasterPT]
		  ,[IsAutoSuperPT]
		  ,[AutoSuperPT])
	SELECT 
		cs.custid,dest.tsporttype,dest.tbettype,dest.IsLive
		,cs.spositiontaking  *100
		,cs.mpositiontaking  *100
		,cs.apositiontaking  *100
		,cs.isautompositiontaking
		,cs.autompositiontaking *100
		,cs.isautopositiontaking 
		,cs.autopositiontaking  *100
	FROM dbo.custSetting cs WITH(NOLOCK)
		INNER JOIN custInfo ci WITH(NOLOCK) ON cs.CustID = ci.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 1
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
	WHERE ci.roleid = 1 AND ci.srecommend = @srecommend AND  ci.custid <= @maxcustid 
		
	
	/*****************************BET LIMIT SETTING**************************/	
	--Agent Level
	INSERT INTO dbo.CustBetSetting3rd_Agent
	SELECT cs.custid,dest.tsporttype,dest.tbettype,cs.minbet,cs.maxbet,ci.maxpermatch
	FROM dbo.CustSetting cs WITH(NOLOCK)
		INNER JOIN dbo.custInfo ci WITH(NOLOCK) 
			ON  ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 2
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
	 WHERE ci.srecommend = @srecommend AND  ci.custid <= @maxcustid AND ci.roleid IN (2,3,4)

	 
	--Member Level
	INSERT INTO dbo.CustBetSetting3rd_Member
	SELECT cs.custid,dest.tsporttype,dest.tbettype,cs.minbet,cs.maxbet,ci.maxpermatch
	FROM dbo.CustSetting cs WITH(NOLOCK)
		INNER JOIN dbo.custInfo ci WITH(NOLOCK) 
			ON  ci.custid = cs.custid
		INNER JOIN #DestinationSportBetType dest WITH(NOLOCK)
			ON dest.SettingType = 2
				AND cs.bettype = dest.fBetType
				AND cs.sporttype = dest.fSportType
	 WHERE ci.srecommend = @srecommend AND  ci.custid <= @maxcustid AND ci.roleid = 1


	/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
	INSERT INTO [dbo].[CustProductStatus]
           ([CustID], bitmapHasSynced, bitmapIsHidden, bitmapIsDisabled)
    SELECT custid
			,(select bitmap from dbo.f_GenerateProductStatus_multiple (@DefaultBitMap, @xmlSync))
			,(select bitmap from dbo.f_GenerateProductStatus_multiple (@DefaultBitMap, @xmlHidden))
			,(select bitmap from dbo.f_GenerateProductStatus_multiple (@DefaultBitMap, @xmlDisabled))
	FROM dbo.custInfo ci WITH(NOLOCK)
	WHERE ci.srecommend = @srecommend AND  ci.custid <= @maxcustid

END