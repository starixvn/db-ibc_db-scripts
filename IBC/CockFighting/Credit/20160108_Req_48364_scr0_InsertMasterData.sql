/*
	Created: Dominic
	Date: 2015-11-25
	Task: Insert Master Data for Cock Fighting: dbo.ProductSettingDetail, dbo.ProductBetSetting, dbo.SettingSystem
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
           ,206 --<SportType, smallint,>
           ,1003 --<BetType, smallint,>
           ,0 --<IsLive, bit,>
           ,19 --<ProductID, tinyint,>
           ,90 --<MaxPT, tinyint,>
           ,NULL --<MaxDiscount, decimal(9,8),>
           ,NULL --<IsSync, bit,>
           ,NULL --<IsHidden, bit,>
           ,NULL --<IsDisabled, bit,>
           ,4 --<SettingLevel, tinyint,>
           ,4 --<DisplayOrder, tinyint,>
           ,1),
           
           --Bet Setting
           (2 --<SettingType, smallint,>
           ,206 --<SportType, smallint,>
           ,1003 --<BetType, smallint,>
           ,0 --<IsLive, bit,>
           ,19 --<ProductID, tinyint,>
           ,NULL --<MaxPT, tinyint,>
           ,NULL --<MaxDiscount, decimal(9,8),>
           ,NULL --<IsSync, bit,>
           ,NULL --<IsHidden, bit,>
           ,NULL --<IsDisabled, bit,>
           ,2 --<SettingLevel, tinyint,>
           ,3 --<DisplayOrder, tinyint,>
           ,1),
           
           --Discount
           (3 --<SettingType, smallint,>
           ,206 --<SportType, smallint,>
           ,1003 --<BetType, smallint,>
           ,0 --<IsLive, bit,>
           ,19 --<ProductID, tinyint,>
           ,NULL --<MaxPT, tinyint,>
           ,0.0025 --<MaxDiscount, decimal(9,8),>
           ,NULL --<IsSync, bit,>
           ,NULL --<IsHidden, bit,>
           ,NULL --<IsDisabled, bit,>
           ,2 --<SettingLevel, tinyint,>
           ,2 --<DisplayOrder, tinyint,>
           ,1),
           
           --Product Status
           (4 --<SettingType, smallint,>
           ,206 --<SportType, smallint,>
           ,1003 --<BetType, smallint,>
           ,0 --<IsLive, bit,>
           ,19 --<ProductID, tinyint,>
           ,NULL --<MaxPT, tinyint,>
           ,NULL --<MaxDiscount, decimal(9,8),>
           ,1 --<IsSync, bit,>
           ,1 --<IsHidden, bit,>
           ,1 --<IsDisabled, bit,>
           ,2 --<SettingLevel, tinyint,>
           ,1 --<DisplayOrder, tinyint,>
           ,1)
GO


--Insert Default Minimum Bet by currencies
DECLARE  @DestinationSportBetType TABLE(SportType INT, BetType INT)
INSERT INTO @DestinationSportBetType
VALUES
(206	,1003) --Bet Limit

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


