/*
	Created: 20160324@Elodie
	Task: Stake Level Group for DCS 
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/DB06/DBTP	--
----------------------------------------------------------
USE CustDB
GO
CREATE TABLE [dbo].[StakeLevelGroupDetail](
	[StakeLevelID] [int] NOT NULL,
	[GameTypeID] [int] NOT NULL,
	[MinLabel] [nvarchar](50) NULL,
	[MaxLabel] [nvarchar](50) NULL,
	[MinStake] [decimal](19, 8) NULL,
	[MaxStake] [decimal](19, 8) NULL,
 CONSTRAINT [PK_StakeLevelGroupDetail] PRIMARY KEY CLUSTERED 
(
	[StakeLevelID] ASC,
	[GameTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]

GO

CREATE TABLE [dbo].[GameGroup](
	[GameGroupID] [int] NOT NULL,
	[RefSportType] [smallint] NOT NULL,
	[RefBetType] [int] NOT NULL,
	[GroupName] [nvarchar](100) NULL,
	[IsDeposit]	[bit] NOT NULL,
 CONSTRAINT [PK_GameGroup] PRIMARY KEY CLUSTERED 
(
	[GameGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [DATA]
) ON [DATA]

GO
ALTER TABLE [dbo].[GameGroup] ADD  CONSTRAINT [DF_GameGroup_IsDeposit]  DEFAULT ((0)) FOR [IsDeposit]
GO
ALTER TABLE [dbo].[GameGroup] ADD  CONSTRAINT [DF_GameGroup_RefSportType]  DEFAULT ((0)) FOR [RefSportType]
GO

ALTER TABLE [dbo].[GameGroup] ADD  CONSTRAINT [DF_GameGroup_RefBetType]  DEFAULT ((0)) FOR [RefBetType]
GO

ALTER TABLE [dbo].[StakeLevel] ADD GameGroupID INT CONSTRAINT DF_StakeLevel_GameGroupID DEFAULT(0) NOT NULL

