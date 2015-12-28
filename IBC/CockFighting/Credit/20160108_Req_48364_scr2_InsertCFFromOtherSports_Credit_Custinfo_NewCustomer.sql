/*
	Created: Dominic
	Date: 2015-11-25
	Task: Initialize Product Status of CockFighting for Newly created Credit customers (Not under 789y)
			(In UM)
	DB: DBCust.CustDB
*/   
	DECLARE @max_custid INT
	
	SELECT @max_custid = xxx
	
	CREATE TABLE #supers (custid int)
	
	INSERT INTO #supers(custid)
	SELECT ci.custid
	FROM dbo.Customer ci WITH(NOLOCK)
	WHERE ci.roleid = 4 	
		AND ci.custid NOT IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK))
		AND ci.custid > @max_custid 
		AND ci.site <> '789y'

	
	--Default status
	DECLARE @IsDisabled BIT = 1, @IsHidden BIT = 1, @IsSync BIT = 1

	CREATE TABLE #DestinationSportBetType(tSportType SMALLINT, tBetType SMALLINT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(206	,1003) --Product Status

	CREATE TABLE #CustomerTemp
	(
		CustID INT PRIMARY KEY CLUSTERED
	)
	
	
	INSERT #CustomerTemp(CustID)
	SELECT CustID
	FROM dbo.customer WITH(NOLOCK)
	WHERE srecommend IN (SELECT CustID FROM #supers)
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
	UPDATE cs
    SET
			bitmapHasSynced = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapHasSynced, @xmlSync)),
			bitmapIsHidden = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, @xmlHidden)),
			bitmapIsDisabled = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsDisabled, @xmlDisabled))
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
		INNER JOIN #CustomerTemp ci WITH(NOLOCK) ON ci.CustID = cs.CustID
		
	DROP TABLE #CustomerTemp
	DROP TABLE #DestinationSportBetType