USE [bodb_Licensee]
GO

/*
	Created: 20190510@Percy
	DB: DBCUST.bodb_Licensee, DB053.bodb_Licensee, DB06.bodb_Licensee
	Task: Migrate tables - Initialize data
*/

/****** Object:  Table [dbo].[LA_ChargeInfo_MinFee]    Script Date: 5/16/2019 10:50:57 PM ******/
INSERT INTO [dbo].[LA_ChargeInfo_MinFee]([ChargeID],[MinFee],[MinFeeCurrencyID],[WaiveFrom],[WaiveTo])
SELECT [ChargeID],[MinFee],[MinFeeCurrencyID],[WaiveFrom],[WaiveTo] FROM DB215.bodb_Licensee.dbo.LA_ChargeInfo_MinFee WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_ChargeInfo_SystemMapping]    Script Date: 5/16/2019 10:50:57 PM ******/
INSERT INTO [dbo].[LA_ChargeInfo_SystemMapping]([ChargeID],[SystemID])
SELECT [ChargeID],[SystemID] FROM DB215.bodb_Licensee.dbo.[LA_ChargeInfo_SystemMapping] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_DiscountGroupAssignment]    Script Date: 5/16/2019 10:50:57 PM ******/
INSERT INTO [dbo].[LA_DiscountGroupAssignment]([DiscountGroupId],[PartyID],[Remark],[IsApplyDiscount])
SELECT [DiscountGroupId],[PartyID],[Remark],[IsApplyDiscount] FROM DB215.bodb_Licensee.dbo.[LA_DiscountGroupAssignment] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_DiscountGroupCurrency]    Script Date: 5/16/2019 10:50:57 PM ******/
INSERT INTO [dbo].[LA_DiscountGroupCurrency]([DiscountGroupId],[PartyID],[CurrencyId])
SELECT [DiscountGroupId],[PartyID],[CurrencyId] FROM DB215.bodb_Licensee.dbo.[LA_DiscountGroupCurrency] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_DiscountGroupDetail]    Script Date: 5/16/2019 10:50:57 PM ******/
SET IDENTITY_INSERT [LA_DiscountGroupDetail] ON
INSERT INTO [dbo].[LA_DiscountGroupDetail]([DiscountGroupDetailId],[DiscountGroupId],[FromAmount],[ToAmount],[Rate])
SELECT [DiscountGroupDetailId],[DiscountGroupId],[FromAmount],[ToAmount],[Rate] FROM DB215.bodb_Licensee.dbo.[LA_DiscountGroupDetail] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_DiscountGroupDetail] OFF

/****** Object:  Table [dbo].[LA_DiscountGroupHeader]    Script Date: 5/16/2019 10:50:57 PM ******/
SET IDENTITY_INSERT [LA_DiscountGroupHeader] ON
INSERT INTO [dbo].[LA_DiscountGroupHeader]([DiscountGroupId],[DiscountGroupName],[DiscountGroupType],[CurrencyId],[FromDate],[ToDate],[Priority],[Remark],[ModifiedDate])
SELECT [DiscountGroupId],[DiscountGroupName],[DiscountGroupType],[CurrencyId],[FromDate],[ToDate],[Priority],[Remark],[ModifiedDate] FROM DB215.bodb_Licensee.dbo.[LA_DiscountGroupHeader] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_DiscountGroupHeader] OFF

/****** Object:  Table [dbo].[LA_DiscountGroupProduct]    Script Date: 5/16/2019 10:50:57 PM ******/
INSERT INTO [dbo].[LA_DiscountGroupProduct]([DiscountGroupId],[ProductId],[CalculationType])
SELECT [DiscountGroupId],[ProductId],[CalculationType] FROM DB215.bodb_Licensee.dbo.[LA_DiscountGroupProduct] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_Function]    Script Date: 5/16/2019 10:50:57 PM ******/
SET IDENTITY_INSERT [LA_Function] ON
INSERT INTO [dbo].[LA_Function]([FunctionID],[FunctionName],[FunctionDesc],[ParentID],[ParentName],[URL],[CreatedDate],[ModifiedDate],[DisplayOrder],[Creator],[StatusID],[FunctionKey])
SELECT [FunctionID],[FunctionName],[FunctionDesc],[ParentID],[ParentName],[URL],[CreatedDate],[ModifiedDate],[DisplayOrder],[Creator],[StatusID],[FunctionKey] FROM DB215.bodb_Licensee.dbo.[LA_Function] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_Function] OFF

