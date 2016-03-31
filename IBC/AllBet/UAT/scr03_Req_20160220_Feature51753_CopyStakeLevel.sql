/*
	Created: Elodie
	Date: 20160220
	Task: import stakelevel global setting 
	DB: DBCUST/CustDB
*/ 

--run on DBCUST
USE [CustDB]
GO

set IDENTITY_INSERT StakeLevel OFF
GO

INSERT INTO [dbo].[StakeLevel]
           ([GameTypeID]
           ,[MinLabel]
           ,[MaxLabel]
           ,[MinStake]
           ,[MaxStake]
           ,[ExchangeId])
SELECT	2401 as GameTypeID,
		s.[MinLabel],
		s.[MaxLabel],
		s.[MinStake],
		s.[MaxStake],
		t.[ExchangeId]
FROM (           
		SELECT StakeLevelID, exchangeID
		FROM DBBingoAdmin.LiveCasinoAdmin.dbo.gameTemplate gt WITH (NOLOCK)
			INNER JOIN DBBingoAdmin.LiveCasinoAdmin.dbo.gameStakeLevel gs WITH (NOLOCK) ON gt.gameTemplateid = gs.gameTemplateid 
		WHERE gt.GameTypeid = 108 AND gt.gameTemplateid = 193
			AND exchangeID = 20
			--AND exchangeID in (1,2,3,4,5,6,9,12,13,15,16,17,21,22,31,32,33,34,35,36,37,40,41,43,44,45,47,50,51,52,54,55,58,61,62,64,65,66,67,68)
		)t    
INNER JOIN DBBingoAdmin.LiveCasinoAdmin.dbo.stakeLevel s with(Nolock) on t.stakeLevelID = s.stakelevelID
ORDER BY t.exchangeID, s.MaxStake, s.MinStake

--Allbet Supported Currency
--SELECT * 
--FROM Exchange 
--WHERE code IN ('CNY','USD','HKD','BTC','KRW','MYR','SGD','JPY','THB','IDR','VND','EUR','AUD','GBP','CHF','MXP','CAD','RUB','INR','RON',
--				'DKK','NOK','NTD','COP')
GO 

INSERT INTO [dbo].[StakeLevel]
           ([GameTypeID]
           ,[MinLabel]
           ,[MaxLabel]
           ,[MinStake]
           ,[MaxStake]
           ,[ExchangeId])
SELECT	2402 as GameTypeID,
		s.[MinLabel],
		s.[MaxLabel],
		s.[MinStake],
		s.[MaxStake],
		s.[ExchangeId]
FROM StakeLevel s WITH (NOLOCK) WHERE GameTypeID = 2401 ORDER BY s.exchangeID, s.MaxStake, s.MinStake

GO
set IDENTITY_INSERT StakeLevel ON