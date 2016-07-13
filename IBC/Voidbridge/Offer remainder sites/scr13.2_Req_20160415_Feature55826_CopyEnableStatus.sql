/*
	Created: Elodie	
	Task: Initialize Product Status of Voidbridge for Credit customers
	DB: DBCUST/CustDB
	Date: 20160301
*/ 
ALTER PROCEDURE [dbo].[Acc_DynamicCustomerInfo_09]
	@Custid INT
	,@roleid TINYINT
	,@srecommend INT
	,@mrecommend INT	
	,@Mode BIT	
	,@target VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at dbtrans only
	
	IF NOT (dbo.f_CheckRepTable('Custinfo') = 1 
	   AND dbo.f_CheckRepTable('CustProductStatus') = 1
	   AND dbo.f_CheckRepTable('ProductSettingDetail') = 1
	   AND dbo.f_CheckRepTable('ProductStatusProfile') = 1
	   )
		RETURN	

	/*******************************CUST PRODUCT STATUS TABLE*******************************/	
	IF @Mode = 1
	BEGIN
		IF @roleid = 4
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.srecommend = @Custid
		END
		ELSE IF @roleid = 3
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.mrecommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend
		END
		ELSE IF @roleid = 2
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.recommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend OR ci.custid = @mrecommend
		END
	END

	IF @Mode = 0
	BEGIN
		IF @roleid = 4
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.srecommend = @Custid
		END
		ELSE IF @roleid = 3
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.mrecommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend
		END
		ELSE IF @roleid = 2
		BEGIN
			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.recommend = @Custid

			UPDATE cs
			SET bitmapIsDisabled = CASE WHEN ci.SyncCasino = 1 AND ci.DisableCasino = 0 THEN dbo.f_GenerateProductStatus(bitmapIsDisabled, 5, 0) ELSE bitmapIsDisabled END
			FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)
				INNER JOIN dbo.custInfo ci WITH(NOLOCK) ON cs.CustID = ci.CustID
			WHERE ci.custid = @srecommend OR ci.custid = @mrecommend
		END
	END
END
GO
-- END STEP 1: DEPLOY THIS SP @DBCUST.CustDB --------
------------------------------------------------------	

-- BEGIN STEP 2: RUN THIS SCRIPT AT ALL REPLICATED SERVERS (06/DBTP) -----
--------------------------------------------------------------------------------------
CREATE TABLE #Cust (custid int, srecommend INT, mrecommend INT, roleid TINYINT, Mode BIT, isfinished bit default(0)) --Mode 0: depend on disable OneRNG, 1: enable all

DECLARE @custid int, @srecommend INT, @mrecommend INT, @roleid TINYINT, @Mode BIT

INSERT INTO #Cust(custid, srecommend, mrecommend, roleid, Mode)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.roleid, 1 AS mode
FROM customer ci WITH(NOLOCK)
WHERE ci.username IN ('TKRM','ywrm','MMYBH','BYS','MBY','BYM','BYU','CJEU','MPTUS','MPPU','69SD','S69SD','S69RM','S7RM','M69U','M69H','S69E','S69BP','S69M','M51SD','TAS51S',
						'S51SM','S51R','M51H','S51AH','S51BH','S51CH','S51DH','S51EH','M47RMB','S47SD','S47RM','6666HK','6666BP','6666EU','M6HK','6hk6601','M6SD','S6EU','S6US',
						'M6RM','6666AHK','MPH','JPG','S6H','S6BP','S9EU','BR1','SOGO','SOGA','SEM','SJSD','SHRMB','S2R','SAKH','DKE','DKD','SWU','S42RM','S42S','S42BH','S42DH',
						'S42M','YH','YHA','TWS','S42K','JAH','JAS','JAHA','JAU','JAHE','M99RMB','S99HKD','S99RMB','FN1','FN2','FN3','FN4','FN5','FN6','FN7','FN8','FN9','FN10',
						'NK1','NK2','NK3','NK4','NK5','NK6','NK7','NK8','NK9','NK10','G33M','G99MK','GMK9','FN11','FN12','S45AM','KMK','KA','SATU','SATE','SATS','JS','JS1','JS2',
						'SFH','JS3','SJS','SFHA','JS9','JSA','JSC','JSD','JSH','JSK','JQ','JZ','JX','JW','S359S','SLU','KKS','KAA','KGP','KGD','JK6','MMS','S8','S11','A68M','A68H',
						'21M','DKS','A7HK','MHK9')

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Cust
	SET isfinished = 1
		,@custid = custid	
		,@srecommend = srecommend	
		,@mrecommend = mrecommend
		,@roleid = roleid
		,@Mode = Mode
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 
			@custid = @custid			
			,@srecommend = @srecommend
			,@mrecommend = @mrecommend
			,@roleid = @roleid
			,@Mode = @Mode
			,@target = 'REPLICATED'
			
			
	waitfor delay '00:00:0.280'
