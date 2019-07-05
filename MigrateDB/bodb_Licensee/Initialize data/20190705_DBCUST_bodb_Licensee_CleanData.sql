-- DBCUST
use bodb_licensee
go

/*
	Created: 20190705@Percy
	DB: DBCUST.bodb_Licensee
	Task: Clean data on DBCUST.bodb_Licensee
*/

-- 28 migrated tables + 19 moved tables = 47 tables

-- 10 
delete dbo.LA_AnalysisFile with (rowlock, updlock)
go

-- 11 
delete dbo.LA_BankInfo with (rowlock, updlock)
go

-- 12 
delete dbo.LA_BillerInfo with (rowlock, updlock)
go

-- 13 
delete dbo.LA_ChargeInfo_MinFee with (rowlock, updlock)
go

-- 14 
delete dbo.LA_ChargeInfo_SystemMapping with (rowlock, updlock)
go

-- 15 
delete dbo.LA_CombinedGroup with (rowlock, updlock)
go

-- 16 
delete dbo.LA_CombinedGroupAssignment with (rowlock, updlock)
go

-- 17 
delete dbo.LA_DiscountGroupAssignment with (rowlock, updlock)
go

-- 18 
delete dbo.LA_DiscountGroupCurrency with (rowlock, updlock)
go

-- 19 
delete dbo.LA_DiscountGroupDetail with (rowlock, updlock)
go

-- 20 
delete dbo.LA_DiscountGroupHeader with (rowlock, updlock)
go

-- 21 
delete dbo.LA_DiscountGroupProduct with (rowlock, updlock)
go

-- 22 
delete dbo.LA_Function with (rowlock, updlock)
go

-- 23 
delete dbo.LA_FunctionParty with (rowlock, updlock)
go

-- 24 
delete dbo.LA_Group with (rowlock, updlock)
go

-- 25 
delete dbo.LA_GroupFunction with (rowlock, updlock)
go

-- 26 
delete dbo.LA_HostingFees with (rowlock, updlock)
go

-- 27 
delete dbo.LA_HostingFeesDetail with (rowlock, updlock)
go

-- 28 
delete dbo.LA_HostingFeesSetting with (rowlock, updlock)
go

-- 29 
delete dbo.LA_HostingFeesTypes with (rowlock, updlock)
go

-- 30 
delete dbo.LA_InvoiceDetail with (rowlock, updlock)
go

-- 31 
delete dbo.LA_InvoiceFile with (rowlock, updlock)
go

-- 32 
delete dbo.LA_InvoiceHeader with (rowlock, updlock)
go

-- 33 
delete dbo.LA_InvoiceItemType with (rowlock, updlock)
go

-- 34 
delete dbo.LA_InvoiceSetting with (rowlock, updlock)
go

-- 35 
delete dbo.LA_InvoiceStatement with (rowlock, updlock)
go

-- 36 
delete dbo.LA_InvoiceTemplate with (rowlock, updlock)
go

-- 37 
delete dbo.LA_InvoiceType with (rowlock, updlock)
go

-- 38 
delete dbo.LA_InvoiceTypeMapping with (rowlock, updlock)
go

-- 40 
delete dbo.LA_MinFee with (rowlock, updlock)
go

-- 41 
delete dbo.LA_OnUser with (rowlock, updlock)
go

-- 42 
delete dbo.LA_PartyGroup with (rowlock, updlock)
go

-- 43 
delete dbo.LA_PartyGroupAssignment with (rowlock, updlock)
go

-- 44 
delete dbo.LA_Product3rdSub with (rowlock, updlock)
go

-- 45 
delete dbo.LA_SettingGroupAssignment with (rowlock, updlock)
go

-- 46 
delete dbo.LA_SettingGroupDetail with (rowlock, updlock)
go

-- 47 
delete dbo.LA_SettingGroupHeader with (rowlock, updlock)
go

-- 48 
delete dbo.LA_SystemSettings with (rowlock, updlock)
go

-- 49 
delete dbo.LA_User with (rowlock, updlock)
go

-- 50 
delete dbo.LA_UserFunction with (rowlock, updlock)
go

-- 51 
delete dbo.LA_UserParty with (rowlock, updlock)
go

-- 76 
delete dbo.OAS_ChargeInfo with (rowlock, updlock)
go

-- 77 
delete dbo.OAS_ChargeInfoSub with (rowlock, updlock)
go

-- 80 
delete dbo.OAS_OnUser with (rowlock, updlock)
go

-- 81 
delete dbo.OAS_Party with (rowlock, updlock)
go

-- 82 
delete dbo.OAS_PartyDetail with (rowlock, updlock)
go

-- 85 
delete dbo.OAS_Users with (rowlock, updlock)
go
