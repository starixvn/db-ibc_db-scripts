/*
	Created: 20170206@Elodie
	Task : Update SyncStatus of Macau Game for THAUS headline
	DB:  DBCUST/CustDB
*/

USE CustDB
GO

--SELECT * from custAccount with (Nolock)
--where custid = 11746260 -- THAUS

SELECT ca.custid, 0 AS isfinished
INTO #super
FROM custAccount ca with (Nolock)
	INNER JOIN custInfo ci with (Nolock) on ci.custid = ca.custid
WHERE groupID = 515 AND roleid = 4
	AND ca.custid IN (18271733)

--SELECT * FROM #UnSyncSuper
DECLARE @CustID INT, @S4 TINYINT, @M4 TINYINT, @A4 TINYINT, @N4 TINYINT, @XML XML, @String VARCHAR(MAX)
DECLARE @ErrCode INT, @MsgType INT, @ErrMsg	NVARCHAR(4000), @UserID INT, @IP VARCHAR(15), @Currency INT, @ProductID INT = 22, @SportType SMALLINT = 212, @Bettype SMALLINT = 4001
DECLARE @StakeLevelList VARCHAR(200) = ''
SELECT @UserID = 10278938, @IP = '202.78.231.3'

CREATE TABLE	#SportBetTypeFilter (
					SportType		SMALLINT
				,	BetType			INT
				)

