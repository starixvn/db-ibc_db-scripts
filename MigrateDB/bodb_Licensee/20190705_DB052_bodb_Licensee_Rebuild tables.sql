-- DB052.bodb_Licensee
USE [bodb_Licensee]
GO

/*
	Created: 20190705@Percy
	DB: DB052.bodb_Licensee
	Task: Re-build tables on DB052.bodb_Licensee
*/



--- Step 1. Rename tables to DEL_XXX
-- 28 migrate tables + 19 move tables = 47 tables


-- 1.1 migrate tables
-- 13 
sp_rename 'LA_ChargeInfo_MinFee', 'DEL_LA_ChargeInfo_MinFee'
go

-- 14 
sp_rename 'LA_ChargeInfo_SystemMapping', 'DEL_LA_ChargeInfo_SystemMapping'
go

-- 17 
sp_rename 'LA_DiscountGroupAssignment', 'DEL_LA_DiscountGroupAssignment'
go

-- 18 
sp_rename 'LA_DiscountGroupCurrency', 'DEL_LA_DiscountGroupCurrency'
go

-- 19 
sp_rename 'LA_DiscountGroupDetail', 'DEL_LA_DiscountGroupDetail'
go

-- 20 
sp_rename 'LA_DiscountGroupHeader', 'DEL_LA_DiscountGroupHeader'
go

-- 21 
sp_rename 'LA_DiscountGroupProduct', 'DEL_LA_DiscountGroupProduct'
go

-- 22 
sp_rename 'LA_Function', 'DEL_LA_Function'
go

-- 23 
sp_rename 'LA_FunctionParty', 'DEL_LA_FunctionParty'
go

-- 24 
sp_rename 'LA_Group', 'DEL_LA_Group'
go

-- 25 
sp_rename 'LA_GroupFunction', 'DEL_LA_GroupFunction'
go

-- 26 
sp_rename 'LA_HostingFees', 'DEL_LA_HostingFees'
go

-- 27 
sp_rename 'LA_HostingFeesDetail', 'DEL_LA_HostingFeesDetail'
go

-- 28 
sp_rename 'LA_HostingFeesSetting', 'DEL_LA_HostingFeesSetting'
go

-- 32 
sp_rename 'LA_InvoiceHeader', 'DEL_LA_InvoiceHeader'
go

-- 34 
sp_rename 'LA_InvoiceSetting', 'DEL_LA_InvoiceSetting'
go

-- 35 
sp_rename 'LA_InvoiceStatement', 'DEL_LA_InvoiceStatement'
go

-- 36 
sp_rename 'LA_InvoiceTemplate', 'DEL_LA_InvoiceTemplate'
go

-- 40 
sp_rename 'LA_MinFee', 'DEL_LA_MinFee'
go

-- 42 
sp_rename 'LA_PartyGroup', 'DEL_LA_PartyGroup'
go

-- 43 
sp_rename 'LA_PartyGroupAssignment', 'DEL_LA_PartyGroupAssignment'
go

-- 44 
sp_rename 'LA_Product3rdSub', 'DEL_LA_Product3rdSub'
go

-- 50 
sp_rename 'LA_UserFunction', 'DEL_LA_UserFunction'
go

-- 51 
sp_rename 'LA_UserParty', 'DEL_LA_UserParty'
go

-- 76 
sp_rename 'OAS_ChargeInfo', 'DEL_OAS_ChargeInfo'
go

-- 77 
sp_rename 'OAS_ChargeInfoSub', 'DEL_OAS_ChargeInfoSub'
go

-- 81 
sp_rename 'OAS_Party', 'DEL_OAS_Party'
go

-- 82 
sp_rename 'OAS_PartyDetail', 'DEL_OAS_PartyDetail'
go



-- 1.2 move tables
-- 10 
sp_rename 'LA_AnalysisFile', 'DEL_LA_AnalysisFile'
go

-- 11 
sp_rename 'LA_BankInfo', 'DEL_LA_BankInfo'
go

-- 12 
sp_rename 'LA_BillerInfo', 'DEL_LA_BillerInfo'
go

