ALTER PROCEDURE Acc_DynamicCustomerInfo_09
	@srecommend INT	
	,@maxcustid INT
	,@target VARCHAR(20)
AS
BEGIN   
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustProductStatus') = 1
	   )
	  RETURN
	
	--Default status
	DECLARE @IsDisabled BIT = 0, @IsHidden BIT = 0, @IsSync BIT = 1, @DefaultBitMap BINARY(32) = 0x00

	CREATE TABLE #DestinationSportBetType(tSportType SMALLINT, tBetType SMALLINT)
	INSERT INTO #DestinationSportBetType
	VALUES
	(44	,3) --Product Status


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
	FROM dbo.custInfo ci WITH(NOLOCK)
	WHERE ci.srecommend = @srecommend AND  ci.custid <= @maxcustid

END