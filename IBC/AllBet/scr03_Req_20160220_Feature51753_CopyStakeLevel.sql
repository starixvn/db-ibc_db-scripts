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
			--AND exchangeID in (68)--POS MMK
		)t    
INNER JOIN DBBingoAdmin.LiveCasinoAdmin.dbo.stakeLevel s with(Nolock) on t.stakeLevelID = s.stakelevelID

GO
set IDENTITY_INSERT StakeLevel ON