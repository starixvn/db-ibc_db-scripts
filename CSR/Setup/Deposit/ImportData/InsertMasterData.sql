/*
	Created: 20160405@Helen
	Task: DCS Deposit
		Insert Master Data:
			dbo.Dep_ProductSetting
			dbo.Dep_ProductSettingDetail
			dbo.Dep_ProductStatusProfile
			-- Stake Level Group
			dbo.GameGroup
			dbo.Dep_StakeLevel
			dbo.Dep_StakeLevelGroupDetail
			
	DB: Run at DBCust.CustDB
*/  
USE [CustDB]
Go
INSERT INTO [dbo].[Dep_ProductSetting] (ProductSettingID,ProductID,SettingType,TemplateID,DisplayOrder,SettingLevel)
VALUES 
	--Status
	(1,22,4,0,1,1)
	-- PT
	,(2,22,1,0,2,1)
	-- Stakelevel group
	,(3,22,8,0,3,2)
GO
INSERT INTO [dbo].[Dep_ProductSettingDetail] (ProductSettingID,SportType,BetType,IsLive,MaxDefaultValue,SettingStatus)
VALUES 
	(1,212,4001,0,0,1)
	,(2,212,4001,0,0,1)
	,(3,212,4001,0,0,1)
GO

INSERT INTO [dbo].Dep_ProductStatusProfile (Sporttype,Bettype,bitmapOrder)
VALUES (212,4001,1)

GO

-- StakeLevel
-- Just sample data

INSERT INTO dbo.GameGroup 
		(	GameGroupID, RefSportType, RefBetType, GroupName, IsDeposit)
VALUES	(	6          , 212         , 4001      , 'Level 1', 1        )
	,	(	7          , 212         , 4001      , 'Level 2', 1        )
	,	(	8          , 212         , 4001      , 'Level 3', 1        )
	,	(	9          , 212         , 4001      , 'Level 4', 1        )
	,	(	10         , 212         , 4001      , 'Level 5', 1        )
	

GO
INSERT INTO dbo.Dep_StakeLevel
		(	StakeLevelID, GameTypeID, GameGroupID, MinLabel, MaxLabel, MinStake, MaxStake, ExchangeId, ResourceId)
VALUES	(	4021          , 4001      , 6         , NULL    , NULL    , NULL    , NULL    , 20        , 9888888   )
	,	(	4022          , 4001      , 7         , NULL    , NULL    , NULL    , NULL    , 20        , 9888889   )
	,	(	4023          , 4001      , 8         , NULL    , NULL    , NULL    , NULL    , 20        , 9888890   )
	,	(	4024          , 4001      , 9         , NULL    , NULL    , NULL    , NULL    , 20        , 9888891   )
	,	(	4025          , 4001      , 10         , NULL    , NULL    , NULL    , NULL    , 20        , 9888892   )
	,	(	4026          , 4001      , 6         , NULL    , NULL    , NULL    , NULL    , 16        , 9888893   )
	,	(	4027          , 4001      , 7         , NULL    , NULL    , NULL    , NULL    , 16        , 9888894   )
	,	(	4028          , 4001      , 8         , NULL    , NULL    , NULL    , NULL    , 16        , 9888895   )
	,	(	4029          , 4001      , 9         , NULL    , NULL    , NULL    , NULL    , 16        , 9888896   )
	,	(	4030          , 4001      , 10         , NULL    , NULL    , NULL    , NULL    , 16        , 9888897   )

GO

INSERT INTO dbo.Dep_StakeLevelGroupDetail
		(	StakeLevelID, GameTypeID, MinLabel, MaxLabel  , MinStake, MaxStake)
VALUES	(	4021        , 4001      , '2'     , '500'     , 2       , 500	  )
	,	(	4022        , 4001      , '10'    , '1,000'   , 10      , 1000    )
	,	(	4023        , 4001      , '50'    , '2,500'   , 50      , 2500    )
	,	(	4024        , 4001      , '100'   , '5,000'   , 100     , 5000    )
	,	(	4025        , 4001      , '5'     , '1,000'   , 5       , 1000    )
	,	(	4026        , 4001      , '20'    , '2,500'   , 20      , 2500    )
	,	(	4027        , 4001      , '100'   , '5,000'   , 100     , 5000    )
	,	(	4028        , 4001      , '250'   , '10,000'  , 250     , 10000   )
	,	(	4029        , 4001      , '500'   , '20,000'  , 500     , 20000   )
	,	(	4030        , 4001      , '800'   , '50,000'  , 800     , 50000   )
	,	(	4021        , 4002      , '2.5'   , '500.5'   , 2.5     , 500.5	  )
	,	(	4022        , 4002      , '10.5'  , '1,000.5' , 10.5    , 1000.5  )
	,	(	4023        , 4002      , '50.5'  , '2,500.5' , 50.5    , 2500.5  )
	,	(	4024        , 4002      , '100.5' , '5,000.5' , 100.5   , 5000.5  )
	,	(	4025        , 4002      , '5.5'   , '1,000.5' , 5.5     , 1000.5  )
	,	(	4026        , 4002      , '20.5'  , '2,500.5' , 20.5    , 2500.5  )
	,	(	4027        , 4002      , '100.5' , '5,000.5' , 100.5   , 5000.5  )
	,	(	4028        , 4002      , '250.5' , '10,000.5', 250.5   , 10000.5 )
	,	(	4029        , 4002      , '500.5' , '80,000.5', 500.5   , 80000.5 )
	,	(	4030        , 4002      , '1000'  , '100,000' , 1000    , 100000  )
	,	(	4021        , 4003      , '4'     , '500'     , 4       , 500	  )
	,	(	4022        , 4003      , '25'    , '1,000'   , 25      , 1000    )
	,	(	4023        , 4003      , '100'   , '2,500'   , 100     , 2500    )
	,	(	4024        , 4003      , '250'   , '5,000'   , 250     , 5000    )
	,	(	4025        , 4003      , '10'    , '1,000'   , 10      , 1000    )
	,	(	4026        , 4003      , '40'    , '2,500'   , 40      , 2500    )
	,	(	4027        , 4003      , '150'   , '5,000'   , 150     , 5000    )
	,	(	4028        , 4003      , '300'   , '10,000'  , 300     , 10000   )
	,	(	4029        , 4003      , '400'   , '20,000'  , 400     , 20000   )
	,	(	4030        , 4003      , '500'   , '50,000'  , 500     , 50000   )
GO	