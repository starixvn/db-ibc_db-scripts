/*
	Created By: Dominic
	Created Date: 20160112
	Task: Enable CF Product
	Database:DBCust/CustDB 
*/

-- ********************** Step 1: Enable CF Profile ****************
	UPDATE ProductSettingDetail 
	SET SettingStatus = 0
	WHERE ProductID = 19 -- Cock Fighting

	
-- *********************** Step 2: Disable CF for real currency customers *************	
	
	--Default status
	DECLARE @IsDisabled BIT = 1, @IsHidden BIT = 1, @IsSync BIT = 1

	CREATE TABLE #DestinationSportBetType(tSportType SMALLINT, tBetType SMALLINT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(206	,1003) --Product Status


	DECLARE @xmlDisabled VARCHAR(MAX)
	SET @xmlDisabled = CAST( (
			SELECT (
					SELECT dic.bitmapOrder	AS '@b'
						, @IsDisabled	AS '@s'
					FROM #DestinationSportBetType tmp
						INNER JOIN ProductStatusProfile dic 
								ON tmp.tSporttype = dic.SportType 
								AND tmp.tBettype = dic.BetType
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
					FOR XML PATH('r')
						, TYPE
					)
			FOR XML PATH('root')
				, TYPE
			) AS VARCHAR(MAX))


	--Get a list of real customers to disabled CF
	SELECT stt.CustID
	INTO #tmpCustID
	FROM dbo.CustProductStatus stt with(nolock)
	INNER JOIN custInfo ci with(nolock) ON stt.CustID = ci.custid
	WHERE (substring(bitmapIsDisabled, 1+((2-1)/8), 1) & POWER(2, (2-1)%8) = 0 
			OR substring(bitmapIsHidden, 1+((2-1)/8), 1) & POWER(2, (2-1)%8) = 0)
	and ci.currency <> 20
	and ci.CustID > 20546150 --Maxcustid

	--Update product status of CF
	UPDATE cs
    SET
			bitmapHasSynced = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapHasSynced, @xmlSync)),
			bitmapIsHidden = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, @xmlHidden)),
			bitmapIsDisabled = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsDisabled, @xmlDisabled))
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
	WHERE CustID IN (SELECT CustID FROM #tmpCustID)