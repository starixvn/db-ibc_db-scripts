/*
	Created: Winnie
	Task: Insert setting for agent R312R0280 [RedmineID: 72759]
	DB: DBCUST/CustDB
	Date: 20170323
*/ 
	SET NOCOUNT ON	

	DECLARE @DefaultLossLimit MONEY,@Sporttype INT,@Bettype INT,@MaxPT TINYINT,@SporttypeRef INT,@BettypeRef INT,@BitOrder INT
	DECLARE @ProductID INT
	SELECT @ProductID=24
	SELECT @DefaultLossLimit = ISNULL(DefaultLossLimit,0)
	FROM LossLimit_GlobalSetting WITH (NOLOCK)
	WHERE ProductId = @ProductID AND ExchangeId = 13
	SELECT @Sporttype=219
	SELECT @Bettype=1011
	SELECT @MaxPT= MaxPT from ProductSettingDetail WITH(NOLOCK) where SportType=@Sporttype and BetType=@Bettype and SettingType=1
	SELECT @SporttypeRef=161
	SELECT @BettypeRef=85

	SELECT @BitOrder= bitmapOrder from ProductStatusProfile WITH(NOLOCK) where SportType=@Sporttype
	--------------------------------------WinLossLimit-------------------------------------------------
	
	--SuperLevel
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT 25440298, @Sporttype, @Bettype
		, 0 AS MaxWinLimit	
		, @DefaultLossLimit AS MaxLossLimit 
		, 1 IsAutoReset
	
	--------------------------------------PT-------------------------------------------------	
	
	--Master AGENT LEVEL
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
		25440298, @Sporttype, @Bettype, 0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,0
		,@MaxPT

	----UnHide and Enable
	UPDATE cs
	SET								
		 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled, @BitOrder,0)
		 ,bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden,@BitOrder,0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	WHERE cs.CustID=25440298
	
	