END

-- BEGIN STEP 3: RUN THIS SCRIPT AT DBCUST -----
--------------------------------------------------------------------------------------
CREATE TABLE #Cust (custid int, srecommend INT, mrecommend INT, roleid TINYINT, Mode BIT, isfinished bit default(0)) --Mode 0: depend on disable OneRNG, 1: enable all

DECLARE @custid int, @srecommend INT, @mrecommend INT, @roleid TINYINT, @Mode BIT

INSERT INTO #Cust(custid, srecommend, mrecommend, roleid, Mode)
SELECT ci.custid, ci.srecommend, ci.mrecommend, ci.roleid, 1 AS mode
FROM customer ci WITH(NOLOCK)
WHERE ci.username IN ('TKRM','ywrm','MMYBH','BYS','MBY','BYM','BYU','CJEU','MPTUS','MPPU','69SD','S69SD','S69RM','S7RM','M69U','M69H','S69E','S69BP','S69M','M51SD','TAS51S',
						'S51SM','S51R','M51H','S51AH','S51BH','S51CH','S51DH','S51EH','M47RMB','S47SD','S47RM','6666HK','6666BP','6666EU','M6HK','6hk6601','M6SD','S6EU','S6US',
						'M6RM','6666AHK','MPH','JPG','S6H','S6BP','S9EU','BR1','SOGO','SOGA','SEM','SJSD','SHRMB','S2R','SAKH','DKE','DKD','SWU','S42RM','S42S','S42BH','S42DH',
						'S42M','YH','YHA','TWS','S42K','JAH','JAS','JAHA','JAU','JAHE','M99RMB','S99HKD','S99RMB','FN1','FN2','FN3','FN4','FN5','FN6','FN7','FN8','FN9','FN10',
						'NK1','NK2','NK3','NK4','NK5','NK6','NK7','NK8','NK9','NK10','G33M','G99MK','GMK9','FN11','FN12','S45AM','KMK','KA','SATU','SATE','SATS','JS','JS1','JS2',
						'SFH','JS3','SJS','SFHA','JS9','JSA','JSC','JSD','JSH','JSK','JQ','JZ','JX','JW','S359S','SLU','KKS','KAA','KGP','KGD','JK6','MMS','S8','S11','A68M','A68H',
						'21M','DKS','A7HK','MHK9')

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Cust
	SET isfinished = 1
		,@custid = custid	
		,@srecommend = srecommend	
		,@mrecommend = mrecommend
		,@roleid = roleid
		,@Mode = Mode
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
			
	EXEC dbo.Acc_DynamicCustomerInfo_09 
			@custid = @custid			
			,@srecommend = @srecommend
			,@mrecommend = @mrecommend
			,@roleid = @roleid
			,@Mode = @Mode
			,@target = 'DBCUST'
			
			
	waitfor delay '00:00:0.280'
END