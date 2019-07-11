-- DBCUST
USE [bodb_Licensee]
GO

/*
	Created: 20190705@Percy
	DB: DBCUST.bodb_Licensee
	Task: Initialize data on DBCUST.bodb_Licensee
*/

-- 28 migrated tables + 19 moved tables = 47 tables

INSERT INTO [dbo].[LA_ChargeInfo_MinFee]([ChargeID],[MinFee],[MinFeeCurrencyID],[WaiveFrom],[WaiveTo])
SELECT [ChargeID],[MinFee],[MinFeeCurrencyID],[WaiveFrom],[WaiveTo]
FROM DB052.bodb_Licensee.dbo.LIC_LIC_LA_ChargeInfo_MinFee WITH (NOLOCK)

INSERT INTO [dbo].[LA_ChargeInfo_SystemMapping]([ChargeID],[SystemID])
SELECT [ChargeID],[SystemID]
FROM DB052.bodb_Licensee.dbo.LIC_LA_ChargeInfo_SystemMapping WITH (NOLOCK)

INSERT INTO [dbo].[LA_DiscountGroupAssignment]([DiscountGroupId],[PartyID],[Remark],[IsApplyDiscount])
SELECT [DiscountGroupId],[PartyID],[Remark],[IsApplyDiscount]
FROM DB052.bodb_Licensee.dbo.LIC_LA_DiscountGroupAssignment WITH (NOLOCK)

INSERT INTO [dbo].[LA_DiscountGroupCurrency]([DiscountGroupId],[PartyID],[CurrencyId])
SELECT [DiscountGroupId],[PartyID],[CurrencyId]
FROM DB052.bodb_Licensee.dbo.LIC_LA_DiscountGroupCurrency WITH (NOLOCK)

SET IDENTITY_INSERT [LA_DiscountGroupDetail] ON
INSERT INTO [dbo].[LA_DiscountGroupDetail]([DiscountGroupDetailId],[DiscountGroupId],[FromAmount],[ToAmount],[Rate])
SELECT [DiscountGroupDetailId],[DiscountGroupId],[FromAmount],[ToAmount],[Rate]
FROM DB052.bodb_Licensee.dbo.LIC_LA_DiscountGroupDetail WITH (NOLOCK)
SET IDENTITY_INSERT [LA_DiscountGroupDetail] OFF

SET IDENTITY_INSERT [LA_DiscountGroupHeader] ON
INSERT INTO [dbo].[LA_DiscountGroupHeader]([DiscountGroupId],[DiscountGroupName],[DiscountGroupType],[CurrencyId],[FromDate],[ToDate],[Priority],[Remark],[ModifiedDate])
SELECT [DiscountGroupId],[DiscountGroupName],[DiscountGroupType],[CurrencyId],[FromDate],[ToDate],[Priority],[Remark],[ModifiedDate]
FROM DB052.bodb_Licensee.dbo.LIC_LA_DiscountGroupHeader WITH (NOLOCK)
SET IDENTITY_INSERT [LA_DiscountGroupHeader] OFF

INSERT INTO [dbo].[LA_DiscountGroupProduct]([DiscountGroupId],[ProductId],[CalculationType])
SELECT [DiscountGroupId],[ProductId],[CalculationType]
FROM DB052.bodb_Licensee.dbo.LIC_LA_DiscountGroupProduct WITH (NOLOCK)

SET IDENTITY_INSERT [LA_Function] ON
INSERT INTO [dbo].[LA_Function]([FunctionID],[FunctionName],[FunctionDesc],[ParentID],[ParentName],[URL],[CreatedDate],[ModifiedDate],[DisplayOrder],[Creator],[StatusID],[FunctionKey])
SELECT [FunctionID],[FunctionName],[FunctionDesc],[ParentID],[ParentName],[URL],[CreatedDate],[ModifiedDate],[DisplayOrder],[Creator],[StatusID],[FunctionKey]
FROM DB052.bodb_Licensee.dbo.LIC_LA_Function WITH (NOLOCK)
SET IDENTITY_INSERT [LA_Function] OFF