/****** Object:  Table [dbo].[LA_FunctionParty]    Script Date: 5/16/2019 10:50:57 PM ******/
INSERT INTO [dbo].LA_FunctionParty([FunctionID],[PartyID])
SELECT [FunctionID],[PartyID] FROM DB215.bodb_Licensee.dbo.LA_FunctionParty WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_Group]    Script Date: 5/16/2019 10:50:57 PM ******/
SET IDENTITY_INSERT [LA_Group] ON
INSERT INTO [LA_Group]([GroupID],[GroupName],[GroupDesc],[StatusID],[ModifyDate],[Modifier])
SELECT [GroupID],[GroupName],[GroupDesc],[StatusID],[ModifyDate],[Modifier] FROM DB215.bodb_Licensee.dbo.[LA_Group] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_Group] OFF

/****** Object:  Table [dbo].[LA_GroupFunction]    Script Date: 5/16/2019 10:50:57 PM ******/
INSERT INTO [dbo].[LA_GroupFunction]([GroupID],[FunctionID])
SELECT [GroupID],[FunctionID] FROM DB215.bodb_Licensee.dbo.[LA_GroupFunction] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_MinFee]    Script Date: 5/16/2019 10:50:57 PM ******/
SET IDENTITY_INSERT [LA_MinFee] ON
INSERT INTO [LA_MinFee]([MinFeeId],[PartyId],[FeeTypeId],[ProductId],[FeeAmount],[FromDate],[ToDate],[MinFeeTerm],[Priority],[CurrencyId],[MonthOfDeduction])
SELECT [MinFeeId],[PartyId],[FeeTypeId],[ProductId],[FeeAmount],[FromDate],[ToDate],[MinFeeTerm],[Priority],[CurrencyId],[MonthOfDeduction] FROM DB215.bodb_Licensee.dbo.[LA_MinFee] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_MinFee] OFF

/****** Object:  Table [dbo].[LA_PartyGroup]    Script Date: 5/16/2019 10:50:57 PM ******/
SET IDENTITY_INSERT [LA_PartyGroup] ON
INSERT INTO [LA_PartyGroup]([PartyGroupId],[PartyGroupName])
SELECT [PartyGroupId],[PartyGroupName] FROM DB215.bodb_Licensee.dbo.[LA_PartyGroup] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_PartyGroup] OFF

/****** Object:  Table [dbo].[LA_PartyGroupAssignment]    Script Date: 5/16/2019 10:50:57 PM ******/
INSERT INTO [dbo].[LA_PartyGroupAssignment]([PartyGroupId],[PartyId])
SELECT [PartyGroupId],[PartyId] FROM DB215.bodb_Licensee.dbo.[LA_PartyGroupAssignment] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_Product3rdSub]    Script Date: 5/16/2019 10:50:57 PM ******/
INSERT INTO [dbo].[LA_Product3rdSub]([Productid],[BettypeRef],[ProductName])
SELECT [Productid],[BettypeRef],[ProductName] FROM DB215.bodb_Licensee.dbo.[LA_Product3rdSub] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_UserFunction]    Script Date: 5/16/2019 10:50:57 PM ******/
INSERT INTO [dbo].[LA_UserFunction]([UserID],[FunctionID],[Modifydate],[Modifier],[StatusID])
SELECT [UserID],[FunctionID],[Modifydate],[Modifier],[StatusID] FROM DB215.bodb_Licensee.dbo.[LA_UserFunction] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_UserParty]    Script Date: 5/16/2019 10:50:57 PM ******/
INSERT INTO [dbo].[LA_UserParty]([UserID],[PartyID],[Modifydate],[Modifier],[StatusID])
SELECT [UserID],[PartyID],[Modifydate],[Modifier],[StatusID] FROM DB215.bodb_Licensee.dbo.[LA_UserParty] WITH (NOLOCK)

