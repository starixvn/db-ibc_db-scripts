/*
	Created by: Elodie
	Date: 20150514
	Task: Prepare structure for archiving unused account function [Redmine:#34486]	
*/ 
----------------------------------------------------------------
--Add new table to DB05.bodb_Customer.dbo.CustGameType_old------
----------------------------------------------------------------
USE bodb_Customer
GO

ALTER DATABASE bodb_Customer ADD FILEGROUP [CustGameType_table]
GO

ALTER DATABASE bodb_Customer ADD FILE (name = 'CustGameType_table', filename = 'G:\IBC_DB\bodb_Customer\CustGameType_table.ndf', SIZE = 2048KB ,FILEGROWTH = 2048KB ) TO FILEGROUP [CustGameType_table]
GO

USE bodb_Customer
GO

/****** Object:  Table [dbo].[CustGameType]    Script Date: 6/18/2014 4:54:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CustGameType_old](
	[CustID] [int] NOT NULL,
	[GameTypeID] [int] NOT NULL,
	[StakeLevelList] [varchar](50) NULL,
	[MaxPerGameType] [money] NULL,
	[MinBet] [money] NULL,
	[MaxBet] [money] NULL,
	[IsDisabled] [bit] NOT NULL,
 CONSTRAINT [PK_CustGameType] PRIMARY KEY CLUSTERED 
(
	[CustID] ASC,
	[GameTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [CustGameType_table]
) ON [CustGameType_table]

GO

SET ANSI_PADDING OFF
GO

----------------------------------------------------------------
--Add new table to DB05.bodb_Customer.dbo.CustVirtualRate_old------
----------------------------------------------------------------
USE bodb_Customer
GO

ALTER DATABASE bodb_Customer ADD FILEGROUP [virtualrate_table]
GO

ALTER DATABASE bodb_Customer ADD FILE (name = 'virtualrate_table', filename = 'G:\IBC_DB\bodb_Customer\virtualrate_table.ndf', SIZE = 2048KB ,FILEGROWTH = 2048KB ) TO FILEGROUP [virtualrate_table]
GO

USE bodb_Customer
GO

/****** Object:  Table [dbo].[CustVirtualRate]    Script Date: 5/14/2015 11:24:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CustVirtualRate_old](
	[custid] [int] NOT NULL,
	[sporttype] [int] NOT NULL,
	[bettype] [int] NOT NULL,
	[isLive] [bit] NOT NULL,
	[virtualMultiplier] [smallmoney] NULL,
 CONSTRAINT [PK_CustVirtualRate] PRIMARY KEY CLUSTERED 
(
	[custid] ASC,
	[sporttype] ASC,
	[bettype] ASC,
	[isLive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [virtualrate_table]
) ON [virtualrate_table]

GO