INSERT INTO [dbo].LA_FunctionParty([FunctionID],[PartyID])
SELECT [FunctionID],[PartyID]
FROM DB052.bodb_Licensee.dbo.LIC_LA_FunctionParty WITH (NOLOCK)

SET IDENTITY_INSERT [LA_Group] ON
INSERT INTO [LA_Group]([GroupID],[GroupName],[GroupDesc],[StatusID],[ModifyDate],[Modifier])
SELECT [GroupID],[GroupName],[GroupDesc],[StatusID],[ModifyDate],[Modifier]
FROM DB052.bodb_Licensee.dbo.LIC_LA_Group WITH (NOLOCK)
SET IDENTITY_INSERT [LA_Group] OFF

INSERT INTO [dbo].[LA_GroupFunction]([GroupID],[FunctionID])
SELECT [GroupID],[FunctionID]
FROM DB052.bodb_Licensee.dbo.LIC_LA_GroupFunction WITH (NOLOCK)

SET IDENTITY_INSERT [LA_MinFee] ON
INSERT INTO [LA_MinFee]([MinFeeId],[PartyId],[FeeTypeId],[ProductId],[FeeAmount],[FromDate],[ToDate],[MinFeeTerm],[Priority],[CurrencyId],[MonthOfDeduction])
SELECT [MinFeeId],[PartyId],[FeeTypeId],[ProductId],[FeeAmount],[FromDate],[ToDate],[MinFeeTerm],[Priority],[CurrencyId],[MonthOfDeduction]
FROM DB052.bodb_Licensee.dbo.LIC_LA_MinFee WITH (NOLOCK)
SET IDENTITY_INSERT [LA_MinFee] OFF

SET IDENTITY_INSERT [LA_PartyGroup] ON
INSERT INTO [LA_PartyGroup]([PartyGroupId],[PartyGroupName])
SELECT [PartyGroupId],[PartyGroupName]
FROM DB052.bodb_Licensee.dbo.LIC_LA_PartyGroup WITH (NOLOCK)
SET IDENTITY_INSERT [LA_PartyGroup] OFF

INSERT INTO [dbo].[LA_PartyGroupAssignment]([PartyGroupId],[PartyId])
SELECT [PartyGroupId],[PartyId]
FROM DB052.bodb_Licensee.dbo.LIC_LA_PartyGroupAssignment WITH (NOLOCK)

INSERT INTO [dbo].[LA_Product3rdSub]([Productid],[BettypeRef],[ProductName])
SELECT [Productid],[BettypeRef],[ProductName]
FROM DB052.bodb_Licensee.dbo.LIC_LA_Product3rdSub WITH (NOLOCK)

INSERT INTO [dbo].[LA_UserFunction]([UserID],[FunctionID],[Modifydate],[Modifier],[StatusID])
SELECT [UserID],[FunctionID],[Modifydate],[Modifier],[StatusID]
FROM DB052.bodb_Licensee.dbo.LIC_LA_UserFunction WITH (NOLOCK)

INSERT INTO [dbo].[LA_UserParty]([UserID],[PartyID],[Modifydate],[Modifier],[StatusID])
SELECT [UserID],[PartyID],[Modifydate],[Modifier],[StatusID]
FROM DB052.bodb_Licensee.dbo.LIC_LA_UserParty WITH (NOLOCK)

SET IDENTITY_INSERT [OAS_ChargeInfo] ON
INSERT INTO [dbo].[OAS_ChargeInfo]([ChargeID],[ProductID],[FromParty],[ToParty],[ParentChargeID],[Rate],[ChargeType],[FromDate],[ToDate],[MinAmount],[MaxAmount],[Remark],[BaseCurrencyId],[FirstOfBilling],[BasisOfBilling])
SELECT [ChargeID],[ProductID],[FromParty],[ToParty],[ParentChargeID],[Rate],[ChargeType],[FromDate],[ToDate],[MinAmount],[MaxAmount],[Remark],[BaseCurrencyId],[FirstOfBilling],[BasisOfBilling]
FROM DB052.bodb_Licensee.dbo.LIC_OAS_ChargeInfo WITH (NOLOCK)
SET IDENTITY_INSERT [OAS_ChargeInfo] OFF

