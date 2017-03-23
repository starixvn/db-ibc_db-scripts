
/*
	Created: Winnie 
	Task: Insert for 4 ACC (113125,10818,490221,3607) and dummies don't have direct acc
	DB: DBCUST/CustDB
	Date: 20170322
*/ 

DECLARE @Sporttype INT, @Bettype INT, @SporttypeRef INT, @BettypeRef INT,@MaxPT TINYINT,@ProductID INT

SELECT @Sporttype = 219, @Bettype = 1011, @SporttypeRef = 161,@BettypeRef=85,@ProductID=24
SELECT @MaxPT= MaxPT from ProductSettingDetail WITH(NOLOCK) where SportType=@Sporttype and BetType=@Bettype and SettingType=1
DECLARE @BitOrder INT
SELECT @BitOrder= bitmapOrder from ProductStatusProfile WITH(NOLOCK) where SportType=@Sporttype
CREATE TABLE #CustTemp
	(
		CustID INT PRIMARY KEY CLUSTERED,
		RoleID INT	
	)


INSERT INTO #CustTemp (CustID,RoleID)
select ci.custid,ci.roleid from custinfo c with(nolock)
 inner join customer ci with(nolock) on c.custid=ci.custid
 where c.srecommend <=71
 and Enabled=1
 and c.currency not in (20,72)
 and c.roleid in (2,3,4)
 and site <>'KING119'
	-------------------------------------
	--------------------------------------WinLossLimit-------------------------------------------------

	
	INSERT INTO CustWinLossLimit_Agent(CustId, SportType, BetType,MaxWinLimit, MaxLossLimit, IsAutoReset)
	SELECT si.custid, @Sporttype, @Bettype
		, 0 AS MaxWinLimit	
		, (SELECT ISNULL(DefaultLossLimit,0) FROM LossLimit_GlobalSetting WITH (NOLOCK) WHERE ProductId = @ProductID AND ExchangeId = si.currency)AS MaxLossLimit 
		, 1 IsAutoReset
	FROM Customer si WITH (NOLOCK) 	
	INNER JOIN #CustTemp c ON si.custid=c.CustID
	WHERE NOT EXISTS(SELECT 1 FROM CustWinLossLimit_Agent ca WITH(NOLOCK) WHERE SportType=@Sporttype AND si.CustId=ca.CustId)

	--PT
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
		si.CustID, @Sporttype, @Bettype, 0		
		,@MaxPT
		,@MaxPT
		,@MaxPT
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #CustTemp si WHERE RoleID=4
	AND NOT EXISTS(SELECT 1 FROM CustPTSetting3rd_Agent ca WITH(NOLOCK) WHERE SportType=@Sporttype AND si.CustId=ca.CustId)

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
		si.CustID,  @Sporttype, @Bettype, 0
		,0
		,@MaxPT
		,0
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #CustTemp si WHERE RoleID=3
	AND NOT EXISTS(SELECT 1 FROM CustPTSetting3rd_Agent ca WITH(NOLOCK) WHERE SportType=@Sporttype AND si.CustId=ca.CustId)
	
	--Agent LEVEL
	--direct agent
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
		si.custid, @Sporttype, @Bettype, 0
		,0
		,0
		, @MaxPT
		,0
		,0
		,0
		,0
		,0
		,@MaxPT
	FROM #CustTemp si WITH(NOLOCK) WHERE si.RoleID=2
	AND NOT EXISTS(SELECT 1 FROM CustPTSetting3rd_Agent ca WITH(NOLOCK) WHERE SportType=@Sporttype AND si.CustId=ca.CustId)
	----UnHide and Enable
	UPDATE cs
	SET								
		 bitmapIsDisabled =  dbo.f_GenerateProductStatus (cs.bitmapIsDisabled, @BitOrder,0)
		 ,bitmapIsHidden =  dbo.f_GenerateProductStatus (cs.bitmapIsHidden,@BitOrder,0)
	FROM [dbo].[CustProductStatus] cs WITH(ROWLOCK,UPDLOCK)	
	WHERE cs.CustID IN(SELECT custid FROM #CustTemp)

	DROP TABLE #CustTemp
