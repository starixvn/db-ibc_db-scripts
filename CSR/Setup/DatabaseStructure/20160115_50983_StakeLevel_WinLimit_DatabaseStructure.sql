/*
	Created: 20160115@Elodie
	Task: Stake Level and WinLossLimit Structure for DCS 
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBPRO/bodb02		--
----------------------------------------------------------
USE bodb02
GO

ALTER TABLE Sport_Bettype_Reference
ADD	BettypeRefComm			INT			NULL, 
	SporttypeRefComm		SMALLINT	NULL, 
	BettypeRefBetLimit		INT			NULL, 
	SporttypeRefBetLimit	SMALLINT	NULL, 
	RefTableName			VARCHAR(50)	NULL, 
	RefTableNameComm		VARCHAR(50)	NULL, 
	RefTableNameBetLimit	VARCHAR(50)	NULL


-- BEGIN STEP 2: DEPLOY THIS SCRIPT ON DBCUST/CustDB	--
----------------------------------------------------------
USE CustDB
GO
--- CREATING FILE GROUP AND DATA FILE
ALTER DATABASE CustDB ADD FILEGROUP CustWinLossLimit_Agent_table
ALTER DATABASE CustDB ADD FILEGROUP CustWinLossLimit_Member_table
ALTER DATABASE CustDB ADD FILEGROUP CustStakeLevel_Agent_table
ALTER DATABASE CustDB ADD FILEGROUP CustStakeLevel_Member_table

GO
ALTER DATABASE CustDB 
ADD FILE 
(
	NAME = CustWinLossLimit_Agent_table_01,
	FILENAME = 'H:\USER_DB\CustDB\CustWinLossLimit_Agent_table_01.NDF',
	SIZE = 2048KB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 1024KB
)
TO FILEGROUP CustWinLossLimit_Agent_table

GO
ALTER DATABASE CustDB 
ADD FILE 
(
	NAME = CustWinLossLimit_Member_table_01,
	FILENAME = 'H:\USER_DB\CustDB\CustWinLossLimit_Member_table_01.NDF',
	SIZE = 2048KB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 1024KB
)
TO FILEGROUP CustWinLossLimit_Member_table

GO
ALTER DATABASE CustDB
ADD FILE (
	NAME = CustStakeLevel_Agent_table_01,
	FILENAME = 'H:\USER_DB\CustDB\CustStakeLevel_Agent_table_01.NDF',
	SIZE = 2048KB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 1024KB
)
TO FILEGROUP CustStakeLevel_Agent_table

GO
ALTER DATABASE CustDB
ADD FILE (
	NAME = CustStakeLevel_Member_table_01,
	FILENAME = 'H:\USER_DB\CustDB\CustStakeLevel_Member_table_01.NDF',
	SIZE = 2048KB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 1024KB
)
TO FILEGROUP CustStakeLevel_Member_table

USE CustDB
GO
CREATE TABLE [dbo].[CustWinLossLimit_Agent](
	[CustId] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [int] NOT NULL,
	[MaxWinLimit] [smallmoney] NULL,
	[MaxLossLimit] [money] NULL,
	[IsAutoReset] [bit] NULL
 CONSTRAINT [PK_CustWinLossLimit_Agent] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [CustWinLossLimit_Agent_table]
) ON [CustWinLossLimit_Agent_table]

GO
CREATE TABLE [dbo].[CustWinLossLimit_Member](
	[CustId] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [int] NOT NULL,
	[MaxWinLimit] [smallmoney] NULL,
	[MaxLossLimit] [money] NULL,
	[IsAutoReset] [bit] NULL
 CONSTRAINT [PK_CustWinLossLimit_Member] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [CustWinLossLimit_Member_table]
) ON [CustWinLossLimit_Member_table]


CREATE TABLE [dbo].[CustStakeLevel_Agent] (
	CustID			INT					NOT NULL,
	SportType		SMALLINT			NOT NULL,
	BetType			INT					NOT NULL,
	StakeLevelList	VARCHAR(200)		NULL,
	CONSTRAINT		PK_CustStakeLevel_Agent	PRIMARY KEY CLUSTERED (
		CustID		ASC,
		SportType	ASC,
		BetType		ASC
	) ON [CustStakeLevel_Agent_table]
) ON [CustStakeLevel_Agent_table]


CREATE TABLE [dbo].[CustStakeLevel_Member] (
	CustID			INT					NOT NULL,
	SportType		SMALLINT			NOT NULL,
	BetType			INT					NOT NULL,
	StakeLevelList	VARCHAR(200)		NULL,
	LastUpdated		DATETIME			NULL	
	CONSTRAINT		DF_CustStakeLevel_Member_LastUpdate DEFAULT GETDATE(),
	CONSTRAINT		PK_CustStakeLevel_Member PRIMARY KEY CLUSTERED (
		CustID		ASC,
		SportType	ASC,
		BetType		ASC
	) ON [CustStakeLevel_Member_table]
) ON [CustStakeLevel_Member_table]


