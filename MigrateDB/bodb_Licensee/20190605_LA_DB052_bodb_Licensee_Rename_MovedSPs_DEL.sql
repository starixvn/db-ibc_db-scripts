use [bodb_Licensee]
go

/*
	Created: 20190605@Percy
	DB: DB052.bodb_Licensee
	Task: Moved SPs - Rename to DEL_
*/

sp_rename 'LA_AnalysisFileIns', 'DEL_LA_AnalysisFileIns'
go
sp_rename 'LA_AnalysisFileSel', 'DEL_LA_AnalysisFileSel'
go
sp_rename 'LA_AnalysisFileStatusSel', 'DEL_LA_AnalysisFileStatusSel'
go
sp_rename 'LA_AnalysisFileUpd', 'DEL_LA_AnalysisFileUpd'
go
sp_rename 'LA_BankInfoSel', 'DEL_LA_BankInfoSel'
go
sp_rename 'LA_BillerDel', 'DEL_LA_BillerDel'
go
sp_rename 'LA_BillerInfoSel', 'DEL_LA_BillerInfoSel'
go
sp_rename 'LA_BillerListSel', 'DEL_LA_BillerListSel'
go
sp_rename 'LA_BillerLogoSel', 'DEL_LA_BillerLogoSel'
go
sp_rename 'LA_BillerLogoUpd', 'DEL_LA_BillerLogoUpd'
go
sp_rename 'LA_BillerModify', 'DEL_LA_BillerModify'
go
sp_rename 'LA_ChargeRateGroupChange', 'DEL_LA_ChargeRateGroupChange'
go
sp_rename 'LA_ChargeRateSettingDel', 'DEL_LA_ChargeRateSettingDel'
go
sp_rename 'LA_ChargeRateSettingModify', 'DEL_LA_ChargeRateSettingModify'
go
sp_rename 'LA_ChargeRateValidate', 'DEL_LA_ChargeRateValidate'
go
sp_rename 'LA_CreateUser', 'DEL_LA_CreateUser'
go
sp_rename 'LA_CumulativeRebateGroupInfoSel', 'DEL_LA_CumulativeRebateGroupInfoSel'
go
sp_rename 'LA_Discount_HasBilling', 'DEL_LA_Discount_HasBilling'
go
sp_rename 'LA_Discount_PartyHasBillingSel', 'DEL_LA_Discount_PartyHasBillingSel'
go
sp_rename 'LA_Discount_ValidatePayerAssignment', 'DEL_LA_Discount_ValidatePayerAssignment'
go
sp_rename 'LA_DiscountAssignmentSettingDel', 'DEL_LA_DiscountAssignmentSettingDel'
go
sp_rename 'LA_DiscountDel', 'DEL_LA_DiscountDel'
go
sp_rename 'LA_DiscountGroupDel', 'DEL_LA_DiscountGroupDel'
go
sp_rename 'LA_DiscountIns', 'DEL_LA_DiscountIns'
go
sp_rename 'LA_DiscountModify', 'DEL_LA_DiscountModify'
go
sp_rename 'LA_DiscountUpd', 'DEL_LA_DiscountUpd'
go
sp_rename 'LA_FunctionGroupIns', 'DEL_LA_FunctionGroupIns'
go
sp_rename 'LA_FunctionGroupSel', 'DEL_LA_FunctionGroupSel'
go
sp_rename 'LA_FunctionIns', 'DEL_LA_FunctionIns'
go
sp_rename 'LA_FunctionPartiesPermission', 'DEL_LA_FunctionPartiesPermission'
go
sp_rename 'LA_FunctionPartysModify', 'DEL_LA_FunctionPartysModify'
go
sp_rename 'LA_FunctionSel', 'DEL_LA_FunctionSel'
go
sp_rename 'LA_FunctionSelByGroup', 'DEL_LA_FunctionSelByGroup'
go
sp_rename 'LA_FunctionSelByUser', 'DEL_LA_FunctionSelByUser'
go
sp_rename 'LA_FunctionUpd', 'DEL_LA_FunctionUpd'
go
sp_rename 'LA_FunctionUpdIsActive', 'DEL_LA_FunctionUpdIsActive'
go
sp_rename 'LA_GroupSel', 'DEL_LA_GroupSel'
go
sp_rename 'LA_HostingFeesChargeRateIns', 'DEL_LA_HostingFeesChargeRateIns'
go
sp_rename 'LA_HostingFeesChargeRateSel', 'DEL_LA_HostingFeesChargeRateSel'
go
sp_rename 'LA_HostingFeesDel', 'DEL_LA_HostingFeesDel'
go
sp_rename 'LA_HostingFeesIns', 'DEL_LA_HostingFeesIns'
go
sp_rename 'LA_HostingFeesPayerSettingsDel', 'DEL_LA_HostingFeesPayerSettingsDel'
go
sp_rename 'LA_HostingFeesPayerSettingsSel', 'DEL_LA_HostingFeesPayerSettingsSel'
go
sp_rename 'LA_HostingFeesSel', 'DEL_LA_HostingFeesSel'
go
sp_rename 'LA_HostingFeesUpd', 'DEL_LA_HostingFeesUpd'
go
sp_rename 'LA_Inv_AmfPartySel', 'DEL_LA_Inv_AmfPartySel'
go
sp_rename 'LA_Inv_BankInfoGet', 'DEL_LA_Inv_BankInfoGet'
go
sp_rename 'LA_Inv_ChargeRateInfoGet', 'DEL_LA_Inv_ChargeRateInfoGet'
go
sp_rename 'LA_Inv_HostingFeeSettlement', 'DEL_LA_Inv_HostingFeeSettlement'
go
sp_rename 'LA_Inv_InvoiceBillerInfoGet', 'DEL_LA_Inv_InvoiceBillerInfoGet'
go
sp_rename 'LA_Inv_InvoiceFileGet', 'DEL_LA_Inv_InvoiceFileGet'
go
sp_rename 'LA_Inv_InvoiceFileIns', 'DEL_LA_Inv_InvoiceFileIns'
go
sp_rename 'LA_Inv_InvoiceInfoDel', 'DEL_LA_Inv_InvoiceInfoDel'
go
sp_rename 'LA_Inv_InvoiceInfoGet', 'DEL_LA_Inv_InvoiceInfoGet'
go
sp_rename 'LA_Inv_InvoiceInfoInsert', 'DEL_LA_Inv_InvoiceInfoInsert'
go
sp_rename 'LA_Inv_InvoiceListGet', 'DEL_LA_Inv_InvoiceListGet'
go
sp_rename 'LA_Inv_InvoiceMetadataSel', 'DEL_LA_Inv_InvoiceMetadataSel'
go
sp_rename 'LA_Inv_InvoiceMetadataUpd', 'DEL_LA_Inv_InvoiceMetadataUpd'
go
sp_rename 'LA_Inv_InvoicePathSel', 'DEL_LA_Inv_InvoicePathSel'
go
sp_rename 'LA_Inv_InvoiceReferenceGet', 'DEL_LA_Inv_InvoiceReferenceGet'
go
sp_rename 'LA_Inv_InvoiceStatusUpd', 'DEL_LA_Inv_InvoiceStatusUpd'
go
sp_rename 'LA_Inv_InvoiceTypeGet', 'DEL_LA_Inv_InvoiceTypeGet'
go
sp_rename 'LA_Inv_InvoiceTypeInfoGet', 'DEL_LA_Inv_InvoiceTypeInfoGet'
go
sp_rename 'LA_Inv_PrepaidPartySel', 'DEL_LA_Inv_PrepaidPartySel'
go
sp_rename 'LA_Inv_TransferAmfAmount', 'DEL_LA_Inv_TransferAmfAmount'
go
sp_rename 'LA_InvoiceSettingDel', 'DEL_LA_InvoiceSettingDel'
go
sp_rename 'LA_InvoiceSettingModify', 'DEL_LA_InvoiceSettingModify'
go
sp_rename 'LA_InvoiceSettingSel', 'DEL_LA_InvoiceSettingSel'
go
sp_rename 'LA_InvoiceTemplateListSel', 'DEL_LA_InvoiceTemplateListSel'
go
sp_rename 'LA_InvoiceTypeListSel', 'DEL_LA_InvoiceTypeListSel'
go
sp_rename 'LA_LaunchLicensee', 'DEL_LA_LaunchLicensee'
go
sp_rename 'LA_LaunchLicensee_ChargeInfoIns', 'DEL_LA_LaunchLicensee_ChargeInfoIns'
go
sp_rename 'LA_LaunchLicensee_MinFeeIns', 'DEL_LA_LaunchLicensee_MinFeeIns'
go
sp_rename 'LA_LaunchLicensee_PartyIns', 'DEL_LA_LaunchLicensee_PartyIns'
go
sp_rename 'LA_LaunchLicensee_Rollback', 'DEL_LA_LaunchLicensee_Rollback'
go
sp_rename 'LA_LicPerformanceAnalysisStatusUpd', 'DEL_LA_LicPerformanceAnalysisStatusUpd'
go
sp_rename 'LA_MinFeeSettingDel', 'DEL_LA_MinFeeSettingDel'
go
sp_rename 'LA_MinFeeSettingModify', 'DEL_LA_MinFeeSettingModify'
go
sp_rename 'LA_PayerDiscountAssignmentModify', 'DEL_LA_PayerDiscountAssignmentModify'
go
sp_rename 'LA_PayerGroupAssignmentModify', 'DEL_LA_PayerGroupAssignmentModify'
go
sp_rename 'LA_PayerGroupDel', 'DEL_LA_PayerGroupDel'
go
sp_rename 'LA_PayerGroupModify', 'DEL_LA_PayerGroupModify'
go
sp_rename 'LA_PayerInfoSel', 'DEL_LA_PayerInfoSel'
go
sp_rename 'LA_PayerListSel', 'DEL_LA_PayerListSel'
go
sp_rename 'LA_PayerModify', 'DEL_LA_PayerModify'
go
sp_rename 'LA_PayerNonOfficialIns', 'DEL_LA_PayerNonOfficialIns'
go
sp_rename 'LA_PayerSettingDel', 'DEL_LA_PayerSettingDel'
go
sp_rename 'LA_PayerSettingModify', 'DEL_LA_PayerSettingModify'
go
sp_rename 'LA_Rebate_HasBilling', 'DEL_LA_Rebate_HasBilling'
go
sp_rename 'LA_RebateDel', 'DEL_LA_RebateDel'
go
sp_rename 'LA_RebateGet', 'DEL_LA_RebateGet'
go
sp_rename 'LA_RebateIns', 'DEL_LA_RebateIns'
go
sp_rename 'LA_RebateSel', 'DEL_LA_RebateSel'
go
sp_rename 'LA_RebateUpd', 'DEL_LA_RebateUpd'
go
sp_rename 'LA_Rpt_AGPrepaymentSummary', 'DEL_LA_Rpt_AGPrepaymentSummary'
go
sp_rename 'LA_Rpt_AmfSummary', 'DEL_LA_Rpt_AmfSummary'
go
sp_rename 'LA_Rpt_CumulativeSBRebateSettlement', 'DEL_LA_Rpt_CumulativeSBRebateSettlement'
go
sp_rename 'LA_SystemSettingsBriefSel', 'DEL_LA_SystemSettingsBriefSel'
go
sp_rename 'LA_SystemSettingsGet', 'DEL_LA_SystemSettingsGet'
go
sp_rename 'LA_SystemSettingsUpd', 'DEL_LA_SystemSettingsUpd'
go
sp_rename 'LA_UpdateUser', 'DEL_LA_UpdateUser'
go
sp_rename 'LA_User_ReCheckIn', 'DEL_LA_User_ReCheckIn'
go
sp_rename 'LA_UserCheckIn', 'DEL_LA_UserCheckIn'
go
sp_rename 'LA_UserFunctionModify', 'DEL_LA_UserFunctionModify'
go
sp_rename 'LA_UserLogin', 'DEL_LA_UserLogin'
go
sp_rename 'LA_UserLogout', 'DEL_LA_UserLogout'
go
sp_rename 'LA_UserModify', 'DEL_LA_UserModify'
go
sp_rename 'LA_UserPartyModify', 'DEL_LA_UserPartyModify'
go
sp_rename 'LA_UserPasswordUpd', 'DEL_LA_UserPasswordUpd'
go
sp_rename 'LA_UserPwdReset', 'DEL_LA_UserPwdReset'
go
sp_rename 'LA_UserSaltGet', 'DEL_LA_UserSaltGet'
go
sp_rename 'LA_UserSelAll', 'DEL_LA_UserSelAll'
go
sp_rename 'LA_UserSelByUserID', 'DEL_LA_UserSelByUserID'
go
sp_rename 'LA_UserSelByUserName', 'DEL_LA_UserSelByUserName'
go
sp_rename 'LA_UsersSelByUserID', 'DEL_LA_UsersSelByUserID'
go
sp_rename 'LA_UsersSelByUserName', 'DEL_LA_UsersSelByUserName'
go
sp_rename 'LA_UserUpdIsActive', 'DEL_LA_UserUpdIsActive'
go