SET IDENTITY_INSERT [OAS_ChargeInfoSub] ON
INSERT INTO [dbo].[OAS_ChargeInfoSub]([ChargeID],[ProductID],[BettypeRef],[FromParty],[ToParty],[ParentChargeID],[Rate],[ChargeType],[FromDate],[ToDate],[MinAmount],[MaxAmount],[BaseCurrencyId],[FirstOfBilling],[BasisOfBilling],[ChargeIdRef])
SELECT [ChargeID],[ProductID],[BettypeRef],[FromParty],[ToParty],[ParentChargeID],[Rate],[ChargeType],[FromDate],[ToDate],[MinAmount],[MaxAmount],[BaseCurrencyId],[FirstOfBilling],[BasisOfBilling],[ChargeIdRef]
FROM DB052.bodb_Licensee.dbo.LIC_OAS_ChargeInfoSub WITH (NOLOCK)
SET IDENTITY_INSERT [OAS_ChargeInfoSub] OFF

SET IDENTITY_INSERT [OAS_Party] ON
INSERT INTO [dbo].[OAS_Party]([PartyID],[PartyName],[Description],[PartyType],[OldRefID],[SetupName])
SELECT [PartyID],[PartyName],[Description],[PartyType],[OldRefID],[SetupName]
FROM DB052.bodb_Licensee.dbo.LIC_OAS_Party WITH (NOLOCK)
SET IDENTITY_INSERT [OAS_Party] OFF

INSERT INTO [dbo].[OAS_PartyDetail]([PartyID],[IsDeposit],[BrandName],[CompanyName],[IsAllowedMemberComm],[StatusId],[AttnName],[Description],[Address1],[Address2],[BaseCurrencyId],[InvoiceLanguage])
SELECT [PartyID],[IsDeposit],[BrandName],[CompanyName],[IsAllowedMemberComm],[StatusId],[AttnName],[Description],[Address1],[Address2],[BaseCurrencyId],[InvoiceLanguage]
FROM DB052.bodb_Licensee.dbo.LIC_OAS_PartyDetail WITH (NOLOCK)
WHERE [PartyID] <> 51

SET IDENTITY_INSERT [LA_InvoiceHeader] ON
INSERT INTO [dbo].[LA_InvoiceHeader]([InvoiceHeaderId],[BillerId],[PartyId],[RefNo],[CurrencyId],[InvoiceSymbol],[InvoiceNumber],[FromDate],[ToDate],[InvoiceDate],[DueDate],[Amount],[InvoiceType],[StatusId],[Note],[HasSent],[HasDeleted],[CreatedBy],[CreatedDateTime],[UpdatedDateTime],[IsSeparateProduct],[MaxPCU],[RateAmount],[IsWaived],[InvoicePath],[InvoiceData],[Environment],[UpdatedBy],[OfficialInvoiceNo])
SELECT [InvoiceHeaderId],[BillerId],[PartyId],[RefNo],[CurrencyId],[InvoiceSymbol],[InvoiceNumber],[FromDate],[ToDate],[InvoiceDate],[DueDate],[Amount],[InvoiceType],[StatusId],[Note],[HasSent],[HasDeleted],[CreatedBy],[CreatedDateTime],[UpdatedDateTime],[IsSeparateProduct],[MaxPCU],[RateAmount],[IsWaived],[InvoicePath],[InvoiceData],[Environment],[UpdatedBy],[OfficialInvoiceNo]
FROM DB052.bodb_Licensee.dbo.LIC_LA_InvoiceHeader WITH (NOLOCK)
SET IDENTITY_INSERT [LA_InvoiceHeader] OFF

SET IDENTITY_INSERT [LA_InvoiceSetting] ON
INSERT INTO [dbo].[LA_InvoiceSetting]([FromPartyId],[ToPartyId],[ProductId],[InvTypeId],[InvTempId],[BankId],[ActiveAddress])
SELECT [FromPartyId],[ToPartyId],[ProductId],[InvTypeId],[InvTempId],[BankId],[ActiveAddress]
FROM DB052.bodb_Licensee.dbo.LIC_LA_InvoiceSetting WITH (NOLOCK)
SET IDENTITY_INSERT [LA_InvoiceSetting] OFF

