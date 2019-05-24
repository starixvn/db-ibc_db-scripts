USE [bodb_Licensee]
GO

/*
	Created: 20190510@Percy
	DB: DBCUST.bodb_Licensee, DB053.bodb_Licensee, DB06.bodb_Licensee
	Task: Migrate tables to DBCUST - Create tables
*/

/****** Object:  Table [dbo].[LA_ChargeInfo_MinFee]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_ChargeInfo_MinFee](
	[ChargeID] [int] NOT NULL,
	[MinFee] [money] NULL,
	[MinFeeCurrencyID] [int] NULL,
	[WaiveFrom] [date] NULL,
	[WaiveTo] [date] NULL,
 CONSTRAINT [PK_LA_ChargeInfo_MinFee] PRIMARY KEY CLUSTERED 
(
	[ChargeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [licensee_table]
) ON [licensee_table]

GO
GRANT SELECT ON [dbo].[LA_ChargeInfo_MinFee] TO [bodbAdminNet] AS [dbo]
GO

/****** Object:  Table [dbo].[LA_ChargeInfo_SystemMapping]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_ChargeInfo_SystemMapping](
	[ChargeID] [int] NOT NULL,
	[SystemID] [int] NOT NULL,
 CONSTRAINT [PK_LA_ChargeInfo_SystemMapping] PRIMARY KEY CLUSTERED 
(
	[ChargeID] ASC,
	[SystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [licensee_table]
) ON [licensee_table]

GO
GRANT SELECT ON [dbo].[LA_ChargeInfo_SystemMapping] TO [bodbAdminNet] AS [dbo]
GO

/****** Object:  Table [dbo].[LA_DiscountGroupAssignment]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_DiscountGroupAssignment](
	[DiscountGroupId] [int] NOT NULL,
	[PartyID] [int] NOT NULL,
	[Remark] [nvarchar](4000) NULL,
	[IsApplyDiscount] [bit] NULL,
 CONSTRAINT [DiscountGroupAssignment_PK] PRIMARY KEY CLUSTERED 
(
	[DiscountGroupId] ASC,
	[PartyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO
GRANT SELECT ON [dbo].[LA_DiscountGroupAssignment] TO [bodbAdminNet] AS [dbo]
GO

/****** Object:  Table [dbo].[LA_DiscountGroupCurrency]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_DiscountGroupCurrency](
	[DiscountGroupId] [smallint] NOT NULL,
	[PartyID] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
 CONSTRAINT [PK_LA_DiscountGroupCurrency] PRIMARY KEY CLUSTERED 
(
	[DiscountGroupId] ASC,
	[PartyID] ASC,
	[CurrencyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_DiscountGroupDetail]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_DiscountGroupDetail](
	[DiscountGroupDetailId] [smallint] IDENTITY(1,1) NOT NULL,
	[DiscountGroupId] [smallint] NOT NULL,
	[FromAmount] [money] NULL,
	[ToAmount] [money] NULL,
	[Rate] [money] NOT NULL,
 CONSTRAINT [LA_DiscountGroupDetail_PK] PRIMARY KEY CLUSTERED 
(
	[DiscountGroupDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO
GRANT SELECT ON [dbo].[LA_DiscountGroupDetail] TO [bodbAdminNet] AS [dbo]
GO

/****** Object:  Table [dbo].[LA_DiscountGroupHeader]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_DiscountGroupHeader](
	[DiscountGroupId] [smallint] IDENTITY(1,1) NOT NULL,
	[DiscountGroupName] [nvarchar](110) NULL,
	[DiscountGroupType] [tinyint] NOT NULL,
	[CurrencyId] [tinyint] NOT NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NOT NULL,
	[Priority] [tinyint] NOT NULL,
	[Remark] [nvarchar](4000) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [LA_DiscountGroupHeader_PK] PRIMARY KEY CLUSTERED 
(
	[DiscountGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO
GRANT SELECT ON [dbo].[LA_DiscountGroupHeader] TO [bodbAdminNet] AS [dbo]
GO

/****** Object:  Table [dbo].[LA_DiscountGroupProduct]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_DiscountGroupProduct](
	[DiscountGroupId] [smallint] NOT NULL,
	[ProductId] [tinyint] NOT NULL,
	[CalculationType] [tinyint] NULL,
 CONSTRAINT [DiscountGroupProduct_PK] PRIMARY KEY CLUSTERED 
(
	[DiscountGroupId] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO
GRANT SELECT ON [dbo].[LA_DiscountGroupProduct] TO [bodbAdminNet] AS [dbo]
GO

/****** Object:  Table [dbo].[LA_Function]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_Function](
	[FunctionID] [int] IDENTITY(1,1) NOT NULL,
	[FunctionName] [nvarchar](100) NOT NULL,
	[FunctionDesc] [nvarchar](100) NULL,
	[ParentID] [int] NOT NULL,
	[ParentName] [nvarchar](100) NULL,
	[URL] [varchar](100) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[DisplayOrder] [int] NULL,
	[Creator] [int] NULL,
	[StatusID] [tinyint] NOT NULL,
	[FunctionKey] [nvarchar](50) NULL,
 CONSTRAINT [PK_LA_Function] PRIMARY KEY CLUSTERED 
(
	[FunctionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_FunctionParty]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_FunctionParty](
	[FunctionID] [int] NOT NULL,
	[PartyID] [int] NOT NULL,
 CONSTRAINT [PK_LA_FunctionParty] PRIMARY KEY CLUSTERED 
(
	[FunctionID] ASC,
	[PartyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_Group]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_Group](
	[GroupID] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](100) NOT NULL,
	[GroupDesc] [nvarchar](100) NULL,
	[StatusID] [int] NOT NULL,
	[ModifyDate] [datetime] NULL,
	[Modifier] [int] NULL,
 CONSTRAINT [PK_LA_Group] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_GroupFunction]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_GroupFunction](
	[GroupID] [int] NOT NULL,
	[FunctionID] [int] NOT NULL,
 CONSTRAINT [PK_LA_GroupFunction] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC,
	[FunctionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_MinFee]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_MinFee](
	[MinFeeId] [int] IDENTITY(1,1) NOT NULL,
	[PartyId] [int] NOT NULL,
	[FeeTypeId] [tinyint] NOT NULL,
	[ProductId] [tinyint] NOT NULL,
	[FeeAmount] [money] NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NOT NULL,
	[MinFeeTerm] [nvarchar](4000) NULL,
	[Priority] [tinyint] NOT NULL,
	[CurrencyId] [tinyint] NULL,
	[MonthOfDeduction] [tinyint] NULL,
 CONSTRAINT [PK_LA_MinFee] PRIMARY KEY CLUSTERED 
(
	[MinFeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [licensee_table]
) ON [licensee_table]

GO
GRANT SELECT ON [dbo].[LA_MinFee] TO [bodbAdminNet] AS [dbo]
GO

/****** Object:  Table [dbo].[LA_PartyGroup]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_PartyGroup](
	[PartyGroupId] [smallint] IDENTITY(1,1) NOT NULL,
	[PartyGroupName] [varchar](50) NOT NULL,
 CONSTRAINT [LA_PartyGroup_PK] PRIMARY KEY CLUSTERED 
(
	[PartyGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_PartyGroupAssignment]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_PartyGroupAssignment](
	[PartyGroupId] [smallint] NOT NULL,
	[PartyId] [int] NOT NULL,
 CONSTRAINT [PartyGroupAssignment_PK] PRIMARY KEY CLUSTERED 
(
	[PartyGroupId] ASC,
	[PartyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO
GRANT SELECT ON [dbo].[LA_PartyGroupAssignment] TO [bodbAdminNet] AS [dbo]
GO

/****** Object:  Table [dbo].[LA_Product3rdSub]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_Product3rdSub](
	[Productid] [int] NOT NULL,
	[BettypeRef] [int] NOT NULL,
	[ProductName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_LA_Product3rdSub] PRIMARY KEY CLUSTERED 
(
	[Productid] ASC,
	[BettypeRef] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [licensee_table]
) ON [licensee_table]

GO
GRANT SELECT ON [dbo].[LA_Product3rdSub] TO [bodbAdminNet] AS [dbo]
GO

/****** Object:  Table [dbo].[LA_UserFunction]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_UserFunction](
	[UserID] [int] NOT NULL,
	[FunctionID] [int] NOT NULL,
	[Modifydate] [datetime] NULL,
	[Modifier] [int] NULL,
	[StatusID] [tinyint] NOT NULL,
 CONSTRAINT [PK_LA_UserFunction] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[FunctionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_UserParty]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[LA_UserParty](
	[UserID] [int] NOT NULL,
	[PartyID] [int] NOT NULL,
	[Modifydate] [datetime] NULL,
	[Modifier] [int] NULL,
	[StatusID] [tinyint] NOT NULL,
 CONSTRAINT [PK_LA_UserParty] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[PartyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[OAS_ChargeInfo]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[OAS_ChargeInfo](
	[ChargeID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[FromParty] [int] NOT NULL,
	[ToParty] [int] NOT NULL,
	[ParentChargeID] [int] NOT NULL,
	[Rate] [money] NULL,
	[ChargeType] [tinyint] NULL,
	[FromDate] [date] NULL,
	[ToDate] [date] NULL,
	[MinAmount] [money] NULL,
	[MaxAmount] [money] NULL,
	[Remark] [nvarchar](200) NULL,
	[BaseCurrencyId] [tinyint] NULL,
	[FirstOfBilling] [date] NULL,
	[BasisOfBilling] [nvarchar](4000) NULL,
 CONSTRAINT [PK_OAS_ChargeInfo] PRIMARY KEY CLUSTERED 
(
	[ChargeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [licensee_table]
) ON [licensee_table]

GO
GRANT SELECT ON [dbo].[OAS_ChargeInfo] TO [bodbAdminNet] AS [dbo]
GO

/****** Object:  Table [dbo].[OAS_ChargeInfoSub]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[OAS_ChargeInfoSub](
	[ChargeID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[BettypeRef] [int] NULL,
	[FromParty] [int] NOT NULL,
	[ToParty] [int] NOT NULL,
	[ParentChargeID] [int] NOT NULL,
	[Rate] [money] NULL,
	[ChargeType] [tinyint] NULL,
	[FromDate] [date] NULL,
	[ToDate] [date] NULL,
	[MinAmount] [money] NULL,
	[MaxAmount] [money] NULL,
	[BaseCurrencyId] [tinyint] NULL,
	[FirstOfBilling] [date] NULL,
	[BasisOfBilling] [nvarchar](4000) NULL,
	[ChargeIdRef] [int] NULL,
 CONSTRAINT [PK_OAS_ChargeInfoSub] PRIMARY KEY CLUSTERED 
(
	[ChargeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [licensee_table]
) ON [licensee_table]

GO
GRANT SELECT ON [dbo].[OAS_ChargeInfoSub] TO [bodbAdminNet] AS [dbo]
GO

/****** Object:  Table [dbo].[OAS_Party]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[OAS_Party](
	[PartyID] [int] IDENTITY(1,1) NOT NULL,
	[PartyName] [varchar](50) NULL,
	[Description] [varchar](100) NULL,
	[PartyType] [tinyint] NOT NULL,
	[OldRefID] [int] NULL,
	[SetupName] [varchar](50) NULL,
 CONSTRAINT [PK_OAS_Party] PRIMARY KEY CLUSTERED 
(
	[PartyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [licensee_table]
) ON [licensee_table]

GO
GRANT SELECT ON [dbo].[OAS_Party] TO [bodbAdminNet] AS [dbo]
GO
GRANT SELECT ON [dbo].[OAS_Party] TO [bodbLicenseeNet] AS [dbo]
GO

/****** Object:  Table [dbo].[OAS_PartyDetail]    Script Date: 5/16/2019 10:50:57 PM ******/
CREATE TABLE [dbo].[OAS_PartyDetail](
	[PartyID] [int] NOT NULL,
	[IsDeposit] [bit] NULL,
	[BrandName] [varchar](100) NULL,
	[CompanyName] [nvarchar](100) NULL,
	[IsAllowedMemberComm] [bit] NULL,
	[StatusId] [tinyint] NULL,
	[AttnName] [nvarchar](125) NULL,
	[Description] [nvarchar](255) NULL,
	[Address1] [nvarchar](255) NULL,
	[Address2] [nvarchar](255) NULL,
	[BaseCurrencyId] [tinyint] NULL,
	[InvoiceLanguage] [varchar](7) NULL,
 CONSTRAINT [PK_OAS_PartyDetail] PRIMARY KEY CLUSTERED 
(
	[PartyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [licensee_table]
) ON [licensee_table]

GO
GRANT SELECT ON [dbo].[OAS_PartyDetail] TO [bodbAdminNet] AS [dbo]
GO

ALTER TABLE [dbo].[OAS_PartyDetail] ADD  CONSTRAINT [DF__OAS_Party_Status]  DEFAULT ((1)) FOR [StatusId]
GO