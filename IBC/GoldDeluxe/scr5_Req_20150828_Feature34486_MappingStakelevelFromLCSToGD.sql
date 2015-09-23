/*
	Created: Johnson
	Date: 2015-08-28
	Task: Mapping stake level from LCS to GD for preparing GD settings
	DB: DBTP/DB054. bodb02	
*/ 
--step 0: prepare structure for tmpStakeLevel on DBTP
CREATE TABLE [dbo].[tmpStakeLevel](
	[StakeLevelID] [int] NULL,
	[GameTypeID] [int] NULL,
	[MinLabel] [nvarchar](50) NULL,
	[MaxLabel] [nvarchar](50) NULL,
	[MinStake] [decimal](19, 8) NULL,
	[MaxStake] [decimal](19, 8) NULL,
	[ExchangeId] [int] NULL,
	[StakeLevelID2] [int] NULL,
 ) ON [DATA]

create clustered index CIX_tmpStakeLevel on tmpStakeLevel
(stakeLevelID)
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
SELECT s.StakeLevelID, case when GameTypeID = 108 then 1701 when GameTypeID = 109 then 1702 end as GameTypeID,
s.[MinLabel],s.[MaxLabel],s.[MinStake],s.[MaxStake],t.[ExchangeId]
FROM (           
select StakeLevelID, exchangeID, GameTypeID
from DBBingoAdmin.LiveCasinoAdmin.dbo.gameTemplate gt with(nolock) 
inner join DBBingoAdmin.LiveCasinoAdmin.dbo.gameStakeLevel gs with(nolock) 
on gt.gameTemplateid = gs.gameTemplateid 
where gt.GameTypeid in (108,109)
and gt.gameTemplateid in (193,210)
)t    
inner join DBBingoAdmin.LiveCasinoAdmin.dbo.stakeLevel s with(Nolock) on t.stakeLevelID = s.stakelevelID
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
						
							
							 