INSERT INTO #SportBetTypeFilter(SportType, BetType)
SELECT	fcssbtss.SportType, fcssbtss.Bettype
FROM	dbo.f_CustSetting_SportBetTypeSettingSelect(@ProductID, 8) AS fcssbtss;

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #super
	SET isfinished = 1
		,@CustID = custid			
	WHERE isfinished = 0

	IF @@ROWCOUNT = 0 BREAK

	SELECT @Currency = currency FROM dbo.custInfo WITH (NOLOCK) WHERE custid = @CustID

	--Update PT
	SET @xml = (
			SELECT 
					(           
						SELECT  SportType	AS '@SportType',
								BetType		AS '@BetType',
								IsLive		AS '@IsLive',
								SuperPT		AS '@SuperPT',
								MasterPT	AS '@MasterPT',
								AgentPT		AS '@AgentPT',
								MinPT		AS '@MinPT'
						FROM    CustPTSetting3rd_Agent cs WITH(NOLOCK)
						WHERE   custid = @custid AND cs.SportType = @SportType AND cs.BetType = @Bettype AND cs.IsLive = 0
						FOR XML PATH('PT'), 
						TYPE
					)
			FOR XML PATH('ROOT'), 
			TYPE		
			)
	
	SELECT @String = CONVERT(VARCHAR(MAX), @xml)

	EXEC Acc_CustSetting_SuperPTUpd_UAT2 @CustID = @CustID, @PT = @String, @UserID = @UserID, @IP = @IP, @ErrCode = @ErrCode OUTPUT, @MsgType = @MsgType OUTPUT, @ErrMsg = @ErrMsg OUTPUT

	--Update Comm
	SET @xml = (
			SELECT 
					(           
						SELECT  SportType	AS '@SportType',
								BetType		AS '@BetType',
								Discount	AS '@Discount'
						FROM    dbo.CustDiscount3rd_Agent cs WITH(NOLOCK)
						WHERE   custid = @custid AND cs.SportType = @SportType AND cs.BetType = @Bettype
						FOR XML PATH('Discount'), 
						TYPE
					)
			FOR XML PATH('ROOT'), 
			TYPE		
			)
	SELECT @String = CONVERT(VARCHAR(MAX), @xml)
	EXEC Acc_CustSetting_DiscountUpd @CustID = @CustID, @Discount = @String, @UserID = @UserID, @IP = @IP, @ErrCode = @ErrCode OUTPUT, @MsgType = @MsgType OUTPUT, @ErrMsg = @ErrMsg OUTPUT

	--Update StakeLevel
	CREATE TABLE	#CustStakeLevel (
						SportType			SMALLINT
					,	BetType				INT
					,	StakeLevelID		INT
					,	StakeLevelGroupID	INT
					,	isChecked			BIT
					,	PRIMARY KEY CLUSTERED (SportType, BetType, StakeLevelID)
					)

	INSERT INTO	#CustStakeLevel(SportType, BetType, StakeLevelID, StakeLevelGroupID, isChecked)
	SELECT	sbtf.SportType, sbtf.BetType, sl.StakeLevelID, sl.GameGroupID   , 0
	FROM		dbo.StakeLevel AS sl WITH(NOLOCK)
		INNER JOIN	#SportBetTypeFilter AS sbtf ON sbtf.BetType = sl.GameTypeID
	WHERE	sl.ExchangeId = @Currency;

	WITH ccsl AS (
		SELECT csla.SportType, csla.BetType, CAST(ss.val AS INT) AS StakeLevelID
		FROM		dbo.CustStakeLevel_Agent AS csla WITH(NOLOCK)
		CROSS APPLY	dbo.strSplit(ISNULL(csla.StakeLevelList, ''), ',') AS ss
		WHERE	csla.CustID = @CustID
	)
	UPDATE	csl
	SET		csl.isChecked = 1
	FROM	#CustStakeLevel AS csl
	INNER JOIN	ccsl
			ON	ccsl.SportType = csl.SportType
			AND	ccsl.BetType = csl.BetType
			AND	ccsl.StakeLevelID = csl.StakeLevelID
	
	SELECT @StakeLevelList = ''

	SELECT @StakeLevelList = @StakeLevelList + CASE WHEN @StakeLevelList = '' THEN '' ELSE ',' END +  +CONVERT(VARCHAR(200),StakeLevelID)
	FROM #CustStakeLevel
	WHERE isChecked = 1 AND BetType = @Bettype

	SET @xml = (
		SELECT 
				(           
					SELECT  @SportType	AS '@SportType',
							@Bettype	AS '@BetType',
							@StakeLevelList AS '@StakeLevelList'
					FOR XML PATH('StakeLevel'), 
					TYPE
				)
		FOR XML PATH('ROOT'), 
		TYPE		
		)

	SELECT @String = CONVERT(VARCHAR(MAX), @xml)
	EXEC Acc_CustSetting_StakeLevelUpd @CustID = @CustID, @StakeLevel = @String, @UserID = @UserID, @IP = @IP, @ErrCode = @ErrCode OUTPUT, @MsgType = @MsgType OUTPUT, @ErrMsg = @ErrMsg OUTPUT

	--Update WinLossLimit
	SET @xml = (
				SELECT 
						(           
							SELECT	wl.SportType AS '@SportType',
									wl.BetType AS '@BetType',
									CAST(MaxWinLimit AS VARCHAR(20)) AS '@MaxWinLimit',
									CAST(MaxLossLimit AS VARCHAR(20))AS '@MaxLossLimit',
									IsAutoReset						AS '@IsAutoReset'
							FROM CustWinLossLimit_Agent wl WITH (NOLOCK)
								INNER JOIN LossLimit_GlobalSetting gs WITH (NOLOCK) ON gs.ProductId = @ProductID AND gs.ExchangeId = @Currency
							WHERE wl.CustId = @CustID AND wl.SportType = @SportType AND wl.BetType = @Bettype
							FOR XML PATH('WinLossLimit'), 
							TYPE
						)
				FOR XML PATH('ROOT'), 
				TYPE		
				)
	SELECT @String = CONVERT(VARCHAR(MAX), @xml)
	EXEC Acc_CustSetting_WinLossLimitUpd @CustID = @CustID, @Limit = @String, @UserID = @UserID, @IP = @IP, @ErrCode = @ErrCode OUTPUT, @MsgType = @MsgType OUTPUT, @ErrMsg = @ErrMsg OUTPUT
	
	--Update Sync Status
	EXEC Acc_CustSetting_SyncStatusUpd @CustID = @CustID, @IsSynced = 1, @ProductID = @ProductID, @UserID = @UserID, @IP = @IP

	DROP TABLE #CustStakeLevel

	waitfor delay '00:00:0.180'
END

DROP TABLE #SportBetTypeFilter



