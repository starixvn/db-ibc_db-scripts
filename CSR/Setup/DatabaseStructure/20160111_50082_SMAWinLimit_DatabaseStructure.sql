/*
	Created by: Elodie
	Created Date: 20160111
	Description: SMA Winlimit for DCS 
	Database: DBCUST/CustDB
		
*/
USE CustDB
GO
--- CREATING FILE GROUP AND DATA FILE
ALTER DATABASE CustDB ADD FILEGROUP CustWinLimit3rd_Member_table

GO
ALTER DATABASE CustDB 
ADD FILE 
(
	NAME = CustWinLimit3rd_Member_table_01, 
	FILENAME = 'D:\SQLSERVER2008R2\IBC_DB\CustDB\CustWinLimit3rd_Member_table_01.NDF'
)
TO FILEGROUP CustWinLimit3rd_Member_table;

GO
ALTER DATABASE CustDB ADD FILEGROUP CustWinLimit3rd_Agent_table

GO 
ALTER DATABASE CustDB 
ADD FILE 
(
	NAME = CustWinLimit3rd_Agent_table_01,
	FILENAME = 'D:\SQLSERVER2008R2\IBC_DB\CustDB\CustWinLimit3rd_Agent_table_01.NDF'
)
TO FILEGROUP CustWinLimit3rd_Agent_table

GO
CREATE TABLE [dbo].[CustWinLimit3rd_Agent](
	[CustId] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[MaxWinLimit] [smallmoney] NULL,
	[IsAutoReset] [bit] NULL
 CONSTRAINT [PK_CustWinLimit3rd_Agent] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [CustWinLimit3rd_Agent_table]
) ON [CustWinLimit3rd_Agent_table]

GO
CREATE TABLE [dbo].[CustWinLimit3rd_Member](
	[CustId] [int] NOT NULL,
	[SportType] [smallint] NOT NULL,
	[BetType] [smallint] NOT NULL,
	[MaxWinLimit] [smallmoney] NULL,
	[IsAutoReset] [bit] NULL
 CONSTRAINT [PK_CustWinLimit3rd_Member] PRIMARY KEY CLUSTERED 
(
	[CustId] ASC,
	[SportType] ASC,
	[BetType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [CustWinLimit3rd_Member_table]
) ON [CustWinLimit3rd_Member_table]





