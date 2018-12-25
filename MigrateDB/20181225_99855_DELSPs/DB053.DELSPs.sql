/*
	Created: 20181225@Percy
	DB: DB053
	Task: Rename un-used SPs
	Reference: https://docs.google.com/spreadsheets/d/1YGYSeWIKXnAg2EM60kxEpOMhWElfA2LIhwrb4j_mJNM/edit#gid=523938262
*/
use bodb_Licensee
go 
exec sp_rename 'Lrf_BrowserStatistic', 'DEL_Lrf_BrowserStatistic' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_CustomerUpdSpecialLevel', 'DEL_Lrf_CustomerUpdSpecialLevel' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_CustomerUpdUserSearch', 'DEL_Lrf_CustomerUpdUserSearch' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_GetFunctionStatistic', 'DEL_Lrf_GetFunctionStatistic' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_GetLicenseeStatistic', 'DEL_Lrf_GetLicenseeStatistic' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_GetNonFunctionStatistic', 'DEL_Lrf_GetNonFunctionStatistic' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_GetSystemNameStatistic', 'DEL_Lrf_GetSystemNameStatistic' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_InternalLogin', 'DEL_Lrf_InternalLogin' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_LicenseeCustCommSel', 'DEL_Lrf_LicenseeCustCommSel' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_LicenseeCustCommSel_UAT4', 'DEL_Lrf_LicenseeCustCommSel_UAT4' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_SyncInternalUser', 'DEL_Lrf_SyncInternalUser' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_UpdateUserVisitStatistic', 'DEL_Lrf_UpdateUserVisitStatistic' 
go
use bodb_Licensee
go 
exec sp_rename 'Lrf_UserLogin', 'DEL_Lrf_UserLogin' 
go
use bodb_LicenseeReport
go 
exec sp_rename 'GEN_Customer_Account2', 'DEL_GEN_Customer_Account2' 
go
use bodb_LicenseeReport
go 
exec sp_rename 'GEN_rptKPI_Transfer', 'DEL_GEN_rptKPI_Transfer' 
go
use bodb_PlaytechCS
go 
exec sp_rename 'Task_PTCS_SelLicenseeList', 'DEL_Task_PTCS_SelLicenseeList' 
go
use bodb02
go 
exec sp_rename 'Acc_CustSetting3rd_19', 'DEL_Acc_CustSetting3rd_19' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_12Bet_delete', 'DEL_Acc_Rpt_Winloss_12Bet_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_12Bet_Details_Agent_delete', 'DEL_Acc_Rpt_Winloss_12Bet_Details_Agent_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_12Bet_Details_Agent_xpre_delete', 'DEL_Acc_Rpt_Winloss_12Bet_Details_Agent_xpre_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_12Bet_Details_Member_delete', 'DEL_Acc_Rpt_Winloss_12Bet_Details_Member_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_12Bet_Details_Member_xpre_delete', 'DEL_Acc_Rpt_Winloss_12Bet_Details_Member_xpre_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_12Bet_xpre_delete', 'DEL_Acc_Rpt_Winloss_12Bet_xpre_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_AB88_delete', 'DEL_Acc_Rpt_Winloss_AB88_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_AB88_Details_Agent_delete', 'DEL_Acc_Rpt_Winloss_AB88_Details_Agent_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_AB88_Details_delete', 'DEL_Acc_Rpt_Winloss_AB88_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_AB88_Details_Member_delete', 'DEL_Acc_Rpt_Winloss_AB88_Details_Member_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_AB88_Details_xpre_delete', 'DEL_Acc_Rpt_Winloss_AB88_Details_xpre_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_AB88_xpre_delete', 'DEL_Acc_Rpt_Winloss_AB88_xpre_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_ALog_delete', 'DEL_Acc_Rpt_Winloss_ALog_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_ALog_Details_delete', 'DEL_Acc_Rpt_Winloss_ALog_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Bezbet_delete', 'DEL_Acc_Rpt_Winloss_Bezbet_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Bezbet_Details_delete', 'DEL_Acc_Rpt_Winloss_Bezbet_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Dela_delete', 'DEL_Acc_Rpt_Winloss_Dela_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Dela_Details_delete', 'DEL_Acc_Rpt_Winloss_Dela_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_M88_delete', 'DEL_Acc_Rpt_Winloss_M88_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_M88_Details_delete', 'DEL_Acc_Rpt_Winloss_M88_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_M88_Details_xpre_delete', 'DEL_Acc_Rpt_Winloss_M88_Details_xpre_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_M88_Details_xtest_delete', 'DEL_Acc_Rpt_Winloss_M88_Details_xtest_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_M88_xpre_delete', 'DEL_Acc_Rpt_Winloss_M88_xpre_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_MayFair_delete', 'DEL_Acc_Rpt_Winloss_MayFair_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_MayFair_Details_delete', 'DEL_Acc_Rpt_Winloss_MayFair_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Spondemo_delete', 'DEL_Acc_Rpt_Winloss_Spondemo_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Spondemo_Details_delete', 'DEL_Acc_Rpt_Winloss_Spondemo_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_SunCity_delete', 'DEL_Acc_Rpt_Winloss_SunCity_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_SunCity_Details_delete', 'DEL_Acc_Rpt_Winloss_SunCity_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_TLC_delete', 'DEL_Acc_Rpt_Winloss_TLC_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_TLC_Details_delete', 'DEL_Acc_Rpt_Winloss_TLC_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Zzun88_delete', 'DEL_Acc_Rpt_Winloss_Zzun88_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_Rpt_Winloss_Zzun88_Details_delete', 'DEL_Acc_Rpt_Winloss_Zzun88_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Acc_UserLog_LoginSel_xtest', 'DEL_Acc_UserLog_LoginSel_xtest' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_12Bet_delete', 'DEL_Lbs_Rpt_Winloss_12Bet_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_12Bet_Details_Agent_delete', 'DEL_Lbs_Rpt_Winloss_12Bet_Details_Agent_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_12Bet_Details_Member_delete', 'DEL_Lbs_Rpt_Winloss_12Bet_Details_Member_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_AB88_delete', 'DEL_Lbs_Rpt_Winloss_AB88_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_AB88_Details_delete', 'DEL_Lbs_Rpt_Winloss_AB88_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_ALog_delete', 'DEL_Lbs_Rpt_Winloss_ALog_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_ALog_Details_delete', 'DEL_Lbs_Rpt_Winloss_ALog_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_Dela_delete', 'DEL_Lbs_Rpt_Winloss_Dela_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_Dela_Details_delete', 'DEL_Lbs_Rpt_Winloss_Dela_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_M88_delete', 'DEL_Lbs_Rpt_Winloss_M88_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_M88_Details_delete', 'DEL_Lbs_Rpt_Winloss_M88_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_Spondemo_delete', 'DEL_Lbs_Rpt_Winloss_Spondemo_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_Spondemo_Details_delete', 'DEL_Lbs_Rpt_Winloss_Spondemo_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_TLC_delete', 'DEL_Lbs_Rpt_Winloss_TLC_delete' 
go
use bodb02
go 
exec sp_rename 'Lbs_Rpt_Winloss_TLC_Details_delete', 'DEL_Lbs_Rpt_Winloss_TLC_Details_delete' 
go
use bodb02
go 
exec sp_rename 'Task_Exchange_HistoryIns_delete', 'DEL_Task_Exchange_HistoryIns_delete' 
go
use bodb02
go 
exec sp_rename 'Task_Exchange_HistoryIns_xtest_delete', 'DEL_Task_Exchange_HistoryIns_xtest_delete' 
go
use bodb02
go 
exec sp_rename 'Task_ExternalSettlement_CleanUp_delete', 'DEL_Task_ExternalSettlement_CleanUp_delete' 
go
use bodb02
go 
exec sp_rename 'Task_ExternalSettlement_thien_delete', 'DEL_Task_ExternalSettlement_thien_delete' 
go
use bodb02
go 
exec sp_rename 'Task_ExternalSettlement_Verification_delete', 'DEL_Task_ExternalSettlement_Verification_delete' 
go
use bodb02
go 
exec sp_rename 'WriteLog_UserLog_Login', 'DEL_WriteLog_UserLog_Login' 
go