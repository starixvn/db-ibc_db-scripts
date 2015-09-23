/*
	Created: Johnson
	Date: 2015-09-23
	Task: import stakelevel global setting for missing currency
	DB: DBPRO/bodb02
*/ 


--run on DB02

USE [bodb02]
GO

set IDENTITY_INSERT StakeLevel ON
GO

INSERT INTO [dbo].[StakeLevel]
           ([GameTypeID]
           ,[MinLabel]
           ,[MaxLabel]
           ,[MinStake]
           ,[MaxStake]
           ,[ExchangeId])
SELECT case when GameTypeID = 108 then 1701 when GameTypeID = 109 then 1702 end as GameTypeID,
s.[MinLabel],s.[MaxLabel],s.[MinStake],s.[MaxStake],t.[ExchangeId]
FROM (           
select StakeLevelID, exchangeID, GameTypeID
from DBBingoAdmin.LiveCasinoAdmin.dbo.gameTemplate gt with(nolock) 
inner join DBBingoAdmin.LiveCasinoAdmin.dbo.gameStakeLevel gs with(nolock) 
on gt.gameTemplateid = gs.gameTemplateid 
where gt.GameTypeid in (108,109)
and gt.gameTemplateid in (193,210)
AND exchangeID in (68,69)--POS MMK
)t    
inner join DBBingoAdmin.LiveCasinoAdmin.dbo.stakeLevel s with(Nolock) on t.stakeLevelID = s.stakelevelID
--order by exchangeid 