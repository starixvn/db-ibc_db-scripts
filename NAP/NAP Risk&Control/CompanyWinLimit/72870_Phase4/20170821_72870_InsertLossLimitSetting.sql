/*
	Created: 20170821@Helen
	Task: CWL - SETTING - PHASE 4 - [redmine:72870]
	DB: DBCUST/CUSTDB
	
	--DELETE  FROM WinLimit_ProductSettingDetail WHERE LevelID IN (101,102)
*/
DECLARE @productID INT, @GroupID INT

CREATE TABLE #CurrencySetting (ProductID INT, Grey MONEY, Black MONEY, IsFinished BIT DEFAULT (0))
CREATE TABLE #CurrencySetting_Allbet (ProductID INT, GroupID INT,Grey MONEY, Black MONEY,IsFinished BIT DEFAULT (0))

--------------------------------------- For Products have only one group setting ------------------------------------------
INSERT INTO #CurrencySetting (ProductID,Grey, Black)
VALUES
	(12,-100000,-300000),
	(13,-100000,-300000),
	(8,-100000,-300000),
	(5,-100000,-300000),
	(3,-100000,-300000),
	(27,-100000,-300000),
	(28,-100000,-300000),
	(24,-10000,-30000),
	(22,-10000,-30000),
	(17,-10000,-30000),
	(6,-10000,-30000)

WHILE 1=1
BEGIN
	UPDATE TOP (1) #CurrencySetting
	SET isfinished = 1
		,@productID = ProductID
		
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

	-- Grey Level setting
	INSERT INTO WinLimit_ProductSettingDetail (ProductID,GroupID,ExchangeID,SiteID,LevelID,MaxWinLimit_RM,IsBlockedPlaceBet,IsBlockedTransfer, MaxWinLimit)
	SELECT psd.ProductID,psd.GroupID,psd.ExchangeID,psd.SiteID,101, CS.Grey,0 IsBlockedPlaceBet,0 IsBlockedTransfer
		, CASE WHEN psd.ExchangeID = 20 THEN CS.Grey ELSE ROUND(CS.Grey / e.actualrate,2) END  
	FROM WinLimit_ProductSettingDetail psd WITH (NOLOCK)
		INNER JOIN #CurrencySetting CS WITH (NOLOCK) ON psd.ProductID = cs.ProductID
		INNER JOIN Exchange e WITH (NOLOCK)  ON e.ExchangeId = psd.ExchangeID  
	WHERE LevelID = 1 AND psd.ProductID = @productID
	
	-- Black Level Setting
	INSERT INTO WinLimit_ProductSettingDetail (ProductID,GroupID,ExchangeID,SiteID,LevelID,MaxWinLimit_RM,IsBlockedPlaceBet,IsBlockedTransfer, MaxWinLimit)
	SELECT psd.ProductID,psd.GroupID,psd.ExchangeID,psd.SiteID,102, CS.Black,0 IsBlockedPlaceBet,0 IsBlockedTransfer
		, CASE WHEN psd.ExchangeID = 20 THEN CS.Black ELSE ROUND(CS.Black / e.actualrate,2) END  
	FROM WinLimit_ProductSettingDetail psd WITH (NOLOCK)
		INNER JOIN #CurrencySetting CS WITH (NOLOCK) ON psd.ProductID = cs.ProductID
		INNER JOIN Exchange e WITH (NOLOCK)  ON e.ExchangeId = psd.ExchangeID  
	WHERE LevelID = 1 AND psd.ProductID = @productID
	

END
-------------------------------------------- For Products have multiple groups: Allbet ----------------------------------------------------
-- GroupID: 8 - VIP
INSERT INTO #CurrencySetting_Allbet (ProductID,GroupID,Grey,Black)
VALUES 
	(21,8,-200000,-500000)
	,(21,9,-100000,-300000)

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #CurrencySetting_Allbet
	SET isfinished = 1
		,@productID = ProductID
		,@GroupID = GroupID
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	-- Grey Setting
	INSERT INTO WinLimit_ProductSettingDetail (ProductID,GroupID,ExchangeID,SiteID,LevelID,MaxWinLimit_RM,IsBlockedPlaceBet,IsBlockedTransfer, MaxWinLimit)
	SELECT psd.ProductID,@GroupID,psd.ExchangeID,psd.SiteID,101, Grey,0 IsBlockedPlaceBet,0 IsBlockedTransfer
		, CASE WHEN psd.ExchangeID = 20 THEN Grey ELSE ROUND(Grey / e.actualrate,2) END 
	FROM WinLimit_ProductSettingDetail psd WITH (NOLOCK)
		INNER JOIN Exchange e WITH (NOLOCK)  ON e.ExchangeId = psd.ExchangeID  
		INNER JOIN #CurrencySetting_Allbet CSA WITH (NOLOCK) ON CSA.ProductID = PSD.ProductID AND CSA.GroupID = PSD.GroupID
	WHERE LevelID = 1 AND psd.ProductID = @productID AND psd.GroupID = @GroupID
	
	-- Black Setting
	INSERT INTO WinLimit_ProductSettingDetail (ProductID,GroupID,ExchangeID,SiteID,LevelID,MaxWinLimit_RM,IsBlockedPlaceBet,IsBlockedTransfer, MaxWinLimit)
	SELECT psd.ProductID,@GroupID,psd.ExchangeID,psd.SiteID,102, Black,0 IsBlockedPlaceBet,0 IsBlockedTransfer
		, CASE WHEN psd.ExchangeID = 20 THEN Black ELSE ROUND(Black / e.actualrate,2) END 
	FROM WinLimit_ProductSettingDetail psd WITH (NOLOCK)
		INNER JOIN Exchange e WITH (NOLOCK)  ON e.ExchangeId = psd.ExchangeID  
		INNER JOIN #CurrencySetting_Allbet CSA WITH (NOLOCK) ON CSA.ProductID = PSD.ProductID AND CSA.GroupID = PSD.GroupID
	WHERE LevelID = 1 AND psd.ProductID = @productID AND psd.GroupID = @GroupID

END

DROP TABLE #CurrencySetting

DROP TABLE #CurrencySetting_Allbet
