/*<info serverAlias="DBLIC-bodb_Licensee"></info>*/
/*
	Created: 20220310@Percy
	DB: DBLIC-bodb_Licensee
	Task: New discount tables for UAT testing
		- Create new tables
*/
USE [bodb_licensee]
GO

CREATE TABLE [dbo].[LA_DiscountGroupAssignment_UAT](
	[DiscountGroupId] [int] NOT NULL,
	[PartyID] [int] NOT NULL,
	[Remark] [nvarchar](4000) NULL,
	[IsApplyDiscount] [bit] NULL,
	[IsSpecialTreatment] [bit] NOT NULL CONSTRAINT [DF_LA_DiscountGroupAssignment_UAT_IsSpecialTreatment]  DEFAULT ((0)),
 CONSTRAINT [PK_LA_DiscountGroupAssignment_UAT] PRIMARY KEY CLUSTERED 
(
	[DiscountGroupId] ASC,
	[PartyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]
GO

CREATE TABLE [dbo].[LA_DiscountGroupCurrency_UAT](
	[DiscountGroupId] [smallint] NOT NULL,
	[PartyID] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[CalculationType] [tinyint] NULL CONSTRAINT [DF_LA_DiscountGroupCurrency_UAT_CalculationType]  DEFAULT ((0)),
 CONSTRAINT [PK_LA_DiscountGroupCurrency_UAT] PRIMARY KEY CLUSTERED 
(
	[DiscountGroupId] ASC,
	[PartyID] ASC,
	[CurrencyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]
GO

CREATE TABLE [dbo].[LA_DiscountGroupDetail_UAT](
	[DiscountGroupDetailId] [smallint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DiscountGroupId] [smallint] NOT NULL,
	[FromAmount] [money] NULL,
	[ToAmount] [money] NULL,
	[Rate] [money] NOT NULL,
 CONSTRAINT [PK_LA_DiscountGroupDetail_UAT] PRIMARY KEY CLUSTERED 
(
	[DiscountGroupDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]
GO

CREATE TABLE [dbo].[LA_DiscountGroupHeader_UAT](
	[DiscountGroupId] [smallint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DiscountGroupName] [nvarchar](110) NULL,
	[DiscountGroupType] [tinyint] NOT NULL,
	[CurrencyId] [tinyint] NOT NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NOT NULL,
	[Priority] [tinyint] NOT NULL,
	[Remark] [nvarchar](4000) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_LA_DiscountGroupHeader_UAT] PRIMARY KEY CLUSTERED 
(
	[DiscountGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

CREATE TABLE [dbo].[LA_DiscountGroupProduct_UAT](
	[DiscountGroupId] [smallint] NOT NULL,
	[ProductId] [tinyint] NOT NULL,
	[CalculationType] [tinyint] NULL,
 CONSTRAINT [PK_LA_DiscountGroupProduct_UAT] PRIMARY KEY CLUSTERED 
(
	[DiscountGroupId] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]
GO