/****** Object:  Table [dbo].[OAS_ChargeInfo]    Script Date: 5/16/2019 10:50:57 PM ******/
SET IDENTITY_INSERT [OAS_ChargeInfo] ON
INSERT INTO [dbo].[OAS_ChargeInfo]([ChargeID],[ProductID],[FromParty],[ToParty],[ParentChargeID],[Rate],[ChargeType],[FromDate],[ToDate],[MinAmount],[MaxAmount],[Remark],[BaseCurrencyId],[FirstOfBilling],[BasisOfBilling])
SELECT [ChargeID],[ProductID],[FromParty],[ToParty],[ParentChargeID],[Rate],[ChargeType],[FromDate],[ToDate],[MinAmount],[MaxAmount],[Remark],[BaseCurrencyId],[FirstOfBilling],[BasisOfBilling] FROM DB215.bodb_Licensee.dbo.[OAS_ChargeInfo] WITH (NOLOCK)
SET IDENTITY_INSERT [OAS_ChargeInfo] OFF

/****** Object:  Table [dbo].[OAS_ChargeInfoSub]    Script Date: 5/16/2019 10:50:57 PM ******/
SET IDENTITY_INSERT [OAS_ChargeInfoSub] ON
INSERT INTO [dbo].[OAS_ChargeInfoSub]([ChargeID],[ProductID],[BettypeRef],[FromParty],[ToParty],[ParentChargeID],[Rate],[ChargeType],[FromDate],[ToDate],[MinAmount],[MaxAmount],[BaseCurrencyId],[FirstOfBilling],[BasisOfBilling],[ChargeIdRef])
SELECT [ChargeID],[ProductID],[BettypeRef],[FromParty],[ToParty],[ParentChargeID],[Rate],[ChargeType],[FromDate],[ToDate],[MinAmount],[MaxAmount],[BaseCurrencyId],[FirstOfBilling],[BasisOfBilling],[ChargeIdRef] FROM DB215.bodb_Licensee.dbo.[OAS_ChargeInfoSub] WITH (NOLOCK)
SET IDENTITY_INSERT [OAS_ChargeInfoSub] OFF

/****** Object:  Table [dbo].[OAS_Party]    Script Date: 5/16/2019 10:50:57 PM ******/
SET IDENTITY_INSERT [OAS_Party] ON
INSERT INTO [dbo].[OAS_Party]([PartyID],[PartyName],[Description],[PartyType],[OldRefID],[SetupName])
SELECT [PartyID],[PartyName],[Description],[PartyType],[OldRefID],[SetupName] FROM DB215.bodb_Licensee.dbo.[OAS_Party] WITH (NOLOCK)
SET IDENTITY_INSERT [OAS_Party] OFF

/****** Object:  Table [dbo].[OAS_PartyDetail]    Script Date: 5/16/2019 10:50:57 PM ******/
INSERT INTO [dbo].[OAS_PartyDetail]([PartyID],[IsDeposit],[BrandName],[CompanyName],[IsAllowedMemberComm],[StatusId],[AttnName],[Description],[Address1],[Address2],[BaseCurrencyId],[InvoiceLanguage])
SELECT [PartyID],[IsDeposit],[BrandName],[CompanyName],[IsAllowedMemberComm],[StatusId],[AttnName],[Description],[Address1],[Address2],[BaseCurrencyId],[InvoiceLanguage] FROM DB215.bodb_Licensee.dbo.[OAS_PartyDetail] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_InvoiceHeader]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_InvoiceHeader] ON
INSERT INTO [dbo].[LA_InvoiceHeader]([InvoiceHeaderId],[BillerId],[PartyId],[RefNo],[CurrencyId],[InvoiceSymbol],[InvoiceNumber],[FromDate],[ToDate],[InvoiceDate],[DueDate],[Amount],[InvoiceType],[StatusId],[Note],[HasSent],[HasDeleted],[CreatedBy],[CreatedDateTime],[UpdatedDateTime],[IsSeparateProduct],[MaxPCU],[RateAmount],[IsWaived],[InvoicePath],[InvoiceData],[Environment],[UpdatedBy],[OfficialInvoiceNo])
SELECT [InvoiceHeaderId],[BillerId],[PartyId],[RefNo],[CurrencyId],[InvoiceSymbol],[InvoiceNumber],[FromDate],[ToDate],[InvoiceDate],[DueDate],[Amount],[InvoiceType],[StatusId],[Note],[HasSent],[HasDeleted],[CreatedBy],[CreatedDateTime],[UpdatedDateTime],[IsSeparateProduct],[MaxPCU],[RateAmount],[IsWaived],[InvoicePath],[InvoiceData],[Environment],[UpdatedBy],[OfficialInvoiceNo] FROM DB215.bodb_Licensee.dbo.[LA_InvoiceHeader] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_InvoiceHeader] OFF

