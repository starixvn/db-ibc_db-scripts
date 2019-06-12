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