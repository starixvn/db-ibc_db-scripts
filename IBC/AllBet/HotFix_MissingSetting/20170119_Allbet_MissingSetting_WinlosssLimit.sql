/*
	Created: 20170208@Helen
	Task: Missing Allbet setting - [Redmine:68644]
	DB: DBCUST/CUSTDB
*/

CREATE TABLE #cust_missingsetting (custid INT, Roleid INT,currency INT, srecommend INT, mrecommend INT, recommend INT)

INSERT INTO #cust_missingsetting (custid,Roleid,currency,srecommend,mrecommend,recommend)
SELECT custid,Roleid,currency,srecommend,mrecommend,recommend
FROM custInfo CI WITH (NOLOCK)
WHERE CI.custid IN (1)

DECLARE @ProductID INT = 21, @SportType SMALLINT = 211, @Bettype SMALLINT = 2401, @IsLive BIT = 0
/********************************************* SMA WinLimit : SettingType = 6 ****************************************/
-- @RoleID = 4
--MaxWinLimit: 0 (Unlimited)
--MaxLossLimit: get from global setting based on currency
--IsAutoReset: 1		
INSERT INTO [dbo].[CustWinLossLimit_Agent]
   ([CustID]
   ,[SportType]
   ,[BetType]
   ,[MaxWinLimit]
   ,[MaxLossLimit]
   ,[IsAutoReset])
SELECT
	ft.custid
	,@SportType
	,@Bettype
	,0
	,gs.DefaultLossLimit
	,1
FROM #cust_missingsetting ft 
	INNER JOIN LossLimit_GlobalSetting gs WITH (NOLOCK) ON gs.ProductId = @ProductID AND gs.ExchangeId = ft.currency
WHERE ft.Roleid = 4
--@RoleID = 3
--MaxWinLimit: super.MaxWinLimit
--MaxLossLimit: super.MaxLossLimit
--IsAutoReset: super.IsAutoReset
INSERT INTO [dbo].[CustWinLossLimit_Agent]
	([CustID]
	,[SportType]
	,[BetType]
	,[MaxWinLimit]
	,[MaxLossLimit]
	,[IsAutoReset])
SELECT	ft.custid
	,cs.SportType
	,cs.BetType
	,cs.MaxWinLimit
	,cs.MaxLossLimit
	,cs.IsAutoReset
FROM #cust_missingsetting ft  
	INNER JOIN dbo.CustWinLossLimit_Agent cs WITH (NOLOCK) ON cs.CustId = ft.srecommend AND cs.SportType = @SportType AND cs.BetType = @Bettype
WHERE ft.Roleid = 3

-- @RoleID = 2
--MaxWinLimit: master.MaxWinLimit
--MaxLossLimit: master.MaxLossLimit
--IsAutoReset: master.IsAutoReset
INSERT INTO [dbo].[CustWinLossLimit_Agent]
	([CustID]
	,[SportType]
	,[BetType]
	,[MaxWinLimit]
	,[MaxLossLimit]
	,[IsAutoReset])
SELECT
	ft.custid
	,cs.SportType
	,cs.BetType
	,cs.MaxWinLimit
	,cs.MaxLossLimit
	,cs.IsAutoReset
FROM #cust_missingsetting ft  
	INNER JOIN dbo.CustWinLossLimit_Agent cs WITH (NOLOCK) ON cs.CustId = ft.mrecommend AND cs.SportType = @SportType AND cs.BetType = @Bettype
WHERE ft.Roleid = 2

-- @Roleid = 1
--MaxWinLimit: agent.MaxWinLimit
--MaxLossLimit: agent.MaxLossLimit
--IsAutoReset: agent.IsAutoReset
INSERT INTO [dbo].[CustWinLossLimit_Member]
	([CustID]
	,[SportType]
	,[BetType]
	,[MaxWinLimit]
	,[MaxLossLimit]
	,[IsAutoReset])
SELECT
	ft.custid
	,cs.SportType
	,cs.BetType
	,cs.MaxWinLimit
	,cs.MaxLossLimit
	,cs.IsAutoReset
FROM #cust_missingsetting ft  
	INNER JOIN dbo.CustWinLossLimit_Agent cs WITH (NOLOCK) ON cs.CustId = ft.recommend AND cs.SportType = @SportType AND cs.BetType = @Bettype
WHERE ft.Roleid = 1

DROP TABLE #cust_missingsetting