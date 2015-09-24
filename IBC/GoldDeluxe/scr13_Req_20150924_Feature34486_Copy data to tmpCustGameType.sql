/*
	Created: Johnson
	Date: 2015-09-24
	Task: prepare data for tmpCustGameType
	DB: DBCUST/06/TP/MNL.bodb02	
*/ 
--step 0: prepare structure for tmpCustGameType on DBCUST
USE [CustDB]
GO

/****** Object:  Table [dbo].[tmpCustGameType]    Script Date: 9/24/2015 4:52:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tmpCustGameType](
	[CustID] [int] NOT NULL,
	[GameTypeID] [int] NOT NULL,
	[StakeLevelList] [varchar](100) NULL,
	[MaxPerGameType] [money] NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
 CONSTRAINT [PK_tmpCustGameType] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[GameTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [CustGameType_table]
) ON [CustGameType_table]

GO

SET ANSI_PADDING OFF
GO
---------------------------------------------------

USE [CustDB]
GO
--mapping GameTypeID from LCS to GD
INSERT INTO [dbo].[tmpCustGameType]
           ([CustID]
           ,[GameTypeID]
           ,[StakeLevelList]
          )
SELECT custid,CASE WHEN GameTypeID = 108 THEN 1701 
					WHEN GameTypeID = 109 THEN 1702 END
		,StakeLevelList	
FROM CustGameType_LCS WITH(NOLOCK)
WHERE GameTypeID IN (108,109)
  


