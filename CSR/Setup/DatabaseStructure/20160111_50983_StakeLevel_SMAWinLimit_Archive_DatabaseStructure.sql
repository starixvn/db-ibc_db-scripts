/*
	Created by: Elodie
	Created Date: 20160115
	Description: DCS for StakeLevel and WinLossLimit
	Database: DB05/bodb_Customer
		
*/
USE bodb_Customer
GO
--- CREATING FILE GROUP AND DATA FILE
ALTER DATABASE bodb_Customer ADD FILEGROUP CustWinLossLimit_table
ALTER DATABASE bodb_Customer ADD FILEGROUP CustStakeLevel_table

GO
ALTER DATABASE bodb_Customer 
ADD FILE 
(
	NAME = CustWinLossLimit_table_01,
	FILENAME = 'G:\IBC_DB\bodb_Customer\CustWinLossLimit_table_01.NDF'
	, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
)
TO FILEGROUP CustWinLossLimit_table

GO
ALTER DATABASE bodb_Customer 
ADD FILE 
(
	NAME = CustStakeLevel_table_01,
	FILENAME = 'G:\IBC_DB\bodb_Customer\CustStakeLevel_table_01.NDF'
	, SIZE = 32MB , MAXSIZE = UNLIMITED, FILEGROWTH = 32MB
)
TO FILEGROUP CustStakeLevel_table

------- Creating Talbes 
USE bodb_Customer
GO

CREATE TABLE [dbo].[CustWinLossLimit_Member_Old](
	[CustId] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [int] NOT NULL,
	[MaxWinLimit] [smallmoney] NULL,
	[MaxLossLimit] [money] NULL,
	[IsAutoReset] [bit] NULL
 CONSTRAINT [PK_CustWinLossLimit_Member_Old] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [CustWinLossLimit_table]
) ON [CustWinLossLimit_table]

GO
CREATE TABLE [dbo].[CustStakeLevel_Member_Old] (
	CustID			INT					NOT NULL,
	SportType		SMALLINT			NOT NULL,
	BetType			SMALLINT			NOT NULL,
	StakeLevelList	VARCHAR(200)		NULL,
	LastUpdated		DATETIME			NULL	
	CONSTRAINT		DF_CustStakeLevel_Member_Old_LastUpdate DEFAULT GETDATE(),
	CONSTRAINT		PK_CustStakeLevel_Member_Old PRIMARY KEY CLUSTERED (
		CustID		ASC,
		SportType	ASC,
		BetType		ASC
	) ON [CustStakeLevel_table]
) ON [CustStakeLevel_table]