/****** Object:  Table [dbo].[LA_InvoiceSetting]    Script Date: 5/17/2019 12:52:39 AM ******/
INSERT INTO [dbo].[LA_InvoiceSetting]([FromPartyId],[ToPartyId],[ProductId],[InvTypeId],[InvTempId],[BankId],[ActiveAddress])
SELECT [FromPartyId],[ToPartyId],[ProductId],[InvTypeId],[InvTempId],[BankId],[ActiveAddress] FROM DB215.bodb_Licensee.dbo.[LA_InvoiceSetting] WITH (NOLOCK)

/****** Object:  Table [dbo].[LA_InvoiceStatement]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_InvoiceStatement] ON
INSERT INTO [dbo].[LA_InvoiceStatement]([InvoiceStatementId],[InvoiceHeaderId],[InvItemTypeId],[StatusID],[Description],[Income],[Expense],[RefNo],[RefPartyId],[ProductId])
SELECT [InvoiceStatementId],[InvoiceHeaderId],[InvItemTypeId],[StatusID],[Description],[Income],[Expense],[RefNo],[RefPartyId],[ProductId] FROM DB215.bodb_Licensee.dbo.[LA_InvoiceStatement] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_InvoiceStatement] OFF

/****** Object:  Table [dbo].[LA_InvoiceTemplate]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_InvoiceTemplate] ON
INSERT INTO [dbo].[LA_InvoiceTemplate]([InvTemplateId],[InvTemplateName],[TemplatePath])
SELECT [InvTemplateId],[InvTemplateName],[TemplatePath] FROM DB215.bodb_Licensee.dbo.[LA_InvoiceTemplate] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_InvoiceTemplate] OFF

/****** Object:  Table [dbo].[LA_HostingFees]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_HostingFees] ON
INSERT INTO [dbo].[LA_HostingFees]([HostingFeesId],[HostingFeesName],[HostingFeesTypeId],[BaseCurrencyId],[Description])
SELECT [HostingFeesId],[HostingFeesName],[HostingFeesTypeId],[BaseCurrencyId],[Description] FROM DB215.bodb_Licensee.dbo.[LA_HostingFees] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_HostingFees] OFF

/****** Object:  Table [dbo].[LA_HostingFeesDetail]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_HostingFeesDetail] ON
INSERT INTO [dbo].[LA_HostingFeesDetail]([HostingFeesDetailId],[HostingFeesId],[BaseCurrencyId],[VCMFrom],[VCMTo],[Amount])
SELECT [HostingFeesDetailId],[HostingFeesId],[BaseCurrencyId],[VCMFrom],[VCMTo],[Amount] FROM DB215.bodb_Licensee.dbo.[LA_HostingFeesDetail] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_HostingFeesDetail] OFF

/****** Object:  Table [dbo].[LA_HostingFeesSetting]    Script Date: 5/17/2019 12:52:39 AM ******/
SET IDENTITY_INSERT [LA_HostingFeesSetting] ON
INSERT INTO [dbo].[LA_HostingFeesSetting]([ChargeId],[SettingType],[ParentId],[FromParty],[ToParty],[FromDate],[ToDate],[ProductName],[FirstBilling],[BasisOfBilling],[BaseCurrencyId],[HostingFeesId],[BasedMinimunFees],[Remark])
SELECT [ChargeId],[SettingType],[ParentId],[FromParty],[ToParty],[FromDate],[ToDate],[ProductName],[FirstBilling],[BasisOfBilling],[BaseCurrencyId],[HostingFeesId],[BasedMinimunFees],[Remark] FROM DB215.bodb_Licensee.dbo.[LA_HostingFeesSetting] WITH (NOLOCK)
SET IDENTITY_INSERT [LA_HostingFeesSetting] OFF