SET IDENTITY_INSERT [LA_InvoiceStatement] ON
INSERT INTO [dbo].[LA_InvoiceStatement]([InvoiceStatementId],[InvoiceHeaderId],[InvItemTypeId],[StatusID],[Description],[Income],[Expense],[RefNo],[RefPartyId],[ProductId])
SELECT [InvoiceStatementId],[InvoiceHeaderId],[InvItemTypeId],[StatusID],[Description],[Income],[Expense],[RefNo],[RefPartyId],[ProductId]
FROM DB052.bodb_Licensee.dbo.LIC_LA_InvoiceStatement WITH (NOLOCK)
SET IDENTITY_INSERT [LA_InvoiceStatement] OFF

SET IDENTITY_INSERT [LA_InvoiceTemplate] ON
INSERT INTO [dbo].[LA_InvoiceTemplate]([InvTemplateId],[InvTemplateName],[TemplatePath])
SELECT [InvTemplateId],[InvTemplateName],[TemplatePath]
FROM DB052.bodb_Licensee.dbo.LIC_LA_InvoiceTemplate WITH (NOLOCK)
SET IDENTITY_INSERT [LA_InvoiceTemplate] OFF

SET IDENTITY_INSERT [LA_HostingFees] ON
INSERT INTO [dbo].[LA_HostingFees]([HostingFeesId],[HostingFeesName],[HostingFeesTypeId],[BaseCurrencyId],[Description])
SELECT [HostingFeesId],[HostingFeesName],[HostingFeesTypeId],[BaseCurrencyId],[Description]
FROM DB052.bodb_Licensee.dbo.LIC_LA_HostingFees WITH (NOLOCK)
SET IDENTITY_INSERT [LA_HostingFees] OFF

SET IDENTITY_INSERT [LA_HostingFeesDetail] ON
INSERT INTO [dbo].[LA_HostingFeesDetail]([HostingFeesDetailId],[HostingFeesId],[BaseCurrencyId],[VCMFrom],[VCMTo],[Amount])
SELECT [HostingFeesDetailId],[HostingFeesId],[BaseCurrencyId],[VCMFrom],[VCMTo],[Amount]
FROM DB052.bodb_Licensee.dbo.LIC_LA_HostingFeesDetail WITH (NOLOCK)
SET IDENTITY_INSERT [LA_HostingFeesDetail] OFF

SET IDENTITY_INSERT [LA_HostingFeesSetting] ON
INSERT INTO [dbo].[LA_HostingFeesSetting]([ChargeId],[SettingType],[ParentId],[FromParty],[ToParty],[FromDate],[ToDate],[ProductName],[FirstBilling],[BasisOfBilling],[BaseCurrencyId],[HostingFeesId],[BasedMinimunFees],[Remark])
SELECT [ChargeId],[SettingType],[ParentId],[FromParty],[ToParty],[FromDate],[ToDate],[ProductName],[FirstBilling],[BasisOfBilling],[BaseCurrencyId],[HostingFeesId],[BasedMinimunFees],[Remark]
FROM DB052.bodb_Licensee.dbo.LIC_LA_HostingFeesSetting WITH (NOLOCK)
SET IDENTITY_INSERT [LA_HostingFeesSetting] OFF

SET IDENTITY_INSERT LA_AnalysisFile ON
INSERT INTO [dbo].[LA_AnalysisFile]([FileId],[PartyIds],[ProductCodes],[Filename],[FromDate],[ToDate],[Status],[IsSkinView])
SELECT [FileId],[PartyIds],[ProductCodes],[Filename],[FromDate],[ToDate],[Status],[IsSkinView]
FROM DB052.bodb_Licensee.dbo.LIC_LA_AnalysisFile WITH (NOLOCK)
SET IDENTITY_INSERT LA_AnalysisFile OFF

INSERT INTO [dbo].[LA_BankInfo]([PartyId],[BankId],[AccountNumber],[BankName],[BankAddress],[IBAN],[BeneficiaryName],[SwiftCode],[CorrespondentBank],[CorrespondentAccountNumber],[CorrespondentAddress],[CorrespondentSwiftCode])
SELECT [PartyId],[BankId],[AccountNumber],[BankName],[BankAddress],[IBAN],[BeneficiaryName],[SwiftCode],[CorrespondentBank],[CorrespondentAccountNumber],[CorrespondentAddress],[CorrespondentSwiftCode]
FROM DB052.bodb_Licensee.dbo.LIC_LA_BankInfo WITH (NOLOCK)

