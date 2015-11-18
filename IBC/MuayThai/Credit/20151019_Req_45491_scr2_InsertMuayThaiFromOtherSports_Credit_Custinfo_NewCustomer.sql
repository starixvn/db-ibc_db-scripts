/*
	Created: Dominic
	Date: 2015-10-15
	Task: Initialize Product Status of MuayThai for Newly created Credit customers
			(In UM)
	DB: DBCust.CustDB
*/   
	DECLARE @max_custid INT

	SELECT @max_custid = xxx
	--Default status
	DECLARE @IsDisabled BIT = 0, @IsHidden BIT = 0, @IsSync BIT = 1, @DefaultBitMap BINARY(32) = 0x00

	CREATE TABLE #DestinationSportBetType(tSportType SMALLINT, tBetType SMALLINT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(44	,3) --Product Status

	CREATE TABLE #CustomerTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
	)
	
	INSERT #CustomerTemp(CustID)
	SELECT CustID
	FROM dbo.CustInfo WITH(NOLOCK)
	WHERE srecommend NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND CustID > @max_custid

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


	/*******************************CUST PRODUCTSTATUS TABLE*******************************/	
	INSERT INTO [dbo].[CustProductStatus]
           ([CustID], bitmapHasSynced, bitmapIsHidden, bitmapIsDisabled)
    SELECT custid
			,(select bitmap from dbo.f_GenerateProductStatus_multiple (@DefaultBitMap, @xmlSync))
			,(select bitmap from dbo.f_GenerateProductStatus_multiple (@DefaultBitMap, @xmlHidden))
			,(select bitmap from dbo.f_GenerateProductStatus_multiple (@DefaultBitMap, @xmlDisabled))
	FROM #CustomerTemp ci WITH(NOLOCK)

	DROP TABLE #CustomerTemp
	DROP TABLE #DestinationSportBetType