-- 15 
sp_rename 'LA_CombinedGroup', 'DEL_LA_CombinedGroup'
go

-- 16 
sp_rename 'LA_CombinedGroupAssignment', 'DEL_LA_CombinedGroupAssignment'
go

-- 29 
sp_rename 'LA_HostingFeesTypes', 'DEL_LA_HostingFeesTypes'
go

-- 30 
sp_rename 'LA_InvoiceDetail', 'DEL_LA_InvoiceDetail'
go

-- 31 
sp_rename 'LA_InvoiceFile', 'DEL_LA_InvoiceFile'
go

-- 33 
sp_rename 'LA_InvoiceItemType', 'DEL_LA_InvoiceItemType'
go

-- 37 
sp_rename 'LA_InvoiceType', 'DEL_LA_InvoiceType'
go

-- 38 
sp_rename 'LA_InvoiceTypeMapping', 'DEL_LA_InvoiceTypeMapping'
go

-- 41 
sp_rename 'LA_OnUser', 'DEL_LA_OnUser'
go

-- 45 
sp_rename 'LA_SettingGroupAssignment', 'DEL_LA_SettingGroupAssignment'
go

-- 46 
sp_rename 'LA_SettingGroupDetail', 'DEL_LA_SettingGroupDetail'
go

-- 47 
sp_rename 'LA_SettingGroupHeader', 'DEL_LA_SettingGroupHeader'
go

-- 48 
sp_rename 'LA_SystemSettings', 'DEL_LA_SystemSettings'
go

-- 49 
sp_rename 'LA_User', 'DEL_LA_User'
go

-- 80 
sp_rename 'OAS_OnUser', 'DEL_OAS_OnUser'
go

-- 85 
sp_rename 'OAS_Users', 'DEL_OAS_Users'
go


-- Step 2: create tables
-- 28 migrate tables = 28 tables

-- 13
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

-- 14
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

-- 17
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

-- 18
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

