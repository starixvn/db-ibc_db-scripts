USE [bodb_Licensee]
GO

/*
	Created: 20190510@Percy
	DB: DBCUST.bodb_Licensee
	Task: Move tables to DBCUST - Create tables
*/

/****** Object:  Table [dbo].[LA_AnalysisFile]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_AnalysisFile](
	[FileId] [int] IDENTITY(1,1) NOT NULL,
	[PartyIds] [varchar](4000) NOT NULL,
	[ProductCodes] [varchar](200) NOT NULL,
	[Filename] [varchar](200) NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[IsSkinView] [bit] NOT NULL,
 CONSTRAINT [PK_FileId] PRIMARY KEY CLUSTERED 
(
	[FileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

/****** Object:  Table [dbo].[LA_BankInfo]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_BankInfo](
	[PartyId] [int] NOT NULL,
	[BankId] [tinyint] NOT NULL,
	[AccountNumber] [nvarchar](50) NULL,
	[BankName] [nvarchar](125) NULL,
	[BankAddress] [nvarchar](255) NULL,
	[IBAN] [nvarchar](50) NULL,
	[BeneficiaryName] [nvarchar](125) NULL,
	[SwiftCode] [nvarchar](50) NULL,
	[CorrespondentBank] [nvarchar](100) NULL,
	[CorrespondentAccountNumber] [nvarchar](50) NULL,
	[CorrespondentAddress] [nvarchar](255) NULL,
	[CorrespondentSwiftCode] [nvarchar](50) NULL,
 CONSTRAINT [LA_BankInfo_pk] PRIMARY KEY CLUSTERED 
(
	[PartyId] ASC,
	[BankId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_BillerInfo]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_BillerInfo](
	[PartyId] [int] NOT NULL,
	[BillerName] [nvarchar](50) NULL,
	[BillerFullName] [nvarchar](50) NULL,
	[StatusId] [tinyint] NOT NULL,
	[CompanyName] [nvarchar](100) NULL,
	[Address1] [nvarchar](255) NULL,
	[Address2] [nvarchar](255) NULL,
	[LogoPath] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[Logo] [varbinary](max) NULL,
	[LogoHeight] [int] NULL,
	[LogoWidth] [int] NULL,
 CONSTRAINT [BillerInfo_PK] PRIMARY KEY CLUSTERED 
(
	[PartyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA] TEXTIMAGE_ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_CombinedGroup]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_CombinedGroup](
	[GroupId] [smallint] IDENTITY(1,1) NOT NULL,
	[GroupName] [varchar](50) NOT NULL,
	[PathCode] [varchar](50) NOT NULL,
 CONSTRAINT [PK_LA_CombinedGroup] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

/****** Object:  Table [dbo].[LA_CombinedGroupAssignment]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_CombinedGroupAssignment](
	[GroupId] [smallint] NOT NULL,
	[PartyId] [int] NOT NULL,
	[GroupType] [tinyint] NOT NULL,
 CONSTRAINT [PK_LA_CombinedGroupAssignment] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC,
	[PartyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

/****** Object:  Table [dbo].[LA_HostingFees]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_HostingFees](
	[HostingFeesId] [int] IDENTITY(1,1) NOT NULL,
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

/****** Object:  Table [dbo].[LA_HostingFeesDetail]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_HostingFeesDetail](
	[HostingFeesDetailId] [int] IDENTITY(1,1) NOT NULL,
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

/****** Object:  Table [dbo].[LA_HostingFeesSetting]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_HostingFeesSetting](
	[ChargeId] [int] IDENTITY(1,1) NOT NULL,
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

/****** Object:  Table [dbo].[LA_HostingFeesTypes]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_HostingFeesTypes](
	[HostingFeesTypeId] [tinyint] IDENTITY(1,1) NOT NULL,
	[HostingFeesTypeName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_LA_HostingFeesTypes] PRIMARY KEY CLUSTERED 
(
	[HostingFeesTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [licensee_table]
) ON [licensee_table]

GO

/****** Object:  Table [dbo].[LA_InvoiceDetail]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_InvoiceDetail](
	[InvoiceDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[InvoiceHeaderId] [bigint] NOT NULL,
	[Description] [nvarchar](200) NULL,
	[Reference] [nvarchar](100) NULL,
	[ProductId] [int] NULL,
	[AmountType] [tinyint] NULL,
	[InvoiceAmount] [money] NULL,
 CONSTRAINT [LA_InvoiceDetail_PK] PRIMARY KEY CLUSTERED 
(
	[InvoiceDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_INDEX]
) ON [OWA_INDEX]

GO

/****** Object:  Table [dbo].[LA_InvoiceFile]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_InvoiceFile](
	[InvoiceHeaderId] [int] NOT NULL,
	[FileData] [varbinary](max) NOT NULL,
 CONSTRAINT [PK_LA_InvoiceFile] PRIMARY KEY CLUSTERED 
(
	[InvoiceHeaderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA] TEXTIMAGE_ON [DATA]

GO

/****** Object:  Table [dbo].[LA_InvoiceHeader]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_InvoiceHeader](
	[InvoiceHeaderId] [bigint] IDENTITY(1,1) NOT NULL,
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

/****** Object:  Table [dbo].[LA_InvoiceSetting]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_InvoiceSetting](
	[InvSettingId] [int] NOT NULL,
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

/****** Object:  Table [dbo].[LA_InvoiceStatement]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_InvoiceStatement](
	[InvoiceStatementId] [bigint] IDENTITY(1,1) NOT NULL,
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

/****** Object:  Table [dbo].[LA_InvoiceTemplate]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_InvoiceTemplate](
	[InvTemplateId] [smallint] IDENTITY(1,1) NOT NULL,
	[InvTemplateName] [varchar](50) NOT NULL,
	[TemplatePath] [varchar](255) NULL,
 CONSTRAINT [LA_InvoiceTemplate_PK] PRIMARY KEY CLUSTERED 
(
	[InvTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_InvoiceType]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_InvoiceType](
	[InvTypeId] [smallint] IDENTITY(1,1) NOT NULL,
	[InvTypeName] [varchar](50) NOT NULL,
	[IsVisible] [bit] NULL,
 CONSTRAINT [LA_InvoiceType_PK] PRIMARY KEY CLUSTERED 
(
	[InvTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_InvoiceTypeMapping]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_InvoiceTypeMapping](
	[InvTypeId] [smallint] NOT NULL,
	[InvItemTypeId] [smallint] NOT NULL,
 CONSTRAINT [PK_LA_InvoiceTypeMapping] PRIMARY KEY CLUSTERED 
(
	[InvTypeId] ASC,
	[InvItemTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_OnUser]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_OnUser](
	[Custid] [int] NULL,
	[Reload_time] [smalldatetime] NULL,
	[On_userid] [int] IDENTITY(1,1) NOT NULL,
	[IP] [nvarchar](100) NULL,
	[iskickedout] [bit] NULL,
	[NetSessionID] [varchar](30) NULL,
 CONSTRAINT [PK_OnUserID] PRIMARY KEY NONCLUSTERED 
(
	[On_userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_SettingGroupAssignment]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_SettingGroupAssignment](
	[SettingGroupAssignmentId] [int] IDENTITY(1,1) NOT NULL,
	[SettingGroupHeaderId] [int] NULL,
	[PartyId] [int] NULL,
	[FromDate] [smalldatetime] NULL,
	[ToDate] [smalldatetime] NULL,
	[Status] [varchar](20) NULL,
 CONSTRAINT [LA_SettingGroupAssignment_PK] PRIMARY KEY CLUSTERED 
(
	[SettingGroupAssignmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_SettingGroupDetail]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_SettingGroupDetail](
	[SettingGroupDetailId] [int] IDENTITY(1,1) NOT NULL,
	[SettingGroupHeaderId] [int] NULL,
	[CurrencyId] [int] NULL,
	[TargetAmount] [money] NULL,
	[Period] [smallint] NULL,
	[Rate] [money] NULL,
	[FromDate] [smalldatetime] NULL,
	[ToDate] [smalldatetime] NULL,
	[RestartDate] [smalldatetime] NULL,
	[Status] [varchar](20) NULL,
 CONSTRAINT [LA_SettingGroupDetail_PK] PRIMARY KEY CLUSTERED 
(
	[SettingGroupDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_SettingGroupHeader]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_SettingGroupHeader](
	[SettingGroupHeaderId] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](50) NULL,
	[SettingGroupType] [tinyint] NULL,
	[Note] [nvarchar](500) NULL,
 CONSTRAINT [LA_SettingGroupHeader_PK] PRIMARY KEY CLUSTERED 
(
	[SettingGroupHeaderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[LA_SystemSettings]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_SystemSettings](
	[Key] [varchar](100) NOT NULL,
	[Value] [varchar](4000) NOT NULL,
 CONSTRAINT [PK_LA_SystemSettings] PRIMARY KEY CLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO

/****** Object:  Table [dbo].[LA_User]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[LA_User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [int] NOT NULL,
	[Username] [varchar](50) NOT NULL,
	[UserPwd] [varchar](50) NOT NULL,
	[DisplayName] [nvarchar](100) NOT NULL,
	[UserSalt] [varchar](50) NOT NULL,
	[StatusID] [tinyint] NULL,
	[Creator] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_LA_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

/****** Object:  Table [dbo].[OAS_OnUser]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[OAS_OnUser](
	[custid] [int] NULL,
	[reload_time] [smalldatetime] NULL,
	[on_userid] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[IP] [nvarchar](50) NOT NULL,
	[iskickedout] [bit] NULL,
	[NetSessionID] [varchar](30) NOT NULL,
 CONSTRAINT [PK_OAS_OnUser] PRIMARY KEY NONCLUSTERED 
(
	[on_userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

ALTER TABLE [dbo].[OAS_OnUser] ADD  CONSTRAINT [DF_OAS_OnUser_reload_time]  DEFAULT (getdate()) FOR [reload_time]
GO
ALTER TABLE [dbo].[OAS_OnUser] ADD  CONSTRAINT [DF_OAS_OnUser_IP]  DEFAULT (N'') FOR [IP]
GO
ALTER TABLE [dbo].[OAS_OnUser] ADD  CONSTRAINT [DF_OAS_OnUser_iskickedout]  DEFAULT ((0)) FOR [iskickedout]
GO
ALTER TABLE [dbo].[OAS_OnUser] ADD  CONSTRAINT [DF_OAS_OnUser_NetSessionID]  DEFAULT ('') FOR [NetSessionID]
GO

GRANT SELECT ON [dbo].[OAS_OnUser] TO [bodbAdminNet] AS [dbo]
GO


/****** Object:  Table [dbo].[OAS_Users]    Script Date: 5/17/2019 12:52:39 AM ******/
CREATE TABLE [dbo].[OAS_Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NOT NULL,
	[UserPwd] [varchar](50) NOT NULL,
	[DisplayName] [nvarchar](50) NULL,
	[Role] [tinyint] NOT NULL,
	[UserSalt] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[Creator] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[IsTest] [bit] NOT NULL,
 CONSTRAINT [PK_SpNames] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [OWA_DATA]
) ON [OWA_DATA]

GO

ALTER TABLE [dbo].[OAS_Users] ADD  DEFAULT ((0)) FOR [IsTest]
GO

GRANT SELECT ON [dbo].[OAS_Users] TO [bodbAdminNet] AS [dbo]
GO

--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: Hosting Fees, 2: Waive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LA_HostingFeesSetting', @level2type=N'COLUMN',@level2name=N'SettingType'
--GO
--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Use in Waive setting, store ChargeId of Hosting Fees' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LA_HostingFeesSetting', @level2type=N'COLUMN',@level2name=N'ParentId'
--GO
--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Store "Hosting"' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LA_HostingFeesSetting', @level2type=N'COLUMN',@level2name=N'ProductName'
--GO
--EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'store ProductId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LA_HostingFeesSetting', @level2type=N'COLUMN',@level2name=N'BasedMinimunFees'
--GO