/*
	Description: A Script to import settings in DCS for Muay Thai. This script is only used to import 2 line of UUS account as below:
				- STAFF 1338545 
				- supertestuat6 19235084
	Creator: Dominic@20151021
	Run at : DBCUST.CustDB
*/

-- ***********       STEP 1 : Delete existing data in DCS      ***********
	TRUNCATE TABLE dbo.CustSettingMode3rd
	TRUNCATE TABLE dbo.CustProductStatus
	TRUNCATE TABLE dbo.CustBetSetting3rd_Member
	TRUNCATE TABLE dbo.CustBetSetting3rd_Agent
	TRUNCATE TABLE dbo.CustPTSetting3rd_Member
	TRUNCATE TABLE dbo.CustPTSetting3rd_Agent
	TRUNCATE TABLE dbo.CustPTGroupSetting3rd_Member

-- ***********        Step 2: Import new settings in DCS        ***********
	DECLARE @srecommend INT	,@maxcustid INT

	CREATE TABLE #supers (custid int,isfinished bit)
	INSERT INTO #supers
	SELECT 1338545,0
	UNION ALL
	SELECT 19235084,0

	CREATE TABLE #GroupPTMeber(CustID INT, AgentID INT, SuperID INT)
	INSERT INTO #GroupPTMeber
	SELECT MAX(CustID),recommend, srecommend
	FROM CustInfo ci WITH(NOLOCK)
	WHERE ci.srecommend IN (1338545, 19235084) AND ci.RoleID = 1
	GROUP BY recommend, srecommend

	SELECT @maxcustid = MAX(CustID)
	FROM CustInfo ci WITH(NOLOCK)


	--Default status
	DECLARE @IsDisabled BIT = 0, @IsHidden BIT = 0, @IsSync BIT = 1, @DefaultBitMap BINARY(32) = 0x00

	CREATE TABLE #DestinationSportBetType(fSportType SMALLINT, fBetType SMALLINT,tSportType SMALLINT, tBetType SMALLINT, IsLive BIT,  SettingType INT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(99, 3, 44	,3, 0, 1), --PT
	(99, 1, 44	,1, 0, 1), --PT
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

	WHILE (1 = 1)
	BEGIN
		UPDATE TOP (1) #Supers
		SET isfinished = 1
			,@srecommend = custid	
		WHERE isfinished = 0		
		
		IF @@ROWCOUNT = 0 BREAK
		
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
		
		INSERT INTO [dbo].[CustPTGroupSetting3rd_Member]
           ([AgentID]
           ,[SportType]
           ,[BetType]
           ,[IsLive]
           ,[SuperPT]
           ,[MasterPT]
           ,[AgentPT]
           ,[IsAutoMasterPT]
           ,[AutoMasterPT]
           ,[IsAutoSuperPT]
           ,[AutoSuperPT])
		SELECT tmp.AgentID, mem.SportType, mem.BetType
				, mem.IsLive, mem.SuperPT, mem.MasterPT, mem.AgentPT
				, mem.IsAutoMasterPT, mem.AutoMasterPT, mem.IsAutoSuperPT, mem.AutoSuperPT
		FROM #GroupPTMeber tmp WITH(NOLOCK)
		INNER JOIN dbo.CustPTSetting3rd_Member mem WITH(NOLOCK)
			ON tmp.CustID = mem.CustID
		WHERE tmp.SuperID = @srecommend

			

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
		
		/*******************************CUSTSETTING MODE TABLE*******************************/
		INSERT INTO [dbo].[CustSettingMode3rd]
				   ([CustID]
				   ,[IsGrouped])
		SELECT custid,0
		FROM dbo.custInfo ci WITH(NOLOCK)
		WHERE ci.srecommend = @srecommend AND  ci.custid <= @maxcustid AND  ci.roleid = 1

	END