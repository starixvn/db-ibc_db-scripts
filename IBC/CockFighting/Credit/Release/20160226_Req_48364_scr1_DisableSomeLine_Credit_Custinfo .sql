/*
	Created: Dominic
	Date: 2016-02-26
	Task: Disable CF for some dedicated lines
	DB: DBCust.CustDB
*/   
-- BEGIN STEP 1: DEPLOY THIS SP @DBCUST.CustDB ------
------------------------------------------------------
ALTER PROCEDURE Acc_DynamicCustomerInfo_09
	@CustID INT	
	,@RoleID INT
	,@target VARCHAR(30)
AS
BEGIN   
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustProductStatus') = 1
	   AND dbo.f_CheckRepTable('ProductStatusProfile') = 1
	   )
	  RETURN
	
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


	/*******************************CUST PRODUCTSTATUS TABLE*******************************/
	IF @RoleID = 4
	BEGIN	
		UPDATE cs
		SET
				bitmapHasSynced = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapHasSynced, @xmlSync)),
				bitmapIsHidden = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, @xmlHidden)),
				bitmapIsDisabled = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsDisabled, @xmlDisabled))
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
			INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
		WHERE ci.srecommend = @CustID
	END
	ELSE IF @RoleID = 3
	BEGIN
		UPDATE cs
		SET
				bitmapHasSynced = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapHasSynced, @xmlSync)),
				bitmapIsHidden = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, @xmlHidden)),
				bitmapIsDisabled = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsDisabled, @xmlDisabled))
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
			INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
		WHERE ci.mrecommend = @CustID
	END
	ELSE IF @RoleID = 2
	BEGIN
		UPDATE cs
		SET
				bitmapHasSynced = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapHasSynced, @xmlSync)),
				bitmapIsHidden = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsHidden, @xmlHidden)),
				bitmapIsDisabled = (select bitmap from dbo.f_GenerateProductStatus_multiple (bitmapIsDisabled, @xmlDisabled))
		FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
			INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
		WHERE ci.recommend = @CustID
	END

END

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #Customer (custid int,roleid int, isfinished bit default(0))

DECLARE @CustID INT,@RoleID INT

INSERT INTO #Customer(custid,RoleID)
VALUES
(xxx,xxx),
(xxx,xxx)
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Customer
	SET isfinished = 1
		,@CustID = custid
		,@RoleID = 	RoleID
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @CustID = @CustID
			,@RoleID = @RoleID
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #Customer (custid int,roleid int, isfinished bit default(0))

DECLARE @CustID INT,@RoleID INT

INSERT INTO #Customer(custid,RoleID)
VALUES
(xxx,xxx),
(xxx,xxx)
	
WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Customer
	SET isfinished = 1
		,@CustID = custid
		,@RoleID = 	RoleID
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 @CustID = @CustID
			,@RoleID = @RoleID
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.280'
END