INSERT INTO [dbo].[LA_BillerInfo]([PartyId],[BillerName],[BillerFullName],[StatusId],[CompanyName],[Address1],[Address2],[LogoPath],[Description],[Logo],[LogoHeight],[LogoWidth])
SELECT [PartyId],[BillerName],[BillerFullName],[StatusId],[CompanyName],[Address1],[Address2],[LogoPath],[Description],[Logo],[LogoHeight],[LogoWidth]
FROM DB052.bodb_Licensee.dbo.LIC_LA_BillerInfo WITH (NOLOCK)

SET IDENTITY_INSERT [LA_CombinedGroup] ON
INSERT INTO [dbo].[LA_CombinedGroup]([GroupId],[GroupName],[PathCode])
SELECT [GroupId],[GroupName],[PathCode]
FROM DB052.bodb_Licensee.dbo.LIC_LA_CombinedGroup WITH (NOLOCK)
SET IDENTITY_INSERT [LA_CombinedGroup] OFF

INSERT INTO [dbo].[LA_CombinedGroupAssignment]([GroupId],[PartyId],[GroupType])
SELECT [GroupId],[PartyId],[GroupType]
FROM DB052.bodb_Licensee.dbo.LIC_LA_CombinedGroupAssignment WITH (NOLOCK)

SET IDENTITY_INSERT [LA_HostingFeesTypes] ON
INSERT INTO [dbo].[LA_HostingFeesTypes]([HostingFeesTypeId],[HostingFeesTypeName])
SELECT [HostingFeesTypeId],[HostingFeesTypeName]
FROM DB052.bodb_Licensee.dbo.LIC_LA_HostingFeesTypes WITH (NOLOCK)
SET IDENTITY_INSERT [LA_HostingFeesTypes] OFF

SET IDENTITY_INSERT [LA_InvoiceDetail] ON
INSERT INTO [dbo].[LA_InvoiceDetail]([InvoiceDetailId],[InvoiceHeaderId],[Description],[Reference],[ProductId],[AmountType],[InvoiceAmount])
SELECT [InvoiceDetailId],[InvoiceHeaderId],[Description],[Reference],[ProductId],[AmountType],[InvoiceAmount]
FROM DB052.bodb_Licensee.dbo.LIC_LA_InvoiceDetail WITH (NOLOCK)
SET IDENTITY_INSERT [LA_InvoiceDetail] OFF

INSERT INTO [dbo].[LA_InvoiceFile]([InvoiceHeaderId],[FileData])
SELECT [InvoiceHeaderId],[FileData]
FROM DB052.bodb_Licensee.dbo.LIC_LA_InvoiceFile WITH (NOLOCK)

SET IDENTITY_INSERT [LA_InvoiceType] ON
INSERT INTO [dbo].[LA_InvoiceType]([InvTypeId],[InvTypeName],[IsVisible])
SELECT [InvTypeId],[InvTypeName],[IsVisible]
FROM DB052.bodb_Licensee.dbo.LIC_LA_InvoiceType WITH (NOLOCK)
SET IDENTITY_INSERT [LA_InvoiceType] OFF

INSERT INTO [dbo].[LA_InvoiceTypeMapping]([InvTypeId],[InvItemTypeId])
SELECT [InvTypeId],[InvItemTypeId]
FROM DB052.bodb_Licensee.dbo.LIC_LA_InvoiceTypeMapping WITH (NOLOCK)

SET IDENTITY_INSERT [LA_OnUser] ON
INSERT INTO [dbo].[LA_OnUser]([Custid],[Reload_time],[On_userid],[IP],[iskickedout],[NetSessionID])
SELECT [Custid],[Reload_time],[On_userid],[IP],[iskickedout],[NetSessionID]
FROM DB052.bodb_Licensee.dbo.LIC_LA_OnUser WITH (NOLOCK)
SET IDENTITY_INSERT [LA_OnUser] OFF

