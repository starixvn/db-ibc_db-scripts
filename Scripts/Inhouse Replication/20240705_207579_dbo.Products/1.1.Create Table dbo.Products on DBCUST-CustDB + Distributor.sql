/*<info serverAlias="DBCustRepl-ReplCustDB,DBCUST-CustDB"></info>*/
/*
	Created: 20240705@Lewis
	DB: 
		+ DBCustRepl-ReplCustDB
		+ DBCUST-CustDB
	Task: InHouse Replication - Create table dbo.Products 
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Products](
	[ProductID] [tinyint] NOT NULL,
	[ProductName] [varchar](50) NOT NULL,
	[Description] [varchar](100) NULL,
	[ProductPrefix] [varchar](10) NULL,
	[Enabled] [bit] NULL,
	[ProductNameCh] [nvarchar](50) NULL,
	[ProductNameCs] [nvarchar](50) NULL,
	[ProductNameJp] [nvarchar](50) NULL,
	[ProductNameIt] [nvarchar](50) NULL,
	[ProductNameTh] [nvarchar](50) NULL,
	[ProductNameKo] [nvarchar](50) NULL,
	[ProductNameES] [nvarchar](50) NULL,
	[ProductNameVN] [nvarchar](50) NULL,
	[ProductNameEL] [nvarchar](50) NULL,
	[ProductNameRU] [nvarchar](50) NULL,
	[ProductNameID] [nvarchar](50) NULL,
	[BalanceType] [tinyint] NULL,
	[SubProductBalanceType] [varchar](512) NULL,
	[GroupType] [tinyint] NULL,
	[CasinoType] [tinyint] NULL,
	[IsOfferPlayForFun] [bit] NULL,
	[EndOfSupportDate] [date] NULL,
	[VendorID] [smallint] NULL,
	[OrderNo] [int] NULL,
	[Environment] [tinyint] NOT NULL,
	[RepUpdateTime] [datetime2](7) NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [DATA]
) ON [DATA]
GO

ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_Enabled]  DEFAULT ((0)) FOR [Enabled]
GO

ALTER TABLE [dbo].[Products] ADD  DEFAULT ((0)) FOR [GroupType]
GO

ALTER TABLE [dbo].[Products] ADD  DEFAULT ((0)) FOR [CasinoType]
GO

ALTER TABLE [dbo].[Products] ADD  DEFAULT ((0)) FOR [IsOfferPlayForFun]
GO

ALTER TABLE [dbo].[Products] ADD  DEFAULT ((1)) FOR [Environment]
GO

ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_RepUpdateTime]  DEFAULT (sysdatetime()) FOR [RepUpdateTime]
GO




