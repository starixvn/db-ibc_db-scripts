/*
	Created: Elodie
	Date: 20160220
	Task: Mapping stake level from LCS to AllBet for preparing AllBet settings
	DB: DBTP/DB054. bodb02	
*/ 
--step 0: prepare structure for tmpStakeLevel on DBTP
CREATE TABLE [dbo].[tmpStakeLevel](
	[StakeLevelID] [int] NOT NULL,
	[GameTypeID] [int] NOT NULL,
	[MinLabel] [nvarchar](50) NULL,
	[MaxLabel] [nvarchar](50) NULL,
	[MinStake] [decimal](19, 8) NULL,
	[MaxStake] [decimal](19, 8) NULL,
	[ExchangeId] [int] NULL,
	[StakeLevelID2] [int] NULL,
 ) ON [DATA]

create clustered index CIX_tmpStakeLevel on tmpStakeLevel (stakeLevelID)
--step1: import data from LCS to tempdb on DBTP

INSERT INTO [dbo].[tmpStakeLevel]
           (StakeLevelID
           ,[GameTypeID]
           ,[MinLabel]
           ,[MaxLabel]
           ,[MinStake]
           ,[MaxStake]
           ,[ExchangeId]
          )
SELECT t.StakeLevelID, 2401 AS GameTypeID,s.[MinLabel],s.[MaxLabel],s.[MinStake],s.[MaxStake],t.[ExchangeId]
FROM (           
		SELECT StakeLevelID, exchangeID, GameTypeID
		FROM DBBingoAdmin.LiveCasinoAdmin.dbo.gameTemplate gt with(nolock) 
			INNER JOIN DBBingoAdmin.LiveCasinoAdmin.dbo.gameStakeLevel gs with(nolock) ON gt.gameTemplateid = gs.gameTemplateid 
		WHERE gt.GameTypeid = 108 AND gt.gameTemplateid = 193
			--AND exchangeID in (1,2,3,4,5,6,9,12,13,15,16,17,21,22,31,32,33,34,35,36,37,40,41,43,44,45,47,50,51,52,54,55,58,61,62,64,65,66,67,68)
		)t    
INNER JOIN DBBingoAdmin.LiveCasinoAdmin.dbo.stakeLevel s with(Nolock) on t.stakeLevelID = s.stakelevelID

--Allbet Supported Currency
--SELECT * 
--FROM Exchange 
--WHERE code IN ('CNY','USD','HKD','BTC','KRW','MYR','SGD','JPY','THB','IDR','VND','EUR','AUD','GBP','CHF','MXP','CAD','RUB','INR','RON',
--				'DKK','NOK','NTD','COP')

GO

--step 2: mapping stakeLevelID from LCS to GD
UPDATE lcs WITH(UPDLOCK,ROWLOCK)
SET stakelevelID2 = s.StakeLevelID
FROM tmpStakeLevel lcs
	INNER JOIN StakeLevel s ON lcs.MinStake = s.MinStake
							AND lcs.MaxStake = s.MaxStake
							AND lcs.GameTypeID = s.GameTypeID
							AND lcs.ExchangeID = s.ExchangeID

GO

--check mapping stake level
--if no row , mapping successful
SELECT * FROM tmpStakeLevel WHERE stakeLevelID2 IS NULL	