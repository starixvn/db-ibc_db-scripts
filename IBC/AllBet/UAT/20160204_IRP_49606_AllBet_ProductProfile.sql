/*
	Created: 20160204@Elodie
	Task: Insert new data to [ProductSettingDetail] & [ProductStatusProfile] table for AllBet
	DB: DBCUST/CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------
USE CustDB
GO

DECLARE @SettingStatus TINYINT, @ProductID INT, @MaxPT TINYINT, @MaxDiscount DECIMAL(9,8), @IsSync BIT, @IsHidden BIT, @IsDisabled BIT
SELECT @SettingStatus = 1 --0: Production, 1: UAT, 2: Hide
SELECT @ProductID = 21
SELECT @MaxPT = 93
SELECT @MaxDiscount = 0.0070
SELECT @IsSync = 1
SELECT @IsHidden = 0
SELECT @IsDisabled = 0


INSERT INTO	dbo.ProductSettingDetail
		(	SettingType, SportType, BetType, IsLive, ProductID	, MaxPT	, MaxDiscount	, IsSync	, IsHidden	, IsDisabled	, SettingLevel, DisplayOrder, SettingStatus)
VALUES	(	1          , 211      , 2401   , 0     , @ProductID	, @MaxPT, NULL			, NULL		, NULL		, NULL			, 2           , 3           , @SettingStatus)
	,	(	3          , 211      , 2401   , 0     , @ProductID	, NULL	, @MaxDiscount  , NULL		, NULL		, NULL			, 2           , 2           , @SettingStatus)
	,	(	4          , 211      , 2401   , 0     , @ProductID	, NULL	, NULL			, @IsSync	, @IsHidden	, @IsDisabled   , 2           , 1           , @SettingStatus)
	,	(	6          , 211      , 2401   , 0     , @ProductID	, NULL	, NULL			, NULL		, NULL		, NULL			, 2           , 4           , @SettingStatus)
	,	(	7          , 211      , 2401   , 0     , @ProductID	, NULL	, NULL			, NULL		, NULL		, NULL			, 4           , 5           , @SettingStatus)
	,	(	7          , 211      , 2402   , 0     , @ProductID	, NULL	, NULL			, NULL		, NULL		, NULL			, 4           , 5           , @SettingStatus)

-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------
USE CustDB
GO

INSERT INTO	dbo.ProductStatusProfile(Sporttype, Bettype, bitmapOrder)
VALUES	(211, 2401, 4)
GO

INSERT INTO LossLimit_GlobalSetting(ProductId, ExchangeId, MinLossLimit, DefaultLossLimit)
SELECT 21,20,1,1000

GO
INSERT INTO dbo.SettingSystem
        ( SystemID ,
          SystemName ,
          Description ,
          SystemPrefix
        )
VALUES  ( 5 , -- SystemID - tinyint
          'External NAP' , -- SystemName - varchar(50)
          'Use for updating Bet Setting on External NAP' , -- Description - varchar(100)
          'ENAP'  -- SystemPrefix - varchar(10)
        )

GO
INSERT INTO dbo.ProductSettingSystemDisplay
        ( SystemID ,
          ProductID ,
          SettingType ,
          DisplayMode
        )
SELECT 5,21,1,3
UNION ALL 
SELECT 5,21,3,3
UNION ALL 
SELECT 5,21,4,3
UNION ALL 
SELECT 5,21,6,3

SELECT * FROM ProductSettingDetail WHERE ProductID = 21
SELECT * FROM ProductStatusProfile 
SELECT * FROM LossLimit_GlobalSetting WHERE ProductID = 21
SELECT * FROM dbo.SettingSystem
SELECT *  FROM dbo.ProductSettingSystemDisplay

--DELETE FROM ProductSettingDetail WHERE ProductID = 21
--DELETE FROM ProductStatusProfile WHERE Sporttype = 211
--DELETE FROM LossLimit_GlobalSetting WHERE ProductID = 21