SET IDENTITY_INSERT [LA_SettingGroupAssignment] ON
INSERT INTO [dbo].[LA_SettingGroupAssignment]([SettingGroupAssignmentId],[SettingGroupHeaderId],[PartyId],[FromDate],[ToDate],[Status])
SELECT [SettingGroupAssignmentId],[SettingGroupHeaderId],[PartyId],[FromDate],[ToDate],[Status]
FROM DB052.bodb_Licensee.dbo.LIC_LA_SettingGroupAssignment WITH (NOLOCK)
SET IDENTITY_INSERT [LA_SettingGroupAssignment] OFF

SET IDENTITY_INSERT [LA_SettingGroupDetail] ON
INSERT INTO [dbo].[LA_SettingGroupDetail]([SettingGroupDetailId],[SettingGroupHeaderId],[CurrencyId],[TargetAmount],[Period],[Rate],[FromDate],[ToDate],[RestartDate],[Status])
SELECT [SettingGroupDetailId],[SettingGroupHeaderId],[CurrencyId],[TargetAmount],[Period],[Rate],[FromDate],[ToDate],[RestartDate],[Status]
FROM DB052.bodb_Licensee.dbo.LIC_LA_SettingGroupDetail WITH (NOLOCK)
SET IDENTITY_INSERT [LA_SettingGroupDetail] OFF

SET IDENTITY_INSERT [LA_SettingGroupHeader] ON
INSERT INTO [dbo].[LA_SettingGroupHeader]([SettingGroupHeaderId],[GroupName],[SettingGroupType],[Note])
SELECT [SettingGroupHeaderId],[GroupName],[SettingGroupType],[Note]
FROM DB052.bodb_Licensee.dbo.LIC_LA_SettingGroupHeader WITH (NOLOCK)
SET IDENTITY_INSERT [LA_SettingGroupHeader] OFF

INSERT INTO [dbo].[LA_SystemSettings]([Key],[Value])
SELECT [Key],[Value]
FROM DB052.bodb_Licensee.dbo.LIC_LA_SystemSettings WITH (NOLOCK)

SET IDENTITY_INSERT [LA_User] ON
INSERT INTO [dbo].[LA_User]([UserID],[GroupID],[Username],[UserPwd],[DisplayName],[UserSalt],[StatusID],[Creator],[CreatedDate],[ModifiedDate])
SELECT [UserID],[GroupID],[Username],[UserPwd],[DisplayName],[UserSalt],[StatusID],[Creator],[CreatedDate],[ModifiedDate]
FROM DB052.bodb_Licensee.dbo.LIC_LA_User WITH (NOLOCK)
SET IDENTITY_INSERT [LA_User] OFF

SET IDENTITY_INSERT [OAS_OnUser] ON
INSERT INTO [dbo].[OAS_OnUser]([custid],[reload_time],[on_userid],[IP],[iskickedout],[NetSessionID])
SELECT [custid],[reload_time],[on_userid],[IP],[iskickedout],[NetSessionID]
FROM DB052.bodb_Licensee.dbo.LIC_OAS_OnUser WITH (NOLOCK)
SET IDENTITY_INSERT [OAS_OnUser] OFF

SET IDENTITY_INSERT [OAS_Users] ON
INSERT INTO [dbo].[OAS_Users]([UserID],[Username],[UserPwd],[DisplayName],[Role],[UserSalt],[IsActive],[Creator],[CreatedDate],[ModifiedDate],[IsTest])
SELECT [UserID],[Username],[UserPwd],[DisplayName],[Role],[UserSalt],[IsActive],[Creator],[CreatedDate],[ModifiedDate],[IsTest]
FROM DB052.bodb_Licensee.dbo.LIC_OAS_Users WITH (NOLOCK)
SET IDENTITY_INSERT [OAS_Users] OFF

INSERT INTO [dbo].[LA_InvoiceItemType]([SignDB],[GroupDB],[SignSOA],[GroupSOA],[InvItemTypeName],[InvItemTypeId])
SELECT [SignDB],[GroupDB],[SignSOA],[GroupSOA],[InvItemTypeName],[InvItemTypeId]
FROM DB052.bodb_Licensee.dbo.LIC_LA_InvoiceItemType WITH (NOLOCK)