-- 19
CREATE TABLE [dbo].[LA_DiscountGroupDetail](
	[DiscountGroupDetailId] [smallint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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

-- 20
CREATE TABLE [dbo].[LA_DiscountGroupHeader](
	[DiscountGroupId] [smallint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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

-- 21
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

-- 22
CREATE TABLE [dbo].[LA_Function](
	[FunctionID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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

-- 23
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

-- 24
CREATE TABLE [dbo].[LA_Group](
	[GroupID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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

-- 25
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

-- 26
CREATE TABLE [dbo].[LA_HostingFees](
	[HostingFeesId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HostingFeesName] [varchar](200) NOT NULL,
	[HostingFeesTypeId] [tinyint] NOT NULL,
	[BaseCurrencyId] [int] NOT NULL,
	[Description] [nvarchar](200) NULL,
 CONSTRAINT [PK_LA_HostingFees] PRIMARY KEY CLUSTERED 
(
	[HostingFeesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [licensee_table]
) ON [licensee_table]

GO

-- 27
CREATE TABLE [dbo].[LA_HostingFeesDetail](
	[HostingFeesDetailId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HostingFeesId] [int] NOT NULL,
	[BaseCurrencyId] [int] NOT NULL,
	[VCMFrom] [int] NULL,
	[VCMTo] [int] NULL,
	[Amount] [money] NOT NULL,
 CONSTRAINT [PK_LA_HostingFeesDetail] PRIMARY KEY CLUSTERED 
(
	[HostingFeesDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [licensee_table]
) ON [licensee_table]

GO

-- 28
CREATE TABLE [dbo].[LA_HostingFeesSetting](
	[ChargeId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SettingType] [tinyint] NOT NULL,
	[ParentId] [int] NULL,
	[FromParty] [int] NOT NULL,
	[ToParty] [int] NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	[ProductName] [varchar](50) NULL,
	[FirstBilling] [datetime] NULL,
	[BasisOfBilling] [nvarchar](200) NULL,
	[BaseCurrencyId] [int] NULL,
	[HostingFeesId] [int] NULL,
	[BasedMinimunFees] [int] NULL,
	[Remark] [varchar](200) NULL,
 CONSTRAINT [PK_LA_HostingFeesSetting] PRIMARY KEY CLUSTERED 
(
	[ChargeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [licensee_table]
) ON [licensee_table]

GO

-- 32
CREATE TABLE [dbo].[LA_InvoiceHeader](
	[InvoiceHeaderId] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BillerId] [int] NOT NULL,
	[PartyId] [int] NOT NULL,
	[RefNo] [bigint] NULL,
	[CurrencyId] [int] NOT NULL,
	[InvoiceSymbol] [nvarchar](20) NULL,
	[InvoiceNumber] [int] NOT NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[InvoiceDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[Amount] [money] NULL,
	[InvoiceType] [smallint] NULL,
	[StatusId] [smallint] NULL,
	[Note] [nvarchar](200) NULL,
	[HasSent] [bit] NULL,
	[HasDeleted] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[IsSeparateProduct] [bit] NULL,
	[MaxPCU] [int] NULL,
	[RateAmount] [money] NULL,
	[IsWaived] [bit] NULL,
	[InvoicePath] [nvarchar](255) NULL,
	[InvoiceData] [nvarchar](max) NULL,
	[Environment] [varchar](50) NULL,
	[UpdatedBy] [int] NULL,
	[OfficialInvoiceNo] [nvarchar](50) NULL,
 CONSTRAINT [LA_InvoiceHeader_PK] PRIMARY KEY CLUSTERED 
(
	[InvoiceHeaderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_INDEX]
) ON [OWA_INDEX] TEXTIMAGE_ON [OWA_INDEX]

GO

-- 34
CREATE TABLE [dbo].[LA_InvoiceSetting](
	[InvSettingId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FromPartyId] [int] NOT NULL,
	[ToPartyId] [int] NOT NULL,
	[ProductId] [tinyint] NULL,
	[InvTypeId] [smallint] NOT NULL,
	[InvTempId] [smallint] NULL,
	[BankId] [tinyint] NULL,
	[ActiveAddress] [tinyint] NULL,
 CONSTRAINT [PK_LA_InvoiceSetting] PRIMARY KEY NONCLUSTERED 
(
	[InvSettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

CREATE UNIQUE CLUSTERED INDEX [CIXUM_LA_InvoiceSetting_FromPartyId] ON [dbo].[LA_InvoiceSetting]
(
	[FromPartyId] ASC,
	[ToPartyId] ASC,
	[InvTypeId] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

-- 35
CREATE TABLE [dbo].[LA_InvoiceStatement](
	[InvoiceStatementId] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[InvoiceHeaderId] [bigint] NOT NULL,
	[InvItemTypeId] [smallint] NULL,
	[StatusID] [smallint] NULL,
	[Description] [nvarchar](500) NULL,
	[Income] [money] NULL,
	[Expense] [money] NULL,
	[RefNo] [nvarchar](50) NULL,
	[RefPartyId] [int] NULL,
	[ProductId] [int] NULL,
 CONSTRAINT [PK_LA_InvoiceStatement] PRIMARY KEY CLUSTERED 
(
	[InvoiceStatementId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

-- 36
CREATE TABLE [dbo].[LA_InvoiceTemplate](
	[InvTemplateId] [smallint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[InvTemplateName] [varchar](50) NOT NULL,
	[TemplatePath] [varchar](255) NULL,
 CONSTRAINT [LA_InvoiceTemplate_PK] PRIMARY KEY CLUSTERED 
(
	[InvTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

-- 40
CREATE TABLE [dbo].[LA_MinFee](
	[MinFeeId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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

-- 42
CREATE TABLE [dbo].[LA_PartyGroup](
	[PartyGroupId] [smallint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PartyGroupName] [varchar](50) NOT NULL,
 CONSTRAINT [LA_PartyGroup_PK] PRIMARY KEY CLUSTERED 
(
	[PartyGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

-- 43
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

-- 44
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

-- 50
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

-- 51
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

-- 76
CREATE TABLE [dbo].[OAS_ChargeInfo](
	[ChargeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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

-- 77
CREATE TABLE [dbo].[OAS_ChargeInfoSub](
	[ChargeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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

-- 81
CREATE TABLE [dbo].[OAS_Party](
	[PartyID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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

-- 82
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