use [bodb_Licensee]
go

/*
	Created: 20190605@Percy
	DB: DB052.bodb_Licensee
	Task: Un-used SPs - Rename to DEL_
*/

sp_rename 'IMS_LicenseeBillingInfoSel', 'DEL_IMS_LicenseeBillingInfoSel'
go
sp_rename 'LA_Discount_PartyListSel', 'DEL_LA_Discount_PartyListSel'
go
sp_rename 'LA_DiscountGroupEditSel', 'DEL_LA_DiscountGroupEditSel'
go
sp_rename 'LA_DiscountGroupInfoSel', 'DEL_LA_DiscountGroupInfoSel'
go
sp_rename 'LA_DiscountGroupListSel', 'DEL_LA_DiscountGroupListSel'
go
sp_rename 'LA_DiscountGroupValidListSel', 'DEL_LA_DiscountGroupValidListSel'
go
sp_rename 'LA_FunctionPartyIns', 'DEL_LA_FunctionPartyIns'
go
sp_rename 'LA_Rpt_CockFightingWinLoss', 'DEL_LA_Rpt_CockFightingWinLoss'
go
sp_rename 'LA_Rpt_MacauWinloss', 'DEL_LA_Rpt_MacauWinloss'
go
sp_rename 'LA_UserPartyIns', 'DEL_LA_UserPartyIns'
go
sp_rename 'LA_Rpt_3rdPartyProductWinloss', 'DEL_LA_Rpt_3rdPartyProductWinloss'
go
sp_rename 'LA_Rpt_GetTotalTicket', 'DEL_LA_Rpt_GetTotalTicket'
go
sp_rename 'LA_Rpt_LicWinloss', 'DEL_LA_Rpt_LicWinloss'
go
sp_rename 'LA_Rpt_LicWinloss_Details', 'DEL_LA_Rpt_LicWinloss_Details'
go
sp_rename 'LA_Rpt_ThirdPartyProductWinloss', 'DEL_LA_Rpt_ThirdPartyProductWinloss'
go
sp_rename 'Lrf_BetList_MobileReport_SelWinloss_Mem', 'DEL_Lrf_BetList_MobileReport_SelWinloss_Mem'
go
sp_rename 'Lrf_Rpt_MobileWinlossDetail_Ag', 'DEL_Lrf_Rpt_MobileWinlossDetail_Ag'
go