/*
	Created: Dominic
	Date: 2015-12-31
	Task: Insert Master Data for Cricket: dbo.ProductSettingDetail, dbo.ProductBetSetting, dbo.SettingSystem Redmine #49689
	DB: Run at DBCust.CustDB
*/  
USE [CustDB]
Go

INSERT INTO [CustDB].[dbo].[ProductSettingDetail]
           ([SettingType]
           ,[SportType]
           ,[BetType]
           ,[IsLive]
           ,[ProductID]
           ,[MaxPT]
           ,[MaxDiscount]
           ,[IsSync]
           ,[IsHidden]
           ,[IsDisabled]
           ,[SettingLevel]
           ,[DisplayOrder]
           ,[SettingStatus])
     VALUES
			--PT
           (1 --<SettingType, smallint,>
           ,50 --<SportType, smallint,>
           ,501 --<BetType, smallint,>
           ,0 --<IsLive, bit,>
           ,20 --<ProductID, tinyint,>
           ,94 --<MaxPT, tinyint,>
           ,NULL --<MaxDiscount, decimal(9,8),>
           ,NULL --<IsSync, bit,>
           ,NULL --<IsHidden, bit,>
           ,NULL --<IsDisabled, bit,>
           ,3 --<SettingLevel, tinyint,>
           ,4 --<DisplayOrder, tinyint,>
           ,1),
           
           (1 --<SettingType, smallint,>
           ,50 --<SportType, smallint,>
           ,501 --<BetType, smallint,>
           ,1 --<IsLive, bit,>
           ,20 --<ProductID, tinyint,>
           ,94 --<MaxPT, tinyint,>
           ,NULL --<MaxDiscount, decimal(9,8),>
           ,NULL --<IsSync, bit,>
           ,NULL --<IsHidden, bit,>
           ,NULL --<IsDisabled, bit,>
           ,3 --<SettingLevel, tinyint,>
           ,4 --<DisplayOrder, tinyint,>
           ,1),
           
           (1 --<SettingType, smallint,>
           ,50 --<SportType, smallint,>
           ,599 --<BetType, smallint,>
           ,0 --<IsLive, bit,>
           ,20 --<ProductID, tinyint,>
           ,94 --<MaxPT, tinyint,>
           ,NULL --<MaxDiscount, decimal(9,8),>
           ,NULL --<IsSync, bit,>
           ,NULL --<IsHidden, bit,>
           ,NULL --<IsDisabled, bit,>
           ,3 --<SettingLevel, tinyint,>
           ,4 --<DisplayOrder, tinyint,>
           ,1),
           
           (1 --<SettingType, smallint,>
           ,50 --<SportType, smallint,>
           ,599 --<BetType, smallint,>
           ,1 --<IsLive, bit,>
           ,20 --<ProductID, tinyint,>
           ,94 --<MaxPT, tinyint,>
           ,NULL --<MaxDiscount, decimal(9,8),>
           ,NULL --<IsSync, bit,>
           ,NULL --<IsHidden, bit,>
           ,NULL --<IsDisabled, bit,>
           ,3 --<SettingLevel, tinyint,>
           ,4 --<DisplayOrder, tinyint,>
           ,1),
           
           --Bet Setting
           (2 --<SettingType, smallint,>
           ,50 --<SportType, smallint,>
           ,501 --<BetType, smallint,>
           ,0 --<IsLive, bit,>
           ,20 --<ProductID, tinyint,>
           ,NULL --<MaxPT, tinyint,>
           ,NULL --<MaxDiscount, decimal(9,8),>
           ,NULL --<IsSync, bit,>
           ,NULL --<IsHidden, bit,>
           ,NULL --<IsDisabled, bit,>
           ,2 --<SettingLevel, tinyint,>
           ,3 --<DisplayOrder, tinyint,>
           ,1),
           
           --Charge Comm
           (5 --<SettingType, smallint,>
           ,50 --<SportType, smallint,>
           ,501 --<BetType, smallint,>
           ,0 --<IsLive, bit,>
           ,20 --<ProductID, tinyint,>
           ,NULL --<MaxPT, tinyint,>
           ,0.02 --<MaxDiscount, decimal(9,8),>
           ,NULL --<IsSync, bit,>
           ,NULL --<IsHidden, bit,>
           ,NULL --<IsDisabled, bit,>
           ,2 --<SettingLevel, tinyint,>
           ,2 --<DisplayOrder, tinyint,>
           ,1),
           
           --Product Status
           (4 --<SettingType, smallint,>
           ,50 --<SportType, smallint,>
           ,501 --<BetType, smallint,>
           ,0 --<IsLive, bit,>
           ,20 --<ProductID, tinyint,>
           ,NULL --<MaxPT, tinyint,>
           ,NULL --<MaxDiscount, decimal(9,8),>
           ,1 --<IsSync, bit,>
           ,1 --<IsHidden, bit,>
           ,1 --<IsDisabled, bit,>
           ,2 --<SettingLevel, tinyint,>
           ,1 --<DisplayOrder, tinyint,>
           ,1)
GO

--ProductProfile
INSERT INTO [dbo].[ProductStatusProfile]
           ([Sporttype]
           ,[Bettype]
           ,[bitmapOrder])
     VALUES
           (50
           ,501
           ,3)
GO



--Insert Default Minimum Bet by currencies
DECLARE  @DestinationSportBetType TABLE(SportType INT, BetType INT)
INSERT INTO @DestinationSportBetType
VALUES
(50	,501) --Bet Limit

SELECT DISTINCT Currency 
INTO #Currency
FROM dbo.ProductBetSetting cs with(nolock) 

INSERT INTO [dbo].[ProductBetSetting]
           ([Sporttype]
           ,[Bettype]
           ,[Currency]
           ,[MinBet]
           ,[IsDep])
SELECT sbt.SportType,sbt.BetType,Currency,0,0 
FROM #Currency 
	CROSS JOIN @DestinationSportBetType sbt


