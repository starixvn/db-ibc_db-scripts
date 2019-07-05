-- DB052
use bodb_licensee
go

/*
	Created: 20190705@Percy
	DB: DB052.bodb_Licensee
	Task: Backup table - Will insert data into DBCUST.bodb_Licensee
*/

-- 28 migrated tables + 19 moved tables = 47 tables

-- 10 
select * into LIC_LA_AnalysisFile
from dbo.LA_AnalysisFile with (nolock)
go

-- 11 
select * into LIC_LA_BankInfo
from dbo.LA_BankInfo with (nolock)
go

-- 12 
select * into LIC_LA_BillerInfo
from dbo.LA_BillerInfo with (nolock)
go

-- 13 
select * into LIC_LA_ChargeInfo_MinFee
from dbo.LA_ChargeInfo_MinFee with (nolock)
go

-- 14 
select * into LIC_LA_ChargeInfo_SystemMapping
from dbo.LA_ChargeInfo_SystemMapping with (nolock)
go

-- 15 
select * into LIC_LA_CombinedGroup
from dbo.LA_CombinedGroup with (nolock)
go

-- 16 
select * into LIC_LA_CombinedGroupAssignment
from dbo.LA_CombinedGroupAssignment with (nolock)
go

-- 17 
select * into LIC_LA_DiscountGroupAssignment
from dbo.LA_DiscountGroupAssignment with (nolock)
go

-- 18 
select * into LIC_LA_DiscountGroupCurrency
from dbo.LA_DiscountGroupCurrency with (nolock)
go

-- 19 
select * into LIC_LA_DiscountGroupDetail
from dbo.LA_DiscountGroupDetail with (nolock)
go

-- 20 
select * into LIC_LA_DiscountGroupHeader
from dbo.LA_DiscountGroupHeader with (nolock)
go

-- 21 
select * into LIC_LA_DiscountGroupProduct
from dbo.LA_DiscountGroupProduct with (nolock)
go

-- 22 
select * into LIC_LA_Function
from dbo.LA_Function with (nolock)
go

-- 23 
select * into LIC_LA_FunctionParty
from dbo.LA_FunctionParty with (nolock)
go

-- 24 
select * into LIC_LA_Group
from dbo.LA_Group with (nolock)
go

-- 25 
select * into LIC_LA_GroupFunction
from dbo.LA_GroupFunction with (nolock)
go

-- 26 
select * into LIC_LA_HostingFees
from dbo.LA_HostingFees with (nolock)
go

-- 27 
select * into LIC_LA_HostingFeesDetail
from dbo.LA_HostingFeesDetail with (nolock)
go

-- 28 
select * into LIC_LA_HostingFeesSetting
from dbo.LA_HostingFeesSetting with (nolock)
go

-- 29 
select * into LIC_LA_HostingFeesTypes
from dbo.LA_HostingFeesTypes with (nolock)
go

-- 30 
select * into LIC_LA_InvoiceDetail
from dbo.LA_InvoiceDetail with (nolock)
go

-- 31 
select * into LIC_LA_InvoiceFile
from dbo.LA_InvoiceFile with (nolock)
go

-- 32 
select * into LIC_LA_InvoiceHeader
from dbo.LA_InvoiceHeader with (nolock)
go

-- 33 
select * into LIC_LA_InvoiceItemType
from dbo.LA_InvoiceItemType with (nolock)
go

-- 34 
select * into LIC_LA_InvoiceSetting
from dbo.LA_InvoiceSetting with (nolock)
go

-- 35 
select * into LIC_LA_InvoiceStatement
from dbo.LA_InvoiceStatement with (nolock)
go

-- 36 
select * into LIC_LA_InvoiceTemplate
from dbo.LA_InvoiceTemplate with (nolock)
go

-- 37 
select * into LIC_LA_InvoiceType
from dbo.LA_InvoiceType with (nolock)
go

-- 38 
select * into LIC_LA_InvoiceTypeMapping
from dbo.LA_InvoiceTypeMapping with (nolock)
go

-- 40 
select * into LIC_LA_MinFee
from dbo.LA_MinFee with (nolock)
go

-- 41 
select * into LIC_LA_OnUser
from dbo.LA_OnUser with (nolock)
go

-- 42 
select * into LIC_LA_PartyGroup
from dbo.LA_PartyGroup with (nolock)
go

-- 43 
select * into LIC_LA_PartyGroupAssignment
from dbo.LA_PartyGroupAssignment with (nolock)
go

-- 44 
select * into LIC_LA_Product3rdSub
from dbo.LA_Product3rdSub with (nolock)
go

-- 45 
select * into LIC_LA_SettingGroupAssignment
from dbo.LA_SettingGroupAssignment with (nolock)
go

-- 46 
select * into LIC_LA_SettingGroupDetail
from dbo.LA_SettingGroupDetail with (nolock)
go

-- 47 
select * into LIC_LA_SettingGroupHeader
from dbo.LA_SettingGroupHeader with (nolock)
go

-- 48 
select * into LIC_LA_SystemSettings
from dbo.LA_SystemSettings with (nolock)
go

-- 49 
select * into LIC_LA_User
from dbo.LA_User with (nolock)
go

-- 50 
select * into LIC_LA_UserFunction
from dbo.LA_UserFunction with (nolock)
go

-- 51 
select * into LIC_LA_UserParty
from dbo.LA_UserParty with (nolock)
go

-- 76 
select * into LIC_OAS_ChargeInfo
from dbo.OAS_ChargeInfo with (nolock)
go

-- 77 
select * into LIC_OAS_ChargeInfoSub
from dbo.OAS_ChargeInfoSub with (nolock)
go

-- 80 
select * into LIC_OAS_OnUser
from dbo.OAS_OnUser with (nolock)
go

-- 81 
select * into LIC_OAS_Party
from dbo.OAS_Party with (nolock)
go

-- 82 
select * into LIC_OAS_PartyDetail
from dbo.OAS_PartyDetail with (nolock)
go

-- 85 
select * into LIC_OAS_Users
from dbo.OAS_Users with (nolock)
go
